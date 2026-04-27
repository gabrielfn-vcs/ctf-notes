# Parellus Power

## Table of Contents
- [Parellus Power](#parellus-power)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
    - [Encryption Algorithm](#encryption-algorithm)
    - [Decryption Script](#decryption-script)
    - [Key Recovery](#key-recovery)
      - [Why Full Brute Force Is Not Viable](#why-full-brute-force-is-not-viable)
      - [Informed Attack — Known Context](#informed-attack--known-context)
      - [Step 1 — Case Permutations](#step-1--case-permutations)
      - [Step 2 — Leet Substitutions](#step-2--leet-substitutions)
      - [Key](#key)
  - [Solution](#solution)
    - [Decrypted Files](#decrypted-files)
      - [Arcadia Blossom Parellus Invoice](#arcadia-blossom-parellus-invoice)
      - [Parellus Power Finances](#parellus-power-finances)
    - [Answers](#answers)
  - [Lessons Learned](#lessons-learned)
    - [XOR cipher weaknesses](#xor-cipher-weaknesses)
    - [Key derivation from context](#key-derivation-from-context)
    - [Leet substitution enumeration](#leet-substitution-enumeration)
    - [Case permutations as a diagnostic](#case-permutations-as-a-diagnostic)
  - [Files](#files)
  - [References](#references)

---

## Overview

You get a password-protected ZIP file and the password `R03theDaY` to decrypt it.

This file contains a couple of plain text files with example invoices:

- [`Eldercherry Parellus Invoice.txt`](./Eldercherry%20Parellus%20Invoice.txt)
- [`Herocoms Parellus Invoice.txt`](./Herocoms%20Parellus%20Invoice.txt)

a couple of encrypted files:

- [`Arcadia Blossom Parellus Invoice.txt.encoded`](./Arcadia%20Blossom%20Parellus%20Invoice.txt.encoded)
- [`Parellus Power Finances - Jan 18 - Jan 19.csv.encoded`](./Parellus%20Power%20Finances%20-%20Jan%2018%20-%20Jan%2019.csv.encoded)

and a Python script ([`encrypt.py`](./encrypt.py)) that shows how the encryption is done.

---

## Analysis

This is a cryptography challenge where two files have been encrypted with a custom XOR cipher and the goal is to recover the encryption key and decrypt the files.

The encryption script and a couple of unencrypted invoices are provided, making this a known-plaintext / reverse-engineering exercise combined with an informed brute-force attack.

### Encryption Algorithm

Reading [`encrypt.py`](./encrypt.py) reveals the algorithm:

1. The plaintext file is Base64-encoded.
2. The Base64 output is converted to hex bytes.
3. Each hex byte is XOR'd with the corresponding byte of the key, cycling through the key using `i % key_size`.
4. The result is output as a hex string.

The key length is specified as **8 characters**.

```python
# Core encryption loop from encrypt.py
for byte in data_bytes:
    i = i % key_size
    xored = bin(int(byte, 16) ^ int(key_bytes[i], 16))
    hex_str = '{:02x}'.format(int(xored, 2))
    encrypted += hex_str
    i += 1
```

### Decryption Script

A new script can be generated to implement the inverse operation, i.e., XOR each ciphertext byte with the key byte, then decode from UTF-8:

```python
def decrypt_message(encrypted_hex, key):
    key_bytes = [ord(k) for k in key]
    key_size = len(key_bytes)
    ciphertext = bytes.fromhex(encrypted_hex)
    decrypted = []
    for i, byte in enumerate(ciphertext):
        decrypted_byte = byte ^ key_bytes[i % key_size]
        decrypted.append(decrypted_byte)
    return bytes(decrypted).decode('utf-8', errors='replace')
```

See [`decrypt.py`](./decrypt.py) for the full implementation including case permutation generation.

Testing with the encrypt and decrypt scripts with a test key can confirm the decryption is working as expected. For instance:
```bash
# Encrypt with a known key
python3 encrypt.py "file-to-encode" "key"

# Decrypt with a known key
python3 decrypt.py "encoded-file" "key"
```

### Key Recovery

#### Why Full Brute Force Is Not Viable

We are dealing with a charset of 94 printable characters:
* 26 (lowercase letters)
* 26 (uppercase letters)
* 10 (digits)
* 32 (punctuations)

and a key length of 8.

```
Total iterations = 94⁸ = 6,095,689,385,410,816 (~6 quadrillion)
```

This is approximately 6 quadrillion iterations. Assuming each iteration takes 1 millisecond, it would take 192,075 years to finish. Even with optimized hardware or parallel processing to reduce each iteration to 1 microsecond, it would still take 192 years. Basically, full brute force is not a viable approach.

#### Informed Attack — Known Context

The challenge name and file contents provide strong hints about the key. The word **"parellus"** appears repeatedly in the plaintext invoices and is exactly 8 characters long, which matches the key length.

#### Step 1 — Case Permutations

With 8 characters, there are `2⁸ = 256` possible case combinations. The `decrypt.py` script automates this:

```bash
python3 decrypt.py Arcadia\ Blossom\ Parellus\ Invoice.txt.encoded parellus
```

None of the 256 case permutations produced a fully clean decryption, but `PaRelluS` gave a partially readable result, which is a useful signal to refine from.

#### Step 2 — Leet Substitutions

Common leet-speak substitutions applied to the candidate key:

| Original | Substitution |
|---|---|
| `a` | `@` |
| `e` | `3` |
| `l` | `1` |
| `s` | `5` or `$` |

Starting from `PaRelluS` and applying substitutions systematically, the correct key was found to contain **3 uppercase letters, 3 lowercase letters, and 2 digits**.

#### Key

```
PaR3l1uS
```

---

## Solution

Now that the encryption key is known, we can decrypt the given files to solve the challenge.

### Decrypted Files

#### Arcadia Blossom Parellus Invoice

```bash
python3 decrypt.py 'Arcadia Blossom Parellus Invoice.txt.encoded' PaR3l1uS
```

The decypted output is in the [`Arcadia Blossom Parellus Invoice.txt`](./Arcadia%20Blossom%20Parellus%20Invoice.txt) file.

#### Parellus Power Finances

```bash
python3 decrypt.py 'Parellus Power Finances - Jan 18 - Jan 19.csv.encoded' PaR3l1uS
```

The decrypted output is in the [`Parellus Power Finances - Jan 18 - Jan 19.csv`](./Parellus%20Power%20Finances%20-%20Jan%2018%20-%20Jan%2019.csv) file.

### Answers
- Password used for the `important-docs.zip` file: `R03theDaY`.
- The key used to encrypt the files: `PaR3l1uS`.
- The token received from decrypting the ledger: `1b7691`.

---

## Lessons Learned

### XOR cipher weaknesses
XOR ciphers with short, repeating keys are fundamentally weak. Because the key cycles, patterns in the plaintext can leak through the ciphertext. Known-plaintext attacks are trivially effective when any portion of the plaintext is known.

### Key derivation from context
In CTF challenges, encryption keys are almost never random. The challenge name, file names, and plaintext samples are all candidate sources. Always try obvious context-derived words before attempting automated attacks.

### Leet substitution enumeration
Once a candidate word is identified, the search space collapses dramatically. For an 8-character word with 4 substitutable characters each with 2-3 variants, the total combinations are in the hundreds and trivially enumerable by hand or with a short script.

### Case permutations as a diagnostic
Running all 256 case permutations and visually scanning for "most readable" output is a fast way to identify the best candidate key before refining further.

---

## Files

| File | Description |
|---|---|
| [`encrypt.py`](./encrypt.py) | Original encryption script provided in the challenge |
| [`decrypt.py`](./decrypt.py) | Decryption script derived from reversing `encrypt.py` |
| [`Eldercherry Parellus Invoice.txt`](./Eldercherry%20Parellus%20Invoice.txt) | Plaintext example invoice (unencrypted) |
| [`Herocoms Parellus Invoice.txt`](./Herocoms%20Parellus%20Invoice.txt) | Plaintext example invoice (unencrypted) |
| [`Arcadia Blossom Parellus Invoice.txt.encoded`](./Arcadia%20Blossom%20Parellus%20Invoice.txt.encoded) | Target 1 Encrypted file |
| [Parellus Power Finances - Jan 18 - Jan 19.csv.encoded`](./Parellus%20Power%20Finances%20-%20Jan%2018%20-%20Jan%2019.csv.encoded) | Target 2 Encrypted file |

---

## References

- [`ctf-techniques/crypto/`](../../../ctf-techniques/crypto/README.md) — cryptography technique reference
- [XOR cipher — Wikipedia](https://en.wikipedia.org/wiki/XOR_cipher)
- [CyberChef XOR](https://gchq.github.io/CyberChef/#recipe=XOR) — useful for quick XOR experimentation
