#!/usr/bin/env python3
"""
I²C Decoder + XOR Decryption

This script reconstructs I²C transactions from pre-parsed SDA events,
extracts data sent to a target device, and decrypts it using a repeating XOR key.

Pipeline:
    SDA events → bit reconstruction → bytes → transactions
    → filter by address → payload → XOR decrypt → output

Key I²C concepts:
- Data is sampled on clock edges (preprocessed into markers here)
- Each byte = 8 bits (MSB-first)
- Every 9th bit is ACK → ignored
- First byte = address + R/W bit
"""

import json
from collections import defaultdict

# XOR key recovered from previous stage (SPI)
XOR_KEY = b"bananza"

# Target I²C device address
TARGET_ADDR = 0x3C


# ----------------------------
# 1. Load SDA events
# ----------------------------
def load_sda(path):
    """
    Load SDA event stream from the given JSON file.
    """
    events = []

    with open(path, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            events.append(json.loads(line))

    return events


# ----------------------------
# 2. Decode I²C transactions
# ----------------------------
def decode_i2c(events):
    """
    Convert annotated SDA events into structured I²C transactions.

    Expected markers:
    - start        → begin transaction
    - address-bit  → bit of address byte
    - data-bit     → bit of data byte
    - ack-bit      → acknowledgment (ignored)
    - stop         → end transaction
    """

    transactions = []

    current = None

    # Stores bits per byte index
    # Example:
    #   byteIndex 0 → address byte
    #   byteIndex 1+ → data bytes
    bytes_by_index = defaultdict(lambda: [0] * 8)

    for e in events:
        marker = e.get("marker")

        # ----------------------------
        # Start condition
        # ----------------------------
        if marker == "start":
            current = {
                "address": None,
                "data": []
            }
            bytes_by_index.clear()

        # ----------------------------
        # Collect bits
        # ----------------------------
        elif marker in ("address-bit", "data-bit"):
            bi = e["byteIndex"]   # which byte
            bit = e["bitIndex"]   # bit position (0–7)
            bytes_by_index[bi][bit] = e["v"]

        # ----------------------------
        # Ignore ACK bits
        # ----------------------------
        elif marker == "ack-bit":
            pass

        # ----------------------------
        # Stop condition → finalize transaction
        # ----------------------------
        elif marker == "stop" and current is not None:

            # Build bytes (MSB-first)
            for bi in sorted(bytes_by_index.keys()):
                bits = bytes_by_index[bi]

                value = 0
                for b in bits:
                    value = (value << 1) | b

                if bi == 0:
                    # First byte = address + R/W bit
                    # Let's strip the R/W bit (LSB) to get the 7-bit address
                    current["address"] = value >> 1
                else:
                    current["data"].append(value)

            transactions.append(current)

            current = None
            bytes_by_index.clear()

    return transactions


# ----------------------------
# 3. XOR decrypt
# ----------------------------
def xor_decrypt(data, key):
    """
    Decrypt data using repeating XOR key.
    """
    out = bytearray()

    for i, b in enumerate(data):
        out.append(b ^ key[i % len(key)])

    return bytes(out)


# ----------------------------
# Main
# ----------------------------
def main():
    events = load_sda("sda.json")

    txs = decode_i2c(events)

    print(f"[+] Decoded {len(txs)} I2C transactions\n")

    payload = bytearray()

    for i, tx in enumerate(txs):
        addr = tx["address"]
        data = tx["data"]

        print(f"[*] TX {i}: addr=0x{addr:02X} data={data}")

        # Collect data only from target device
        if addr == TARGET_ADDR:
            payload.extend(data)

    # ----------------------------
    # Output raw payload
    # ----------------------------
    print("\n[*] [Raw ASCII]")
    print(payload.decode(errors="replace"))

    # ----------------------------
    # XOR decrypt
    # ----------------------------
    decrypted = xor_decrypt(payload, XOR_KEY)

    print("\n[*] [Hex]")
    print(decrypted.hex(" "))

    print("\n[+] [Decrypted ASCII]")
    print(decrypted.decode(errors="replace"))


if __name__ == "__main__":
    main()
