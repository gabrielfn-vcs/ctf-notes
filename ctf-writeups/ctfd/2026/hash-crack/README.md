# Golden Hash Crack

## Table of Contents
- [Golden Hash Crack](#golden-hash-crack)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Hints](#hints)
    - [Hint 1:](#hint-1)
    - [Hint 2:](#hint-2)
  - [Analysis](#analysis)
  - [Step 0 — Identify the Hash Type](#step-0--identify-the-hash-type)
  - [Step 1 — Isolate the `golden_admin` Hash](#step-1--isolate-the-golden_admin-hash)
  - [Step 2 — Filter the Wordlist](#step-2--filter-the-wordlist)
  - [Step 3 — Run the Crack](#step-3--run-the-crack)
    - [Command](#command)
    - [Output](#output)
  - [Step 4 — Retrieve the Password](#step-4--retrieve-the-password)
    - [Command](#command-1)
    - [Output](#output-1)
  - [Solution](#solution)
  - [Files](#files)
  - [References](#references)

## Overview

A security audit of the Wonka Factory revealed a backup database containing password hashes for industrial operator accounts. Your task is to crack these hashes to identify weak passwords and retrieve the Golden Ticket hidden in one of them.

**Task:** Download the leaked database dump and crack the passwords. The Golden Ticket is the password for the user "golden_admin".

**Flag:** The flag is without a wrapper.

**Note:** For this challenge, common password cracking tools (`hashcat`, `john`) and wordlists are recommended. Use the rockyou.txt wordlist or similar.

**Files:**
* `leaked_passwords.txt`
* `rockyou.txt`

## Hints

### Hint 1:
The sysadmin shared that the company password policy is:
* only letters and symbols
* one capital letter
* one symbol

### Hint 2:
An audit of logs determined that the password was last changed in November.

## Analysis

To solve it, you use the given wordlist, but it needs a custom rule.

The first hint says that the password needs to follow a specific password policy. With that, you can trim out any password in the RockYou wordlist with a number or that does not include a symbol.

The second hint is super cryptic and states that the password policy was changed in November. November is significant because it is the eleventh month. From this, we can infer that the 11th character in the password needs to be capitalized. So, if you create a custom rule that runs through the wordlist and capitalizes the eleventh character, it should crack.

## Step 0 — Identify the Hash Type

The entry in the `leaked_passwords.txt` file with the password to crack is the one for `golden_admin`.

```
# Wonka Factory User Database - CONFIDENTIAL
# Format: username:hash_type:hash
# DO NOT DISTRIBUTE
#
# Generated: 2026-01-15
# Source: Factory Authentication Database Backup

operator1:md5:5f4dcc3b5aa765d61d8327deb882cf99
operator2:sha256:5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
plc_tech:md5:e10adc3949ba59abbe56e057f20f883e
hmi_admin:sha256:ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f
sensor_mon:md5:25d55ad283aa400af464c76d713c07ad
drive_tech:sha256:8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
historian:md5:7c6a180b36896a0a8c02787eeafb0e4c
network_eng:md5:098f6bcd4621d373cade4e832627b4f6
maintenance:sha256:65e84be33532fb784c48129675f9eff3a682b27168c0ea744b2cf58ee02337c5
vendor_access:md5:1e6947ac7fb3a9529a9726eb692c8cc5
scada_user:bcrypt:$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYjoJp3mZlW
backup_user:bcrypt:$2b$12$EXRdF7bKJD.7zqOJpvQ0eOZqP7r9rN8mL2xW4tG5hJ6kN8pL0qR2S
golden_admin:flag:$6$oHrYkuOTgiHrO8XO$z9pPWKs0f2jf2uw1FYFURAQJz/G4QvwZPng.D6mT7Ld4aFyYLzVi6LY.sDo6thROBmTy..vArEJvL5BFhhbk5/
```

The target line is:
```
golden_admin:flag:$6$oHrYkuOTgiHrO8XO$z9pPWKs0f2jf2uw1FYFURAQJz/G4QvwZPng.D6mT7Ld4aFyYLzVi6LY.sDo6thROBmTy..vArEJvL5BFhhbk5/
```
Looking at the format:
* $6$ = SHA-512 crypt
* This is Unix sha512crypt, not raw SHA-512
* Salted, iterated, but fast enough for wordlist + rules

Both **John the Ripper** and **hashcat** support this format.

For John, the format is simply: `sha512crypt`

## Step 1 — Isolate the `golden_admin` Hash

Create a target file with only the line that matters:
```
grep '^golden_admin' leaked_passwords.txt > golden.hash
```

John will automatically detect `sha512crypt`.

## Step 2 — Filter the Wordlist

The `filter.py` Python script was created to eliminate all words from `rockyou.txt` that do not meet the password policy rules:

* **Rule 1:** word cannot be null
* **Rule 2:** must have at least 11 characters
* **Rule 3:** cannot contain a number
* **Rule 4:** must contain at least one symbol (space counts)
* **Rule 5:** capitalize the 11th character if needed

```bash
python3 filter.py
```

After applying this filter, 135,421 passwords were saved to a new `filtered.txt` file.

## Step 3 — Run the Crack

### Command
```
john --wordlist=filtered.txt --max-length=24 golden.hash
```

### Output
```
Warning: detected hash type "sha512crypt", but the string is also recognized as "sha512crypt-opencl"
Use the "--format=sha512crypt-opencl" option to force loading these as that type instead
Using default input encoding: UTF-8
Loaded 1 password hash (sha512crypt, crypt(3) $6$ [SHA512 128/128 SSSE3 2x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Press 'q' or Ctrl-C to abort, almost any other key for status
chocolate#Mania  (golden_admin)
1g 0:00:03:13 DONE (2026-02-27 15:50) 0.005169g/s 460.5p/s 460.5c/s 460.5C/s chocolate_Rulz..chocoberry@yahoo.co.id
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

## Step 4 — Retrieve the Password

Confirm the cracked value.

### Command
```
john --show golden.hash
```

### Output
```
golden_admin:chocolate#Mania

1 password hash cracked, 0 left
```

---

## Solution

The flag is `chocolate#Mania`.

---

## Files

| File | Description |
|---|---|
| `leaked_passwords.txt` | Leaked factory user database with password hashes |
| `golden.hash` | Isolated `golden_admin` hash extracted for cracking |
| `filter.py` | Script to filter `rockyou.txt` according to the password policy |
| `filtered.txt` | Filtered wordlist output (135,421 passwords) |
| `rockyou.txt.zip` | Compressed common password wordlist |

---

## References

- [`ctf-techniques/crypto/`](../../../ctf-techniques/crypto/) — hash cracking Quick Reference
- [John the Ripper documentation](https://www.openwall.com/john/doc/)
- [Hashcat example hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)
- [HackTricks - Hash Cracking](https://book.hacktricks.xyz/generic-methodologies-and-resources/brute-force#hash-cracking)