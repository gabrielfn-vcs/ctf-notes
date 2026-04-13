# Hardware

Techniques for capturing and decoding hardware communication protocols, and interacting with embedded systems encountered in CTF challenges.

## Protocols Covered

| Directory | Protocol | Description |
|---|---|---|
| [`1-wire/`](./1-wire/) | 1-Wire | Single-wire serial protocol, used in sensors and iButtons |
| [`spi/`](./spi/) | SPI | Four-wire synchronous serial protocol (MOSI, MISO, SCK, CS) |
| [`i2c/`](./i2c/) | I²C | Two-wire serial bus (SDA + SCL), common in embedded systems |
| [`canbus/`](./canbus/) | CAN Bus | Controller Area Network, used in automotive and industrial systems |

## Approach

The general workflow for hardware protocol challenges is:

1. **Capture** — Record signal data from the logic analyzer or provided CSV/JSON dumps
2. **Decode** — Parse the raw signal into protocol frames using a decoder script
3. **Interpret** — Analyze the decoded data for flags, credentials, or commands

---

## References

### Labs
| Source | Name |
|---|---|
| N/A | N/A |

### Challenges
| Source | Name | Notes |
|---|---|---|
| Holiday Hack Challenge 2025, Act III | [Hack-a-Gnome](../../ctf-writeups/holiday-hack-challenge/2025/act-iii/hack-a-gnome/README.md) | CAN bus (Controller Area Network bus) |
| Holiday Hack Challenge 2025, Act III | [On The Wire](../../ctf-writeups/holiday-hack-challenge/2025/act-iii/on-the-wire/README.md) | 1-Wire, SPI, I²C |

### Web Sites
- [Saleae Logic 2 — Protocol Analyzers](https://support.saleae.com/protocol-analyzers)
- [HackTricks - Hardware Hacking](https://angelica.gitbook.io/hacktricks/hardware-physical-access/physical-attacks)
