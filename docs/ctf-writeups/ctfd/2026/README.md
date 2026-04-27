# CTFd 2026

## Table of Contents
- [CTFd 2026](#ctfd-2026)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Challenges](#challenges)
  - [Story Context](#story-context)
  - [Key Techniques](#key-techniques)
  - [References](#references)

---

## Overview

An internal work CTF competition hosted on CTFd with a Willy Wonka / chocolate factory theme. Challenges span PCAP forensics, password cracking, and GPG decryption, all framed as a corporate espionage investigation into the Wonka Factory.

---

## Challenges

| Challenge | Category |
|---|---|
| [`candy-wrapper/`](./candy-wrapper/README.md) | Forensics / Crypto — DNS tunneling, rolling XOR, frequency analysis |
| [`decrypt/`](./decrypt/README.md) | Crypto — GPG passphrase cracking with John the Ripper PRINCE mode |
| [`hash-crack/`](./hash-crack/README.md) | Crypto — SHA-512 hash cracking with custom wordlist rules |

---

## Story Context

**Candy Wrapper** — An Oompa Loompa analyst notices suspicious DNS traffic to `sweetinfo.net`. The adversary is exfiltrating data via DNS tunneling: Base64-encoded subdomains carrying a message encrypted with a rolling XOR cipher where the key increments by `0x10` per packet. English frequency analysis recovers the per-packet keys; reassembling the segments reveals the full C2 message.

**Decrypt the Stolen Recipe Fragment** — A GPG-encrypted file named `QC_export` contains a stolen recipe. The passphrase is three words concatenated from a custom Wonka-themed wordlist. John the Ripper's PRINCE mode generates word combinations efficiently; with `--prince-elem-cnt-min=3 --prince-elem-cnt-max=3` and `--max-length=24`, it recovers the passphrase `sweetfizzyriver` in about a minute. Decrypting the file reveals the proprietary ingredient codename.

**Golden Hash Crack** — A leaked factory user database contains password hashes for operator accounts. The target hash for `golden_admin` is SHA-512 crypt (`$6$`). The password policy — letters and symbols only, one capital at position 11 — allows the `rockyou.txt` wordlist to be filtered down to 135,421 candidates. John the Ripper cracks the hash in about three minutes.

---

## Key Techniques

- DNS tunneling detection: high-entropy subdomains in PCAP as Base64-encoded exfiltration channel
- Rolling XOR cipher key recovery using English frequency analysis (score letters/spaces, penalize non-printable bytes)
- Base64 padding restoration for DNS-stripped strings (pad to multiple of 4)
- GPG hash extraction with `gpg2john`
- John the Ripper PRINCE mode (`--prince`) for multi-word passphrase generation
- `--max-length` override to prevent silent truncation of long candidates
- Hash type identification from `$6$` prefix (SHA-512 crypt / unix sha512crypt)
- Custom wordlist filtering by password policy (character class, length, position rules)
- John the Ripper `--show` to retrieve cracked passwords from session

---

## References

- [`ctf-techniques/crypto/`](../../../ctf-techniques/crypto/README.md) — GPG cracking, hash cracking, XOR cipher key recovery
- [`ctf-techniques/network/scanning/dns-enumeration/`](../../../ctf-techniques/network/scanning/dns-enumeration/README.md) — DNS enumeration and tunneling detection
- [John the Ripper documentation](https://www.openwall.com/john/doc/)
- [John the Ripper PRINCE mode](https://github.com/magnumripper/JohnTheRipper/blob/bleeding-jumbo/doc/PRINCE)
