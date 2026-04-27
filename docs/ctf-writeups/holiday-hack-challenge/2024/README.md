# Holiday Hack Challenge 2024

## Table of Contents
- [Holiday Hack Challenge 2024](#holiday-hack-challenge-2024)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Acts](#acts)
  - [All Challenges](#all-challenges)
  - [Story Arc](#story-arc)
  - [References](#references)

---

## Overview

**SANS Holiday Hack Challenge 2024** — *The Great Elf Divide*

Santa has gone missing just before the holidays, leaving two factions of elves — Team Alabaster and Team Wombley — in a power struggle that escalates from a snowball fight to a full-scale ransomware incident. The challenge follows the conflict across three acts, ending with the recovery and deactivation of the Frostbit ransomware that encrypted the Naughty-Nice List.

---

## Acts

| Act | Theme | Challenges |
|---|---|---|
| [`act-i/`](./act-i/README.md) | Foundations — hardware hacking, serial communication, web tooling | cURLing, Frosty Keypad, Hardware Part I, Hardware Part II |
| [`act-ii/`](./act-ii/README.md) | Escalation — web exploitation, geospatial analysis, mobile RE, game hacking, threat investigation | Drone Path, Mobile Analysis, PowerShell, Snowball Showdown, The Great Elf Conflict |
| [`act-iii/`](./act-iii/README.md) | Resolution — ransomware incident response, SIEM forensics, cryptographic key recovery, injection | Santa Vision, Elf Stack, Frostbit Decrypt the Naughty-Nice List, Frostbit Deactivate the Ransomware |

---

## All Challenges

| Challenge | Act | Category |
|---|---|---|
| [`act-i/curling/`](./act-i/curling/README.md) | I | Web / Tools |
| [`act-i/frosty-keypad/`](./act-i/frosty-keypad/README.md) | I | Crypto / OSINT |
| [`act-i/hardware-part-i/`](./act-i/hardware-part-i/README.md) | I | Hardware / Forensics |
| [`act-i/hardware-part-ii/`](./act-i/hardware-part-ii/README.md) | I | Hardware / Linux |
| [`act-ii/drone-path/`](./act-ii/drone-path/README.md) | II | Web / Forensics / OSINT |
| [`act-ii/mobile-analysis/`](./act-ii/mobile-analysis/README.md) | II | Mobile / Reverse Engineering |
| [`act-ii/powershell/`](./act-ii/powershell/README.md) | II | Web / Scripting |
| [`act-ii/snowball-showdown/`](./act-ii/snowball-showdown/README.md) | II | Web / JavaScript |
| [`act-ii/the-great-elf-conflict/`](./act-ii/the-great-elf-conflict/README.md) | II | Forensics / KQL |
| [`act-iii/santa-vision/`](./act-iii/santa-vision/README.md) | III | Network / MQTT / OSINT |
| [`act-iii/elf-stack/`](./act-iii/elf-stack/README.md) | III | Forensics / SIEM |
| [`act-iii/frostbit-decrypt-the-naughty-nice-list/`](./act-iii/frostbit-decrypt-the-naughty-nice-list/README.md) | III | Crypto / Web |
| [`act-iii/frostbit-deactivate-the-ransomware/`](./act-iii/frostbit-deactivate-the-ransomware/README.md) | III | Web / Injection |

---

## Story Arc

```
Act I — Santa goes missing. Elves scramble to restore his tools.
  └─ Recover shredded UART config → connect hardware → grant card access

Act II — Wombley's faction launches operations against Alabaster.
  └─ Drone armada, ransomware, phishing, credential dumping, espionage

Act III — Frostbit ransomware encrypts the Naughty-Nice List.
  └─ Santa Vision leaks Frostbit API details via MQTT
  └─ Elf Stack reconstructs the full attack chain
  └─ Frostbit Decrypt recovers the encryption keys via path traversal
  └─ Frostbit Deactivate extracts the API key via AQL injection
       └─ Naughty-Nice List saved. Holiday season restored.
```

---

## References

- [SANS Holiday Hack Challenge](https://www.sans.org/mlp/holiday-hack-challenge/) — official event page
- [`ctf-techniques/`](../../../ctf-techniques/README.md) — technique reference repo
