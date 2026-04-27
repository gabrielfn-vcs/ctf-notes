#!/usr/bin/env python3
"""
I²C WebSocket Capture Script

This script captures signal data for an I²C bus by connecting to:
- SDA (data line)
- SCL (clock line)

Capture strategy:
- Wait for the first packet with timestamp t == 0 → start of a transmission
- Record all packets
- Stop at the next t == 0 → end of transmission

Why this matters:
- I²C is a clocked protocol (like SPI), but uses start/stop conditions
- The dataset uses t == 0 as a frame boundary marker
- Capturing a full frame ensures proper decoding later

Output:
- sda.json → SDA signal events
- scl.json → SCL signal events

Each line is a JSON object:
    {"line": "sda", "t": 123456, "v": 1}
"""

import asyncio
import json
import websockets

# WebSocket endpoints
URL_SDA = "wss://signals.holidayhackchallenge.com/wire/sda"
URL_SCL = "wss://signals.holidayhackchallenge.com/wire/scl"

# Output files
OUT_SDA = "sda.json"
OUT_SCL = "scl.json"

async def capture_line(url, out_path, line_name):
    """
    Capture a single I²C line (SDA or SCL).

    Behavior:
    - Wait for first t == 0 → start capture
    - Continue collecting packets
    - Stop at second t == 0 → end capture

    This isolates exactly one I²C transaction.
    """

    print(f"[+] Connecting to {line_name.upper()} at {url} ...")

    buffer = []
    started = False

    try:
        async with websockets.connect(url) as ws:
            print(f"[+] Connected to {line_name.upper()}. Waiting for first timestamp=0...")

            while True:
                msg = await ws.recv()

                # Parse JSON safely
                try:
                    pkt = json.loads(msg)
                except Exception:
                    continue

                # Filter only desired line
                if pkt.get("line") != line_name:
                    continue

                t = pkt.get("t")

                # ----------------------------
                # Start capture (first t == 0)
                # ----------------------------
                if t == 0 and not started:
                    print(f"[+] First timestamp=0 for {line_name.upper()} detected — starting capture")
                    started = True
                    buffer.append(pkt)
                    continue

                # ----------------------------
                # Capture active transaction
                # ----------------------------
                if started:
                    buffer.append(pkt)

                    # ----------------------------
                    # Stop capture (second t == 0)
                    # ----------------------------
                    if t == 0 and len(buffer) > 1:
                        print(f"[+] Second timestamp=0 for {line_name.upper()} detected — finishing capture")
                        break

    except asyncio.CancelledError:
        print(f"[!] WARNING: {line_name.upper()} capture cancelled (Ctrl+C)")
        raise

    finally:
        # Always write captured data, even if interrupted
        if buffer:
            with open(out_path, "w") as f:
                for entry in buffer:
                    f.write(json.dumps(entry) + "\n")

            print(f"[+] Saved {len(buffer)} packets to {out_path}")
        else:
            print(f"[!] WARNING: No packets captured for {line_name.upper()}")


async def main():
    """
    Run SDA and SCL captures concurrently.

    Important:
    - I²C decoding requires both clock (SCL) and data (SDA)
    - Capturing both simultaneously preserves timing relationships
    """

    task_sda = asyncio.create_task(
        capture_line(URL_SDA, OUT_SDA, "sda")
    )

    task_scl = asyncio.create_task(
        capture_line(URL_SCL, OUT_SCL, "scl")
    )

    await asyncio.gather(task_sda, task_scl)

    print("[+] Both captures complete.")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n[!] Capture interrupted by user — exiting cleanly")
