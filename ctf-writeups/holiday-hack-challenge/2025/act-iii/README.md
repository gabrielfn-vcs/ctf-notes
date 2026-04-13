# Act III

## Table of Contents
- [Act III](#act-iii)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Challenges](#challenges)
  - [Story Context](#story-context)
  - [Key Techniques](#key-techniques)
  - [References](#references)

---

## Overview

In Act III of Holiday Hack Challenge 2025, the gnomes want to transform the neighborhood so that it's frozen solid year-round, which is an environmental disaster.

The challenges span web exploitation, hardware protocol analysis, penetration testing methodology, and binary reverse engineering, culminating in shutting down the gnome factory and uncovering the mastermind behind the takeover.

---

## Challenges

| Challenge | Category |
|---|---|
| [`gnome-tea/`](./gnome-tea/README.md) | Web — Firebase enumeration, EXIF analysis, client-side auth bypass |
| [`hack-a-gnome/`](./hack-a-gnome/README.md) | Web — Cosmos DB blind SQLi, prototype pollution → RCE, CAN bus reverse engineering |
| [`schroedingers-scope/`](./schroedingers-scope/README.md) | Web — Pentest methodology, header spoofing, cookie brute-force |
| [`on-the-wire/`](./on-the-wire/README.md) | Hardware — 1-Wire, SPI, I²C protocol decoding with XOR decryption |
| [`free-ski/`](./free-ski/README.md) | Reverse Engineering — PyInstaller unpacking, Python bytecode analysis |

---

## Story Context

- **Gnome Tea** — Enter the apartment building near 24-7 and help Thomas infiltrate the GnomeTea social network. By enumerating an open Firestore database, extracting GPS coordinates from a driver's license EXIF data, and bypassing a client-side admin UID check, you discover the gnome secret passphrase: `GigGigglesGiggler`.

- **Hack-a-Gnome** — Davis in the Data Center is fighting a gnome army. You gain access to the Smart Gnome control panel by exploiting a Cosmos DB boolean-based blind SQL injection, crack the recovered MD5 hashes, then escalate to a root reverse shell via prototype pollution against an EJS template renderer. From the shell, you fix the CAN bus command IDs — either by fuzzing or by reverse engineering a deleted Go binary recovered from `/proc` — and navigate a box-push puzzle to shut down the factory.

- **Schrödinger's Scope** — Kevin in the Retro Store ponders pentest paradoxes. You conduct an in-scope web application penetration test by enumerating a sitemap, stripping gnome-injected out-of-scope requests with Burp Suite Match & Replace, finding developer credentials in a TODO page, bypassing an IP validation check with `X-Forwarded-For`, discovering a commented-out course search via HTML source review, exploiting a SQLi vulnerability, and brute-forcing a predictable session cookie to access a hidden WIP course.

- **On the Wire** — Help Evan next to City Hall hack this gnome and retrieve the temperature value reported by the I²C device at address `0x3C`. Three hardware protocols are decoded in sequence: 1-Wire (pulse-width encoding, LSB-first) reveals the XOR key `icy` for SPI; SPI (clock-sampled MOSI, MSB-first) decrypts to reveal the XOR key `bananza` and target I²C address; I²C (multi-device bus, address-filtered) decrypts to the final answer: `32.84`.

- **Free Ski** — Go to the retro store and help Goose Olivia ski down the mountain in this classic SkiFree-inspired challenge. The `FreeSki.exe` binary is a PyInstaller-packaged Python 3.13 app. With full decompilation blocked by new 3.13 opcodes, you disassemble the bytecode with `pycdas` and reconstruct the flag logic: treasure positions are deterministic (seeded by CRC32 of the mountain name), XOR-decrypted using a PRNG seeded from a product of treasure IDs. Mount Snow yields the flag: `frosty_yet_predictably_random`.

---

## Key Techniques

- Firebase/Firestore unauthenticated collection enumeration via REST API
- EXIF GPS metadata extraction with `exiftool` to geolocate image capture site
- Client-side admin bypass by setting `window.ADMIN_UID` in the browser console
- Cosmos DB boolean-based blind SQL injection using `IS_DEFINED`, `STARTSWITH`, and `SUBSTRING`
- Unsalted MD5 hash cracking via online lookup (CrackStation)
- Prototype pollution → RCE via EJS `outputFunctionName` gadget in Node.js
- Recovering a deleted Linux binary from `/proc/<PID>/exe`
- Go binary reverse engineering with Ghidra and the Golang Analyzer Extension
- CAN bus command ID discovery by fuzzing with `python-can`
- Burp Suite Match & Replace rules for request suppression and header injection
- `X-Forwarded-For` header spoofing to bypass IP-based login validation
- HTML source code review to find commented-out endpoints
- Predictable session cookie enumeration (sequential hex suffix brute-force)
- 1-Wire pulse-width decoding (LSB-first, RESET/SYNC/data pulse classification)
- SPI decoding: sample MOSI on SCK rising edge (MSB-first), XOR decrypt
- I²C decoding: address-filtered multi-device bus, ACK-aware byte reconstruction
- XOR repeating-key decryption chained across protocol stages
- PyInstaller extraction with `pyinstxtractor` (version-matched Python required)
- Python bytecode disassembly with `pycdas` when decompilation fails
- AI-assisted bytecode reconstruction from `.pyasm` disassembly
- Deterministic PRNG re-seeding to reconstruct game state offline

---

## References

- [`ctf-techniques/web/firebase/`](../../../../../ctf-techniques/web/firebase/README.md) — Firebase/Firestore enumeration and client-side admin bypass
- [`ctf-techniques/forensics/`](../../../../../ctf-techniques/forensics/README.md) — EXIF image metadata extraction
- [`ctf-techniques/web/sqli/`](../../../../../ctf-techniques/web/sqli/README.md) — Boolean-based blind SQL injection
- [`ctf-techniques/web/prototype-pollution/`](../../../../../ctf-techniques/web/prototype-pollution/README.md) — Prototype pollution → RCE via EJS gadget
- [`ctf-techniques/network/tunneling/`](../../../../../ctf-techniques/network/tunneling/README.md) — Ngrok tunnel and reverse shell setup
- [`ctf-techniques/reverse/`](../../../../../ctf-techniques/reverse/README.md) — Go binary analysis, PyInstaller unpacking, bytecode disassembly
- [`ctf-techniques/web/burpsuite/`](../../../../../ctf-techniques/web/burpsuite/README.md) — Match & Replace rules, proxy interception
- [`ctf-techniques/web/curl/`](../../../../../ctf-techniques/web/curl/README.md) — X-Forwarded-For header spoofing
- [`ctf-techniques/web/cookies/`](../../../../../ctf-techniques/web/cookies/README.md) — Predictable cookie enumeration and brute-forcing
- [`ctf-techniques/hardware/`](../../../../../ctf-techniques/hardware/README.md) — 1-Wire, SPI, and I²C protocol capture and decoding
- [`ctf-techniques/crypto/`](../../../../../ctf-techniques/crypto/README.md) — XOR repeating-key decryption
