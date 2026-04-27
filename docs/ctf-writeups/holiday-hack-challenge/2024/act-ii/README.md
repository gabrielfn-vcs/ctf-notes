# Act II

## Table of Contents
- [Act II](#act-ii)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Challenges](#challenges)
  - [Story Context](#story-context)
  - [Key Techniques](#key-techniques)
  - [References](#references)

---

## Overview

Act II of Holiday Hack Challenge 2024 escalates the conflict between Team Alabaster and Team Wombley. The challenges span web exploitation, geospatial analysis, mobile reverse engineering, PowerShell automation, game hacking, and log-based threat investigation.

---

## Challenges

| Challenge | Category | Silver | Gold |
|---|---|---|---|
| [`drone-path/`](./drone-path/README.md) | Web / Forensics / OSINT | KML flight path decoding → login credentials + drone name | SQL injection to reveal boolean steganography → ASCII art flag |
| [`mobile-analysis/`](./mobile-analysis/README.md) | Mobile / Reverse Engineering | APK decompilation → hardcoded SQL filter leaks missing name | AAB decompilation → AES-GCM decryption reveals hidden SQL trigger |
| [`powershell/`](./powershell/README.md) | Web / Scripting | 11-task PowerShell MFA challenge → Base64 decoded password | SHA256 hash regeneration + EDR threshold bypass → automated token validation |
| [`snowball-showdown/`](./snowball-showdown/README.md) | Web / JavaScript | Client-side variable modification + attack automation | Hidden `moasb()` WebSocket method triggers the MOASB bomb |
| [`the-great-elf-conflict/`](./the-great-elf-conflict/README.md) | Forensics / KQL | KQL log investigation across 2 sections | Full 4-section investigation — phishing, ransomware, espionage, unknown threat |

---

## Story Context

Wombley Cube's faction has launched a multi-pronged operation against Alabaster Snowball's systems:

- **Drone Path** — Wombley is secretly building an armada of drones. The activation codes are hidden in flight telemetry data.
- **Mobile Analysis** — A debug and release version of Santa's Naughty-Nice List app has been tampered with to hide children's names.
- **PowerShell** — The snowball weaponry system is in a faulty lockdown. The MFA must be bypassed to regain access.
- **Snowball Showdown** — A direct confrontation between the factions. Alabaster needs every advantage — including a secret weapon no one can find.
- **The Great Elf Conflict** — KQL investigation of phishing attacks, ransomware, credential dumping, and persistence mechanisms deployed by Team Wombley.

---

## Key Techniques

- KML file parsing and geospatial visualisation (Google Earth, matplotlib, simplekml)
- Satellite terrain letter recognition
- SQL injection (`OR 1=1`, comment bypass)
- Boolean steganography — TRUE/FALSE to binary to ASCII
- Android APK and AAB decompilation with jadx
- AES-GCM decryption from hardcoded app credentials
- PowerShell `Invoke-WebRequest`, Basic Auth, cookie manipulation, Base64 decoding
- SHA256 hash regeneration with newline-aware file hashing
- EDR threshold bypass via shared cookie
- Client-side JavaScript variable modification via DevTools console
- WebSocket message injection
- KQL (Kusto Query Language) — `take`, `count`, `where`, `join`, `project`, `sort`
- Threat hunting — phishing, credential dumping, DLL sideloading, registry persistence

---

## References

- [`ctf-techniques/web/sqli/`](../../../../ctf-techniques/web/sqli/README.md) — SQL injection reference
- [`ctf-techniques/mobile/`](../../../../ctf-techniques/mobile/README.md) — Android APK analysis reference
- [`ctf-techniques/web/curl/`](../../../../ctf-techniques/web/curl/README.md) — HTTP interaction reference
- [`ctf-techniques/crypto/`](../../../../ctf-techniques/crypto/README.md) — hash and encoding reference
- [`ctf-techniques/forensics/`](../../../../ctf-techniques/forensics/README.md) — log analysis and steganography reference
