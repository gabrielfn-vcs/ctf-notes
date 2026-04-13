# Cryptography

## Table of Contents
- [Cryptography](#cryptography)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Topics Covered](#topics-covered)
    - [GPG / PGP Decryption](#gpg--pgp-decryption)
    - [Hash Cracking](#hash-cracking)
    - [XOR Cipher](#xor-cipher)
    - [Custom Encoding Schemes](#custom-encoding-schemes)
    - [Symmetric Encryption](#symmetric-encryption)
    - [DNS Tunneling / Data Exfiltration](#dns-tunneling--data-exfiltration)
    - [Post-Quantum Cryptography (PQC)](#post-quantum-cryptography-pqc)
  - [Quick Reference](#quick-reference)
    - [GPG Passphrase Cracking](#gpg-passphrase-cracking)
    - [Hash Cracking (General)](#hash-cracking-general)
    - [XOR Cipher — Key Recovery](#xor-cipher--key-recovery)
      - [Decryption](#decryption)
      - [Brute-Force Feasibility](#brute-force-feasibility)
      - [Key Recovery Strategy — Informed Attack](#key-recovery-strategy--informed-attack)
      - [Single-Byte Key — Frequency Analysis](#single-byte-key--frequency-analysis)
      - [Rolling XOR — Evolving Key Per Packet](#rolling-xor--evolving-key-per-packet)
  - [References](#references)
    - [Labs](#labs)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview
Techniques for identifying, attacking, and decrypting ciphers and cryptographic implementations encountered in CTF challenges.

## Topics Covered

### GPG / PGP Decryption
Decrypting GPG-encrypted files, recovering passphrases via wordlist attacks using tools like `gpg2john` and `hashcat` or `john`.

### Hash Cracking
Recovering plaintext from hashed passwords using wordlists, rules, and masks.

### XOR Cipher
Reversing repeating-key XOR encryption. XOR ciphers are weak because the key cycles, allowing patterns in the plaintext to leak through the ciphertext. Known-plaintext attacks are trivially effective when any portion of the plaintext is known. More sophisticated variants use a **rolling XOR** where the key evolves per packet or block according to a mathematical progression.

### Custom Encoding Schemes
Reversing proprietary or obfuscated encodings (base variants, custom alphabets).

### Symmetric Encryption
Identifying and breaking weak symmetric ciphers (e.g., single-byte XOR, ECB mode, reused IVs).

### DNS Tunneling / Data Exfiltration
Data encoded into DNS subdomain queries to exfiltrate information covertly. Long, high-entropy subdomains in a PCAP are a strong indicator. The payload is typically Base64 or hex-encoded, sometimes with an additional XOR layer.

### Post-Quantum Cryptography (PQC)
Notes on PQC algorithms encountered in SSH key negotiation challenges.

---

## Quick Reference

### GPG Passphrase Cracking
```bash
# Extract hash
gpg2john encrypted.gpg > gpg.hash

# Crack with hashcat (mode 17010 for GPG)
hashcat -m 17010 gpg.hash wordlist.txt

# Crack with john
john --wordlist=wordlist.txt gpg.hash

# Decrypt once passphrase is known
gpg --batch --passphrase "passphrase" -d file.gpg
```

### Hash Cracking (General)
```bash
# Identify hash type
hashid <hash>
hash-identifier

# Crack with hashcat
hashcat -m <mode> hash.txt rockyou.txt

# Common modes: 0=MD5, 100=SHA1, 1000=NTLM, 1800=sha512crypt
```

### XOR Cipher — Key Recovery

#### Decryption

```python
def decrypt(encrypted_hex, key):
    key_bytes = [ord(k) for k in key]
    key_size = len(key_bytes)
    ciphertext = bytes.fromhex(encrypted_hex)
    decrypted = []
    for i, byte in enumerate(ciphertext):
        decrypted.append(byte ^ key_bytes[i % key_size])
    return bytes(decrypted).decode('utf-8', errors='replace')
```

```bash
# Decrypt a file with a known key
python3 decrypt.py encrypted_file.encoded KEY
```

#### Brute-Force Feasibility

Before attempting automated attacks, estimate the search space:

```
Total iterations = (charset size) ^ (key length)

# Example: 94 printable chars, 8-char key
94⁸ = ~6 quadrillion iterations → not viable

# Example: lowercase only, 8-char key
26⁸ = ~200 billion iterations → borderline

# Example: 256 case permutations of a known word
2⁸ = 256 iterations → trivially fast
```

#### Key Recovery Strategy — Informed Attack

Full brute force on long keys is rarely viable. Instead, use context clues:

1. **Identify candidate words** — look for repeated words in challenge name, file names, and plaintext samples that match the key length.

2. **Enumerate case permutations** — with an 8-character word there are only `2⁸ = 256` combinations. Run all of them and scan output for most-readable result:

```python
import itertools

def case_permutations(word):
    return map(''.join, itertools.product(*([c.lower(), c.upper()] for c in word)))

for key in case_permutations("candidate"):
    print(f"{key}: {decrypt(ciphertext, key)[:50]}")
```

3. **Apply leet substitutions** — once a candidate key is identified, try common character substitutions to refine it:

| Character | Common Substitutions |
|---|---|
| `a` | `@`, `4` |
| `e` | `3` |
| `i` | `1`, `!` |
| `l` | `1` |
| `o` | `0` |
| `s` | `5`, `$` |
| `t` | `7` |

4. **Validate output** — known plaintext (e.g., a file header, invoice number, or fixed string) makes it trivial to confirm a correct key automatically.

#### Single-Byte Key — Frequency Analysis

When the key is a single byte (0x00–0xFF), all 256 candidates can be tried automatically. Score each result by how much it resembles English text — the highest scorer is almost certainly correct:

```python
def get_english_score(data: bytes) -> int:
    score = 0
    for b in data:
        if ord('a') <= b <= ord('z') or ord('A') <= b <= ord('Z'):
            score += 10     # letters
        if b == ord(' '):
            score += 12     # spaces
        if ord('0') <= b <= ord('9') or b in b'._!':
            score += 5      # digits and common punctuation
        if b < 32 or b > 126:
            score -= 20     # heavy penalty for non-printable bytes
    return score

def find_single_byte_key(ciphertext: bytes) -> tuple[int, bytes]:
    best_key, best_score, best_result = 0, -float('inf'), b''
    for key in range(256):
        candidate = bytes([b ^ key for b in ciphertext])
        score = get_english_score(candidate)
        if score > best_score:
            best_key, best_score, best_result = key, score, candidate
    return best_key, best_result
```

#### Rolling XOR — Evolving Key Per Packet

When the **first** block or packet decodes cleanly but subsequent ones are garbled, the key is rolling — it changes per block according to a formula rather than repeating.

**Identifying a rolling XOR:**
- Decode each block independently using brute force + frequency analysis
- Note the winning key for each block and look for a mathematical pattern

**Common key progressions:**

| Pattern | Example Keys | Formula |
|---|---|---|
| Fixed increment | `0x00, 0x10, 0x20, 0x30` | `Key = Index × Step` |
| Linear diagonal | `0x11, 0x22, 0x33, 0x44` | `Key = Index × 0x11` |
| Index XOR wrapper | `0x00, 0x11, 0x22, 0x33` | `Key = Index XOR (Index × 16)` |

**Decryption loop for rolling XOR:**

```python
def decrypt_rolling_xor(blocks: list[bytes]) -> str:
    full_message = ""
    for i, block in enumerate(blocks):
        best_wrapper, best_score, best_decoded = 0, -float('inf'), ""
        for wrapper_candidate in range(256):
            key = i ^ wrapper_candidate          # Key = Index XOR Wrapper
            decrypted = bytes([b ^ key for b in block])
            score = get_english_score(decrypted)
            if score > best_score:
                best_score = score
                best_wrapper = wrapper_candidate
                best_decoded = "".join(
                    [chr(b) if 32 <= b <= 126 else "." for b in decrypted]
                )
        full_message += best_decoded
    return full_message
```

> **Tip:** Always restore Base64 padding before decoding — DNS subdomains strip trailing `=` signs since they are not valid in hostnames. Add `=` characters until the string length is a multiple of 4.

---

## References

### Labs
| Source | Name |
|---|---|
| N/A | N/A |

### Challenges
| Source | Name | Notes |
|---|---|---|
| CTFd 2026 | [Decrypt](../../ctf-writeups/ctfd/2026/decrypt/README.md) | GPG passphrase cracking |
| CTFd 2026 | [Hash Crack](../../ctf-writeups/ctfd/2026/hash-crack/README.md) | Filtering and cracking leaked credentials |
| CTFd 2026 | [Candy Wrapper](../../ctf-writeups/ctfd/2026/candy-wrapper/README.md) | Rolling XOR cipher, DNS tunneling, frequency analysis |
| Immersive Labs | [Parellus Power](../../ctf-writeups/immersive-labs/04-parellus-power/README.md) | Repeating-key XOR cipher key recovery |
| Holiday Hack Challenge 2025, Act II  | [Quantgnome Leap](../../ctf-writeups/holiday-hack-challenge/2025/act-ii/quantgnome-leap/README.md) | SSH and post-quantum cryptography |

### Web Sites
- [Hashcat Example Hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)
- [CyberChef](https://gchq.github.io/CyberChef/) — useful for quick encoding/decoding and XOR experimentation
- [HackTricks - Crypto](https://angelica.gitbook.io/hacktricks/crypto-and-stego)
- [XOR cipher — Wikipedia](https://en.wikipedia.org/wiki/XOR_cipher)
- [DNS Tunneling — SANS](https://www.sans.org/blog/dns-data-exfiltration-what-is-it-and-how-to-detect-it/)
