#!/usr/bin/env python3
"""
SPI Decoder + XOR Decryption

This script reconstructs SPI communication by:
1. Sampling MOSI data at SCK-defined sample points
2. Converting sampled bits into bytes (MSB-first)
3. Decrypting the resulting data using a repeating XOR key

Key SPI concepts:
- SCK defines *when* to sample
- MOSI defines *what* to sample
- Data is typically MSB-first

Input files:
- sck.json  → contains clock sample markers
- mosi.json → contains MOSI signal transitions

Output:
- Raw decoded bytes (ASCII view)
- XOR-decrypted message
"""

import json
from bisect import bisect_right
import sys

# XOR key recovered from previous stage (e.g., 1-Wire)
XOR_KEY = b"icy"


# ----------------------------
# 1. Load SCK sample times
# ----------------------------
def load_sck_samples(filename):
    """
    Extract SCK sample timestamps from given JSON file.

    We extract timestamps where the SPI clock indicates
    a valid sampling point (e.g., rising edge or explicit marker).

    These timestamps define *when* to read MOSI.
    """
    sck_samples = []

    with open(filename, "r") as f:
        for line in f:
            e = json.loads(line)

            # Only use sample markers (pre-processed clock edges)
            if e.get("marker") == "sample":
                sck_samples.append(e["t"])

    return sck_samples


# ----------------------------
# 2. Load MOSI transitions
# ----------------------------
def load_mosi_events(filename):
    """
    Load MOSI transitions as sorted (time, value) pairs.

    MOSI is not sampled directly. We reconstruct its value
    at arbitrary timestamps by tracking its last known state.

    We store:
    - timestamps of transitions
    - corresponding signal values
    """
    mosi_events = []

    with open(filename, "r") as f:
        for line in f:
            e = json.loads(line)
            mosi_events.append((e["t"], int(e["v"])))

    # Ensure chronological order
    mosi_events.sort()

    # Split into parallel arrays for fast lookup
    mosi_times = [t for t, _ in mosi_events]
    mosi_values  = [v for _, v in mosi_events]

    return mosi_times, mosi_values



# ----------------------------
# 3. Sample MOSI at SCK edges
# ----------------------------
def sample_mosi(sck_samples, mosi_times, mosi_values):
    """
    Sample MOSI values at SCK-defined timestamps using binary search.

    For each SCK sample time:
    - Find the most recent MOSI transition BEFORE that time
    - Use that value as the sampled bit

    We use binary search (bisect) for efficiency:
    O(log n) per lookup instead of O(n)
    """
    bits = []

    for t in sck_samples:
        # Find insertion point, then step back to last known value
        idx = bisect_right(mosi_times, t) - 1

        if idx >= 0:
            bits.append(mosi_values[idx])

    return bits


# ----------------------------
# 4. Bits → bytes (MSB first)
# ----------------------------
def bits_to_bytes(bits):
    """
    Convert MSB-first bit stream into bytes.

    SPI transmits MSB-first:
    - First bit is the highest bit (bit 7)

    Byte reconstruction:
        byte = (byte << 1) | bit
    """
    raw_bytes = []

    for i in range(0, len(bits) - 7, 8):
        byte = 0
        for b in bits[i:i+8]:
            byte = (byte << 1) | b
        raw_bytes.append(byte)

    return bytes(raw_bytes)


# ----------------------------
# 5. XOR decrypt
# ----------------------------
def xor_decrypt(data, key):
    """
    Decrypt data using repeating XOR key.

    Apply repeating XOR key:
    - Same operation for encryption/decryption
    - Key cycles over data

    key[i % len(key)] ensures repetition
    """
    return bytes(
        data[i] ^ key[i % len(key)]
        for i in range(len(data))
    )


# ----------------------------
# Formatting helpers
# ----------------------------
def format_ascii(data):
    """
    Convert bytes to printable ASCII string.

    Non-printable bytes are replaced with '.' for readability.
    """
    return "".join(chr(b) if 32 <= b <= 126 else "." for b in data)


def print_output(raw_bytes, decrypted_bytes):
    """
    Pretty-print results.

    Show both raw and decrypted outputs in Hex and ASCII form.
    """
    print("\n[*] [Hex]")
    print(raw_bytes.hex(" "))

    print("\n[*] [Raw ASCII]")
    print(format_ascii(raw_bytes))

    print("\n[+] [Decrypted ASCII]")
    print(decrypted_bytes.decode("ascii", errors="replace"))


# ----------------------------
# Main
# ----------------------------
def main():
    # Get input filenames from command line or use defaults
    sck_file = sys.argv[1] if len(sys.argv) > 1 else "sck.json"
    mosi_file = sys.argv[2] if len(sys.argv) > 2 else "mosi.json"

    # Load inputs
    sck_samples = load_sck_samples(sck_file)
    print(f"[+] Loaded {len(sck_samples)} SCK sample points")

    mosi_times, mosi_vals = load_mosi_events(mosi_file)

    # Decode pipeline
    bits = sample_mosi(sck_samples, mosi_times, mosi_vals)
    print(f"[+] Extracted {len(bits)} SPI bits")

    raw_bytes = bits_to_bytes(bits)
    print(f"[+] Assembled {len(raw_bytes)} bytes")

    decrypted = xor_decrypt(raw_bytes, XOR_KEY)

    # Output
    print_output(raw_bytes, decrypted)


if __name__ == "__main__":
    main()
