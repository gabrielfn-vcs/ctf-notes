#!/usr/bin/env python3
"""
1-Wire WebSocket Signal Capture Script

This script connects to the challenge WebSocket endpoint that streams
digital signal data for the 1-Wire (DQ) line. It collects a fixed number
of signal transitions and stores them in CSV format for offline analysis.

Why this matters:
- 1-Wire encodes data using timing (pulse widths), not just values
- We need precise timestamps (t) and values (v) to reconstruct bits
- Capturing raw data allows us to analyze timing patterns later

Output format (CSV):
    line,t,v
    dq,123456,1
    dq,123789,0
"""

import asyncio
import json
import ssl
import sys
from websockets import connect

# WebSocket endpoint for the 1-Wire data line (DQ)
URL = "wss://signals.holidayhackchallenge.com/wire/dq"

# Output file for captured signal data
OUTFILE = "dq.csv"

# Number of signal frames to collect before stopping
TARGET = 10000


async def run():
    """
    Main async function:
    - Establishes a secure WebSocket connection
    - Continuously receives signal frames
    - Filters and validates JSON data
    - Writes structured data to CSV for later decoding
    """

    # Create default SSL context (required for wss:// connections)
    ssl_ctx = ssl.create_default_context()

    # Counter for collected frames
    count = 0

    # Open output file in line-buffered mode
    # Line buffering ensures data is written immediately (useful if interrupted)
    with open(OUTFILE, "w", buffering=1) as f:
        # Write CSV header: line, timestamp, value
        f.write("line,t,v\n")

        try:
            # Establish WebSocket connection
            async with connect(URL, ssl=ssl_ctx) as ws:

                # Continue collecting until we reach TARGET frames
                while count < TARGET:

                    # Wait for next message from server
                    raw = await ws.recv()

                    # Attempt to parse JSON message
                    try:
                        obj = json.loads(raw)
                    except json.JSONDecodeError:
                        # Ignore malformed or non-JSON messages
                        continue

                    # Ensure required fields exist
                    if not all(k in obj for k in ("line", "t", "v")):
                        continue

                    # Extract and sanitize fields
                    line = str(obj["line"])

                    try:
                        t = int(obj["t"])  # timestamp
                        v = int(obj["v"])  # signal value (0 or 1)
                    except (ValueError, TypeError):
                        # Skip invalid numeric values
                        continue

                    # Write structured row to CSV
                    f.write(f"{line},{t},{v}\n")
                    count += 1

                    # Print progress every 1000 frames
                    if count % 1000 == 0:
                        print(f"[*] Collected {count}/{TARGET}")

        except Exception as e:
            # Handle connection errors or unexpected failures
            print("[!] Connection error or other exception:", e, file=sys.stderr)

    print(f"[+] Done. Collected {count} messages into {OUTFILE}")


if __name__ == "__main__":
    try:
        asyncio.run(run())
    except KeyboardInterrupt:
        # Graceful exit on Ctrl+C
        print("\n[!] Interrupted by user.")
