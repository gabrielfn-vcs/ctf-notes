#!/usr/bin/env python3
"""
1-Wire Signal Decoder

This script processes captured 1-Wire (DQ line) signal data from dq.csv
and reconstructs the transmitted bytes.

Decoding strategy:
1. Load timestamped signal transitions
2. Detect low pulses (1 → 0 → 1)
3. Measure pulse widths
4. Map pulse widths to bits (timing-based encoding)
5. Assemble bits into bytes (LSB-first)
6. Output decoded data in multiple formats

Key 1-Wire facts:
- No clock line → timing encodes bits
- Short pulse ≈ logical 1
- Long pulse ≈ logical 0
- Data is transmitted LSB-first
"""

import csv
import sys
from collections import Counter


# ----------------------------
# 1. Load CSV
# ----------------------------
def load_csv(filename):
    """
    Load given file and return sorted (timestamp, value) tuples.

    We expect a CSV with columns: line,t,v
    """
    rows = []

    with open(filename, newline="") as f:
        reader = csv.DictReader(f)
        for r in reader:
            # Store (timestamp, value)
            rows.append((int(r["t"]), int(r["v"])))

    # Ensure chronological order
    rows.sort()
    return rows


# ----------------------------
# 2. Extract low pulse widths
# ----------------------------
def extract_low_pulses(rows):
    """
    Extract low pulse widths from signal transitions.

    We are looking for LOW pulses:
    - Start: falling edge (1 → 0)
    - End:   rising edge  (0 → 1)

    Pulse width = duration signal stays LOW
    """
    low_pulses = []

    prev_v = rows[0][1]
    low_start = None

    for t, v in rows[1:]:

        # Detect falling edge → start of LOW pulse
        if prev_v == 1 and v == 0:
            low_start = t

        # Detect rising edge → end of LOW pulse
        elif prev_v == 0 and v == 1 and low_start is not None:
            pulse_width = t - low_start
            low_pulses.append(pulse_width)
            low_start = None

        prev_v = v

    return low_pulses


# ----------------------------
# 3. Split into frames
# ----------------------------
def split_frames(low_pulses):
    """
    Split pulses into frames based on RESET pulse (~480 µs).

    Each frame contains a sequence of pulses starting with a RESET,
    followed by a SYNC, and then data pulses.
        [RESET, SYNC, data...]

    We will separate frames by looking for RESET pulses,
    which are significantly longer than data pulses.
    """
    frames = []
    current = []

    for p in low_pulses:
        if 400 <= p <= 600:  # tolerant RESET detection
            if current:
                frames.append(current)
                current = []
        current.append(p)

    if current:
        frames.append(current)

    return frames


# ----------------------------
# 4. Strip RESET + SYNC
# ----------------------------
def strip_reset_sync(frame):
    """
    Remove RESET and SYNC pulses from 1-Wire frame.
    
    1-Wire frames begin with:
    - frame[0]: RESET pulse (~480 µs)
    - frame[1]: Presence / SYNC pulse (~150 µs)

    These are protocol overhead, not actual data.
    """
    if len(frame) < 2:
        return []
    return frame[2:]


# ----------------------------
# 5. Pulses → bits (tolerant)
# ----------------------------
def pulses_to_bits(data_pulses):
    """
    Convert pulse widths to bits based on timing using tolerant thresholds to handle jitter.

    1-Wire observed timing-based decoding:
    - ~6 µs   → bit 1 (short pulse)
    - ~60 µs  → bit 0 (long pulse)

    These values come from observing the dataset and are consistent with 1-Wire timing specifications.
    """
    bits = []

    for p in data_pulses:
        if 0 < p < 20:
            bits.append(1)
        elif 40 < p < 80:
            bits.append(0)
        else:
            raise ValueError(f"Unexpected pulse width: {p}")

    return bits


# ----------------------------
# 6. Bits → bytes (LSB first)
# ----------------------------
def bits_to_bytes(bits):
    """
    Convert LSB-first bit stream into byte array.

    1-Wire uses LSB-first ordering:
    - First bit received = bit 0
    - Last bit = bit 7

    So we build bytes using:
        byte |= bit << position
    """
    bytes_out = []

    for i in range(0, len(bits) - 7, 8):
        b = 0
        for bit_pos in range(8):
            b |= bits[i + bit_pos] << bit_pos
        bytes_out.append(b)

    return bytes_out


def format_ascii(byte_list):
    """
    Convert bytes to printable ASCII string.
    """
    return "".join(chr(b) if 32 <= b <= 126 else "." for b in byte_list)


def main():
    # Get filename from command line or default to dq.csv
    filename = sys.argv[1] if len(sys.argv) > 1 else "dq.csv"

    # Pipeline
    rows = load_csv(filename)
    low_pulses = extract_low_pulses(rows)

    # Debug: histogram of pulse widths
    print("[*] Pulse distribution:", Counter(low_pulses))

    frames = split_frames(low_pulses)

    print(f"\n[+] Detected {len(frames)} frame(s)\n")

    for i, frame in enumerate(frames):
        print(f"[*] --- Frame {i} ---")

        try:
            data_pulses = strip_reset_sync(frame)
            bits = pulses_to_bits(data_pulses)
            decoded_bytes = bits_to_bytes(bits)

            print("[*] Bytes:", decoded_bytes)
            print("[*] Hex:  ", [hex(b) for b in decoded_bytes])
            print("[+] ASCII:", format_ascii(decoded_bytes))

        except Exception as e:
            print("[!] Error decoding frame:", e)

        print()


if __name__ == "__main__":
    main()
