#!/usr/bin/python3
import can
import time
import argparse
import sys
import datetime

COMMAND_MAP = {
    "up": 0x201,
    "down": 0x202,
    "left": 0x203,
    "right": 0x204,
}

COMMAND_CHOICES = list(COMMAND_MAP.keys()) + ["listen"]
IFACE_NAME = "gcan0"
LOG_FILE = "canbus_log.txt"

def send_command(bus, command_id):
    message = can.Message(
        arbitration_id=command_id,
        data=[],
        is_extended_id=False
    )
    try:
        bus.send(message)
        print(f"Sent command: ID=0x{command_id:X}")
    except can.CanError as e:
        print(f"Error sending message: {e}")

def listen_for_messages(bus):
    print(f"Listening for messages on {bus.channel_info}. Logging to {LOG_FILE}. Press Ctrl+C to stop.")
    try:
        with open(LOG_FILE, "a") as log:
            for msg in bus:
                timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
                log.write(f"{timestamp} | Received: {msg}\n")
    except KeyboardInterrupt:
        print("\nStopping listener...")
    except Exception as e:
        print(f"\nAn error occurred during listening: {e}")

def main():
    parser = argparse.ArgumentParser(description="Send CAN bus commands or listen for messages.")
    parser.add_argument(
        "command",
        choices=COMMAND_CHOICES,
        help=f"The command to send ({', '.join(COMMAND_MAP.keys())}) or 'listen' to monitor the bus."
    )
    args = parser.parse_args()

    try:
        bus = can.interface.Bus(channel=IFACE_NAME, interface='socketcan', receive_own_messages=False)
        print(f"Successfully connected to {IFACE_NAME}.")
    except OSError as e:
        print(f"Error connecting to CAN interface {IFACE_NAME}: {e}")
        print(f"Make sure the {IFACE_NAME} interface is up ('sudo ip link set up {IFACE_NAME}')")
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred during bus initialization: {e}")
        sys.exit(1)

    if args.command == "listen":
        listen_for_messages(bus)
    else:
        command_id = COMMAND_MAP.get(args.command)
        if command_id is None:
            print(f"Invalid command for sending: {args.command}")
            bus.shutdown()
            sys.exit(1)
        send_command(bus, command_id)
        time.sleep(0.1)

    bus.shutdown()
    print("CAN bus connection closed.")

if __name__ == "__main__":
    main()
