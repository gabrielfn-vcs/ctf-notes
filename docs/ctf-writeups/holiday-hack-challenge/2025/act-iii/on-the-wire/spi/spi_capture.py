#!/usr/bin/env python3
"""
SPI WebSocket Capture Script

This script captures synchronized SPI signal data from two WebSocket endpoints:
- MOSI (Master Out, Slave In) → data line
- SCK  (Serial Clock)         → clock line

Goal:
- Capture one complete SPI transaction
- Align MOSI data with clock edges during decoding
- Save raw frames for offline analysis

Why this matters:
- SPI is a clocked protocol → timing relative to SCK is critical
- Data must be sampled on specific clock edges (rising or falling)
- We capture both lines independently and correlate them later

Output:
- mosi.json → MOSI signal frames
- sck.json  → SCK signal frames

Each line is a JSON object:
    {"line": "mosi", "t": 123456, "v": 1, ...}
"""

import asyncio
import json
import websockets
from pathlib import Path

# WebSocket endpoints
URL_MOSI = "wss://signals.holidayhackchallenge.com/wire/mosi"
URL_SCK  = "wss://signals.holidayhackchallenge.com/wire/sck"

# Output files
OUT_MOSI = "mosi.json"
OUT_SCK  = "sck.json"


async def capture_line(url, out_path, line_name):
    """
    Capture a single SPI line (MOSI or SCK).

    Strategy:
    1. Wait for the first "idle-low" marker → start of transaction
    2. Record all packets
    3. Stop at the next "idle-low" marker → end of transaction

    This ensures we capture exactly one SPI frame.
    """

    # Remove existing file to avoid mixing captures
    p = Path(out_path)
    if p.exists():
        p.unlink()

    print(f"[+] Connecting to {line_name.upper()} at {url} ...")

    async with websockets.connect(url) as ws:
        print(f"[+] Connected to {line_name.upper()}. Waiting for first idle-low...")

        idle_seen = False   # Have we seen the first idle marker?
        finished = False    # Did we complete a full frame?

        with open(out_path, "w") as fh:

            async for msg in ws:

                # Parse JSON safely
                try:
                    pkt = json.loads(msg)
                except Exception:
                    # Preserve malformed frames for debugging
                    pkt = {"line": line_name, "raw": msg}

                # Ensure line label consistency
                pkt["line"] = line_name

                marker = pkt.get("marker")

                # ----------------------------
                # Wait for first idle-low
                # ----------------------------
                if not idle_seen:
                    if marker == "idle-low":
                        idle_seen = True
                        fh.write(json.dumps(pkt) + "\n")
                        fh.flush()
                        print(f"[+] First idle-low for {line_name.upper()} detected — starting capture")
                    continue

                # ----------------------------
                # Capture active transaction
                # ----------------------------
                fh.write(json.dumps(pkt) + "\n")
                fh.flush()

                # ----------------------------
                # Yield control to the event loop
                # to avoid dropping packets during heavy traffic
                # ----------------------------
                await asyncio.sleep(0)

                # ----------------------------
                # Stop at second idle-low
                # ----------------------------
                if marker == "idle-low":
                    print(f"[+] Second idle-low for {line_name.upper()} detected — finishing capture")
                    finished = True
                    break

        if not finished:
            print(f"[!] WARNING: {line_name.upper()} stream closed before second idle-low.")
        else:
            print(f"[+] Saved {line_name.upper()} capture to {out_path}")


async def main():
    """
    Run MOSI and SCK captures concurrently.

    Important:
    - SPI decoding requires BOTH lines
    - We capture them in parallel to preserve timing alignment
    """

    task_mosi = asyncio.create_task(
        capture_line(URL_MOSI, OUT_MOSI, "mosi")
    )

    task_sck = asyncio.create_task(
        capture_line(URL_SCK, OUT_SCK, "sck")
    )

    await asyncio.gather(task_mosi, task_sck)

    print("[+] Both captures complete.")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n[!] Capture interrupted by user — exiting cleanly")
