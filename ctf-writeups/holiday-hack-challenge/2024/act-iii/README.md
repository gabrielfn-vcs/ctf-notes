# Act III

## Table of Contents
- [Act III](#act-iii)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Challenges](#challenges)
  - [Story Context](#story-context)
  - [Key Techniques](#key-techniques)
  - [Cross-Challenge Dependencies](#cross-challenge-dependencies)
  - [References](#references)

---

## Overview

Act III is the climax of Holiday Hack Challenge 2024. The challenges resolve the Frostbit ransomware attack on the Naughty-Nice List — hijacked broadcast infrastructure, a full SIEM threat investigation, cryptographic key recovery via path traversal, and a final AQL injection to deactivate the ransomware server.

## Challenges

| Challenge | Category | Silver | Gold |
|---|---|---|---|
| [`santa-vision/`](./santa-vision/README.md) | Network / MQTT / OSINT | Nmap + JFFS2 filesystem analysis + SQLite credential recovery → portal login | HTTP header injection + MQTT subscription bypass → admin demotion via `santafeed` |
| [`elf-stack/`](./elf-stack/README.md) | Forensics / SIEM / KQL | 15-question ELK stack log exploration | 24-question full attack chain reconstruction — phishing → credential dump → DLL sideloading → ADCS ESC1 → domain takeover |
| [`frostbit-decrypt-the-naughty-nice-list/`](./frostbit-decrypt-the-naughty-nice-list/README.md) | Crypto / Reverse Engineering / Web | PCAP TLS decryption + API enumeration + custom hash null-digest exploit → path traversal → RSA private key recovery | AES-CBC decryption of the Naughty-Nice list using recovered key |
| [`frostbit-deactivate-the-ransomware/`](./frostbit-deactivate-the-ransomware/README.md) | Web / Injection | AQL time-based blind injection to extract API key → deactivate ransomware publication endpoint | Same — no separate Gold path |

## Story Context

Act III ties together threads from all previous acts:

- **Santa Vision** — The Santa Broadcast Network has been hijacked to spread propaganda. Credentials buried in a JFFS2 filesystem and a SQLite database must be found to regain access. MQTT feeds leak critical information about the Frostbit infrastructure — including an API endpoint and a TLS certificate path — that are essential for the two Frostbit challenges.
- **Elf Stack** — A full forensic reconstruction of the Frostbit ransomware attack chain using the North Pole SIEM. Traces the attacker from initial phishing email through credential dumping, DLL sideloading persistence, Active Directory enumeration, ADCS ESC1 certificate abuse, and remote desktop takeover.
- **Frostbit Decrypt the Naughty-Nice List** — Wombley encrypted the Naughty-Nice List with Frostbit ransomware and lost the keys. The solution requires decrypting TLS traffic from a PCAP, exploiting a null-digest vulnerability in a custom hash library to perform path traversal, recovering the server's RSA private key, and using it to decrypt the AES symmetric key.
- **Frostbit Deactivate the Ransomware** — The ransomware server is threatening to publish the Naughty-Nice List. The deactivation API endpoint requires a valid API key stored in ArangoDB — extracted via a time-based blind AQL injection that bypasses the WAF.

## Key Techniques

- Nmap service discovery
- JFFS2 filesystem analysis with jefferson
- SQLite credential extraction
- MQTT subscription and publication (`mosquitto_sub`, `mosquitto_pub`)
- HTTP header manipulation and MQTT admin demotion
- ROT cipher decoding
- ELK/Kibana log querying
- Phishing email analysis, proxy log correlation
- DLL sideloading and registry persistence detection
- ADCS ESC1 certificate abuse
- Active Directory enumeration (BloodHound/SharpHound)
- TLS session secret decryption in Wireshark
- Custom hash algorithm analysis and null-digest exploit
- Double URL encoding for path traversal bypass
- RSA private key recovery and RSAES-PKCS1-V1_5 decryption
- AES-CBC decryption
- AQL (ArangoDB Query Language) time-based blind injection
- WAF keyword enumeration and bypass

## Cross-Challenge Dependencies

The challenges in Act III are tightly interconnected:

```
Santa Vision
  └─ frostbitfeed MQTT message reveals:
       ├─ /api/v1/frostbitadmin/bot/<uuid>/deactivate endpoint  →  used in Frostbit Deactivate
       └─ /etc/nginx/certs/api.frostbit.app.key path            →  used in Frostbit Decrypt

Frostbit Decrypt
  └─ Decrypted Naughty-Nice List                                →  answer for Frostbit Decrypt
  └─ UUID from ransomware response HTML                         →  used in Frostbit Deactivate
```

## References

- [`ctf-techniques/network/scanning/`](../../../../ctf-techniques/network/scanning/README.md) — Nmap and service enumeration
- [`ctf-techniques/forensics/`](../../../../ctf-techniques/forensics/README.md) — PCAP, log analysis, SQLite
- [`ctf-techniques/crypto/`](../../../../ctf-techniques/crypto/README.md) — RSA, AES-CBC, TLS decryption
- [`ctf-techniques/web/sqli/`](../../../../ctf-techniques/web/sqli/README.md) — time-based blind injection
- [`ctf-techniques/post-exploitation/linux/`](../../../../ctf-techniques/post-exploitation/linux/README.md) — persistence and credential techniques seen in Elf Stack
