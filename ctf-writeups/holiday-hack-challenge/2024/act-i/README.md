# Act I

## Table of Contents
- [Act I](#act-i)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Challenges](#challenges)
  - [Story Context](#story-context)
  - [Key Techniques](#key-techniques)
  - [References](#references)

---

## Overview

The opening act of Holiday Hack Challenge 2024.

Act I introduces the story premise (Santa has gone missing and the elves are scrambling) and covers foundational challenges around hardware hacking, serial communication, and web tooling.

---

## Challenges

| Challenge | Category | Silver | Gold |
|---|---|---|---|
| [`curling/`](./curling/README.md) | Web / Tools | cURL basics via terminal | Combined flags, path traversal, redirect following |
| [`frosty-keypad/`](./frosty-keypad/README.md) | Crypto / OSINT | Ottendorf cipher → telephone keypad mapping | UV fingerprint analysis + brute-force permutations |
| [`hardware-part-i/`](./hardware-part-i/README.md) | Hardware / Forensics | Reassemble shredded UART config → connect programmer | API v1 endpoint bypass via `curl` |
| [`hardware-part-ii/`](./hardware-part-ii/README.md) | Hardware / Linux | Find passcode in bash history → grant card access | SQLite direct edit + HMAC-SHA256 signature generation |

---

## Story Context

Santa's Little Helper (SLH) tool is broken and needs to be restored. The elves working on the problem need to:

1. **Recover shredded serial settings** (Hardware Part I) — a document with the UART configuration was destroyed by the Shredder McShreddin 9000 and must be reconstructed from 1,000 image slices.
2. **Connect to the UART interface** (Hardware Part I) — use the recovered settings to establish a serial connection to the device.
3. **Grant access to card 42** (Hardware Part II) — use the SLH tool to modify the access database, finding the passcode left in bash history or forging a new HMAC signature.

The cURLing and Frosty Keypad challenges are standalone puzzles encountered along the way.

---

## Key Techniques

- Ottendorf (book) cipher decoding
- Telephone keypad letter-to-number mapping
- Itertools permutation brute-forcing with rate-limit handling
- Heuristic edge detection for image reassembly
- UART serial configuration (baud rate, parity, data bits, stop bits, flow control)
- Bash history credential recovery
- SQLite database inspection and direct modification
- HMAC-SHA256 signature generation
- API version downgrade bypass

---

## References

- [`ctf-techniques/web/curl/`](../../../../ctf-techniques/web/curl/README.md) — cURL technique reference
- [`ctf-techniques/crypto/`](../../../../ctf-techniques/crypto/README.md) — cipher and encoding reference
- [`ctf-techniques/post-exploitation/linux/`](../../../../ctf-techniques/post-exploitation/linux/README.md) — bash history credential hunting
- [`ctf-techniques/hardware/`](../../../../ctf-techniques/hardware/README.md) — hardware protocol reference
