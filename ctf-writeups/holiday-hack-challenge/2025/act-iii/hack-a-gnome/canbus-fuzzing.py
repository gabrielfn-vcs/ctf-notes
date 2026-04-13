#!/usr/bin/env python3

import can
import time
import argparse
import sys

"""
A simple CAN bus fuzzing script that sends a range of command IDs to the device.

Usage:
  python can_fuzzing.py
      → Sends default range 0x200–0x2FF

  python can_fuzzing.py -c 0x250
      → Sends only command ID 0x250

  python can_fuzzing.py --begin 0x100 --end 0x1FF
      → Sends custom range of command IDs
"""

IFACE_NAME = "gcan0"

def send_command(bus, command_id):
    """Sends a CAN message with the given command ID."""
    message = can.Message(
        arbitration_id=command_id,
        data=[],
        is_extended_id=False
    )
    try:
        bus.send(message)
        print(f"[*] Sent command: ID=0x{command_id:X}")
    except can.CanError as e:
        print(f"[!] Error sending message: {e}")

def parse_args():
    parser = argparse.ArgumentParser(description="Send CAN commands")

    parser.add_argument(
        "-c", "--command-id",
        help="Single command ID to send (e.g., 0x200 or 512)",
        type=str
    )

    parser.add_argument(
        "--begin",
        help="Begin of command ID range (e.g., 0x200)",
        type=str
    )

    parser.add_argument(
        "--end",
        help="End of command ID range (e.g., 0x2FF)",
        type=str
    )

    return parser.parse_args()

def parse_command_id(cmd_str):
    """Parse command ID from string (supports hex or decimal)."""
    try:
        return int(cmd_str, 0)  # auto-detects hex (0x...) or decimal
    except ValueError:
        print(f"[!] Invalid command ID: {cmd_str}")
        sys.exit(1)

def main():
    args = parse_args()

    # Establish CAN bus connection
    try:
        bus = can.interface.Bus(
            channel=IFACE_NAME,
            interface='socketcan',
            receive_own_messages=False
        )
        print(f"[+] Successfully connected to {IFACE_NAME}.")
    except OSError as e:
        print(f"[!] Error connecting to CAN interface {IFACE_NAME}: {e}")
        print(f"[!] Make sure the {IFACE_NAME} interface is up ('sudo ip link set up {IFACE_NAME}')")
        print("[!] And that you have the necessary permissions.")
        sys.exit(1)
    except Exception as e:
        print(f"[!] An unexpected error occurred during bus initialization: {e}")
        sys.exit(1)

    # If command ID is provided, then send only that
    if args.command_id:
        if args.begin or args.end:
            print("[!] Cannot use --command-id with --begin/--end")
            sys.exit(1)

        command_id = parse_command_id(args.command_id)
        print(f"[*] Sending single command ID: 0x{command_id:X}")
        send_command(bus, command_id)
    else:
        # Otherwise, send a range of command IDs (Default behavior)

        # Determine range
        if args.begin and args.end:
            start = parse_command_id(args.begin)
            end = parse_command_id(args.end)
        elif args.begin or args.end:
            print("[!] You must specify BOTH --begin and --end")
            sys.exit(1)
        else:
            # Default range
            start = 0x200
            end = 0x2FF

        # Validate range
        if start > end:
            print("[!] Invalid range: begin must be <= end")
            sys.exit(1)

        # Send command IDs in the specified range
        print(f"[*] Testing command IDs from 0x{start:X} to 0x{end:X}...")
        for command_id in range(start, end + 1):
            send_command(bus, command_id)
            time.sleep(0.1)

    # Clean up
    bus.shutdown()
    print("[+] CAN bus connection closed.")

if __name__ == "__main__":
    main()
