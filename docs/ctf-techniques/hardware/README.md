# Hardware

## Table of Contents
- [Hardware](#hardware)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Approach](#approach)
  - [Protocols](#protocols)
    - [Can Bus Protocol](#can-bus-protocol)
    - [1-Wire Protocol](#1-wire-protocol)
    - [SPI Protocol](#spi-protocol)
    - [I2C Protocol](#i2c-protocol)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Techniques for capturing and decoding hardware communication protocols, and interacting with embedded systems encountered in CTF challenges.

---

## Approach

The general workflow for hardware protocol challenges is:

1. **Capture** — Record signal data from the logic analyzer or provided CSV/JSON dumps
2. **Decode** — Parse the raw signal into protocol frames using a decoder script
3. **Interpret** — Analyze the decoded data for flags, credentials, or commands

---

## Protocols

### Can Bus Protocol
[CAN (Controller Area Network) Bus](https://en.wikipedia.org/wiki/CAN_bus) is a vehicle bus standard designed to enable efficient communication primarily between electronic control units (ECUs) without a central computer. Originally developed to reduce the complexity and cost of electrical wiring in automobiles through multiplexing, the CAN bus protocol has since been adopted in various other contexts, such as 3D printing and industrial systems.

Since raw CAN messages are just hex payloads, common decoding techniques involve sniffing software to monitor message IDs in real-time while triggering physical components, and mapping changing bits to specific functions (signals).

### 1-Wire Protocol
[1-Wire](https://en.wikipedia.org/wiki/1-Wire) is a protocol developed by Dallas Semiconductor that uses pulse-width encoding to transmit data over a single wire. As a single-wire serial protocol, it is commonly used in sensors and iButtons.

The key to decoding this data is measuring how long the signal stays LOW:

- Short LOW pulse (1-15 time units) = 1.
- Long LOW pulse (~60 time units) = 0.
- Very long LOW pulses (150+) = reset/presence signals (skip these).
- Bits are transmitted LSB-first, i.e., need to reverse each group of 8 bits to get the correct byte value.

### SPI Protocol
[SPI (Serial Peripheral Interface)](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface) is a de facto standard for synchronous serial communication, used primarily in embedded systems for short-distance wired communication between integrated circuits. It follows an architecture where a controller device orchestrates communication with one ore more target devices using separate clock and data lines. Commonly, it is a four-wire synchronous serial protocol:

| Abbreviation | Name | Description |
| --- | --- | --- |
| SS | Slave Select | Active-low chip select (CS) signal from the controller device to enable communication with a specific target device |
| SCLK | Serial Clock | Clock signal from the controller device |
| MOSI | Master Out, Slave In | Serial data output from the controller device |
| MISO | Master In, Slave Out | Serial data output from the target device |

To decode SPI data:

- Sample the MOSI data line on each rising edge of SCLK (when clock goes 0→1).
- Bits are MSB-first (most significant bit first).
- If there is no SS line, frame boundaries would rely on idle markers.
- Clock idle state is LOW (CPOL = 0).
- Sampling edge is rising edge (CPHA = 0).

### I2C Protocol
[I2C (Inter-Integrated Circuit)](https://en.wikipedia.org/wiki/I%C2%B2C) is a synchronous, multi-controller/multi-target, single-ended, two-wire serial communication bus invented in 1980 by Philips Semiconductors (now NXP Semiconductors). It is widely used for attaching lower-speed peripheral integrated circuits (ICs) to processors and microcontrollers in short-distance, intra-board communication. It is clock-and-data protocol that uses two bidirectional signals:

| Abbreviation | Name | Description |
| --- | --- | --- |
| SCL | Serial Clock Line | Clock signal |
| SDA | Serial Data Line | Data signal |

To decode I2C data:

- Sample SDA on the rising edge of SCL.
- Bits are MSB-first (most significant bit first).
- The first byte of each transaction is the address byte: `(7-bit address << 1) | R/W bit`.
- Every 9th bit is an ACK bit that must be skipped when extracting data.

---

## References

### Challenges
| Source | Name | Notes |
|---|---|---|
| Holiday Hack Challenge 2025, Act III | [Hack-a-Gnome](../../ctf-writeups/holiday-hack-challenge/2025/act-iii/hack-a-gnome/README.md) | CAN bus (Controller Area Network bus) |
| Holiday Hack Challenge 2025, Act III | [On The Wire](../../ctf-writeups/holiday-hack-challenge/2025/act-iii/on-the-wire/README.md) | 1-Wire, SPI, I2C |

### Web Sites
- [Saleae Logic 2 — Protocol Analyzers](https://support.saleae.com/protocol-analyzers)
- [HackTricks - Hardware Hacking](https://angelica.gitbook.io/hacktricks/hardware-physical-access/physical-attacks)
