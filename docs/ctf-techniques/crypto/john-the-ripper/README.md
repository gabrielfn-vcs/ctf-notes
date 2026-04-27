# John the Ripper

## Table of Contents
- [John the Ripper](#john-the-ripper)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Installation](#installation)
  - [Core Concepts](#core-concepts)
    - [Hash Extraction — `2john` Utilities](#hash-extraction--2john-utilities)
    - [The `.pot` File](#the-pot-file)
    - [Sessions](#sessions)
  - [Quick Reference](#quick-reference)
  - [Cracking Modes](#cracking-modes)
    - [Wordlist Mode](#wordlist-mode)
    - [Rules — Wordlist Mangling](#rules--wordlist-mangling)
    - [PRINCE Mode — Multi-Word Combinations](#prince-mode--multi-word-combinations)
    - [Incremental Mode — Brute Force](#incremental-mode--brute-force)
  - [Specifying the Hash Format](#specifying-the-hash-format)
  - [Workflow Tips](#workflow-tips)
    - [Preview Candidates with `--stdout`](#preview-candidates-with---stdout)
    - [Retrieve Cracked Passwords](#retrieve-cracked-passwords)
    - [Check Progress While Running](#check-progress-while-running)
    - [Stop and Resume](#stop-and-resume)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

John the Ripper (John) is a password cracking tool that supports dictionary attacks, brute force, and rule-based mangling across hundreds of hash types. The jumbo community build adds GPU support, the PRINCE mode, and the `2john` family of extraction utilities.

> [!WARNING]
> Use John only on hashes you own or have explicit written authorization to test. Unauthorized use is illegal.

---

## Installation

The jumbo version (recommended as it includes all `2john` utilities and PRINCE mode) can be installed on macOS via Homebrew:

```bash
brew install john-jumbo
```

Verify the installation and check the version:
```bash
john --list=build-info
```

---

## Core Concepts

### Hash Extraction — `2john` Utilities

Before cracking, you need to extract the hash from whatever is protecting the file or credential. John ships with a family of `*2john` utilities that handle this:

| Utility | Input | Use case |
|---|---|---|
| `gpg2john` | GPG/PGP encrypted file | Extract passphrase hash from `.gpg` file |
| `zip2john` | ZIP archive | Extract password hash from encrypted ZIP |
| `rar2john` | RAR archive | Extract password hash from encrypted RAR |
| `ssh2john` | SSH private key | Extract passphrase hash from `id_rsa` |
| `pdf2john` | PDF file | Extract password hash from encrypted PDF |
| `keepass2john` | KeePass database | Extract master password hash from `.kdbx` |

All utilities follow the same pattern:
1. Extract has from encrypted file.
2. Pipe output into a text file
3. Crack that file.

```bash
# General pattern
<utility> <input_file> > hash.txt
john hash.txt

# Examples
gpg2john secret.gpg > gpg.hash && john --wordlist=wordlist.txt gpg.hash
zip2john archive.zip > zip.hash && john --wordlist=rockyou.txt zip.hash
ssh2john id_rsa > ssh.hash && john --wordlist=rockyou.txt ssh.hash
```

### The `.pot` File

John stores cracked passwords in a `.pot` file (default: `~/.john/john.pot`). This means:
- Re-running John on the same hash will show "No password hashes left to crack" as it already knows the answer.
- Use `john --show hash.txt` to retrieve previously cracked passwords from the pot file.
- Use `john --pot=custom.pot` to use a different pot file per session.

### Sessions

Long cracks (especially GPG with high iteration counts) can take minutes or hours. Always name your sessions so you can resume them:

```bash
# Start a named session
john --wordlist=wordlist.txt --session=my_crack hash.txt

# Resume an interrupted session
john --restore=my_crack

# Check status of a named session (from another terminal)
john --status=my_crack
```

If you forget to name a session, John saves progress to a default session file that can be restored with `john --restore`.

---

## Quick Reference

| Task | Command |
|---|---|
| Crack with wordlist (auto-detect hash) | `john --wordlist=rockyou.txt hash.txt` |
| Crack with wordlist + rules | `john --wordlist=rockyou.txt --rules hash.txt` |
| Crack with PRINCE mode (3-word combos with max length) | `john --prince=wordlist.txt --prince-elem-cnt-min=3 --prince-elem-cnt-max=3 --max-length=24 hash.txt` |
| Brute force | `john --incremental hash.txt` |
| Force a specific hash format | `john --format=sha512crypt --wordlist=rockyou.txt hash.txt` |
| Preview candidates without cracking | `john --wordlist=wordlist.txt --rules --stdout \| head -20` |
| Show cracked passwords | `john --show hash.txt` |
| Resume interrupted session | `john --restore=session_name` |
| List all supported formats | `john --list=formats` |

---

## Cracking Modes

### Wordlist Mode

The most common mode. John tries each word in the list as-is:

```bash
john --wordlist=/path/to/wordlist.txt hash.txt
```

Common wordlists:
- `rockyou.txt` — 14 million real passwords from the 2009 RockYou breach; the standard starting point
- `/usr/local/share/wordlists/` — installed via KaliLists (see `ctf-techniques/` setup guide)
- Custom filtered wordlists when the password policy is known (see [Workflow Tips](#workflow-tips))

### Rules — Wordlist Mangling

Rules transform each word in the wordlist to generate variations. Enable the default rules with `--rules`:

```bash
john --wordlist=rockyou.txt --rules hash.txt
```

**Default rules** are defined in the `/usr/local/share/john/john.conf` file and are applied to each word in the list:

| Transformation | Example |
|---|---|
| Capitalize first letter | `password` → `Password` |
| All uppercase | `password` → `PASSWORD` |
| Append digits | `password` → `password1`, `password123` |
| Append symbols | `password` → `password!` |
| Prepend digits | `password` → `1password` |
| Reverse word | `password` → `drowssap` |
| Leetspeak substitution | `password` → `p@ssw0rd` |
| Concatenate word with itself | `password` → `passwordpassword` |

> [!TIP]
> Preview what rules will generate before running a full crack:
> ```bash
> john --wordlist=wordlist.txt --rules --stdout | head -20
> ```
> If you see truncated words, your `--max-length` setting is too low.

**Named rule sets** are available to target specific transformation profiles:

```bash
john --wordlist=rockyou.txt --rules=Jumbo hash.txt      # large comprehensive set
john --wordlist=rockyou.txt --rules=KoreLogic hash.txt  # common policy-compliant patterns
```

**Custom immediate rules** can apply a one-off transformation without editing `john.conf`. Rules use a single-character DSL (Domain Specific Language):

| Rule character | Effect |
|---|---|
| `c` | Capitalize first letter |
| `u` | Uppercase all |
| `l` | Lowercase all |
| `r` | Reverse word |
| `Az"X"` | Append string `X` |
| `A0"X"` | Prepend string `X` |
| `CN` | Capitalize character at position N (0-indexed) |

Example to capitalize the 11th character (position 10, 0-indexed) of each word:
```bash
john --wordlist=filtered.txt --rules=:C10 hash.txt
```

Custom rules can also be written in the `john.conf` file under a named section for reuse.

### PRINCE Mode — Multi-Word Combinations

PRINCE (Password Recovery INtelligent Command Engine) generates candidates by combining multiple words from a single wordlist. This is specifically effective for passphrases like `sweetfizzyriver` or `correcthorsebatterystaple`.

```bash
# Combine exactly 3 words, max 24 characters
john --prince=wordlist.txt \
     --prince-elem-cnt-min=3 \
     --prince-elem-cnt-max=3 \
     --max-length=24 \
     hash.txt
```

Key options:

| Option | Description |
|---|---|
| `--prince=FILE` | Wordlist to draw elements from |
| `--prince-elem-cnt-min=N` | Minimum number of words to combine (default: 1) |
| `--prince-elem-cnt-max=N` | Maximum number of words to combine (default: 8) |
| `--prince-case-permute` | Try case variations of generated candidates |
| `--max-length=N` | Maximum candidate length (needed to override the default of 12 for multi-word passphrases) |

> [!WARNING]
> The default `--max-length` in John is 12. For PRINCE mode with 3+ words, this will silently truncate or skip candidates without any error. Always set `--max-length` explicitly. Use `--stdout` first to verify candidates are not being cut off:
> ```bash
> john --prince=wordlist.txt --prince-elem-cnt-min=3 --prince-elem-cnt-max=3 --max-length=24 --stdout | head -20
> ```

### Incremental Mode — Brute Force

Tries all possible character combinations up to a given length. Slow for long passwords but exhaustive:

```bash
john --incremental hash.txt
```

Use named character sets to constrain the search space:

```bash
john --incremental=alpha hash.txt    # lowercase letters only
john --incremental=upper hash.txt    # uppercase letters only
john --incremental=digits hash.txt   # digits only
```

---

## Specifying the Hash Format

John auto-detects most hash types, but you may need to force it when a hash could match multiple formats or when the auto-detection is wrong:

```bash
john --format=sha512crypt --wordlist=rockyou.txt hash.txt
```

Common formats by context:

| Context | Format identifier |
|---|---|
| Linux `/etc/shadow` (MD5) | `md5crypt` |
| Linux `/etc/shadow` (SHA-256) | `sha256crypt` |
| Linux `/etc/shadow` (SHA-512) | `sha512crypt` |
| Windows NTLM | `nt` |
| Windows LM | `lm` |
| Raw MD5 | `raw-md5` |
| Raw SHA-1 | `raw-sha1` |
| Raw SHA-256 | `raw-sha256` |
| bcrypt | `bcrypt` |
| GPG/PGP passphrase | `gpg` |
| ZIP archive | `zip` |
| RAR archive | `rar` |
| SSH private key | `ssh` |

Identify the format from the hash prefix:

| Prefix | Format |
|---|---|
| `$1$` | `md5crypt` |
| `$5$` | `sha256crypt` |
| `$6$` | `sha512crypt` |
| `$2b$` or `$2y$` | `bcrypt` |
| `$gpg$` | `gpg` (from `gpg2john`) |

List all formats supported by your installation:
```bash
john --list=formats
john --list=subformats   # additional sub-formats
```

---

## Workflow Tips

### Preview Candidates with `--stdout`

Before running a long crack, verify that your mode and options are generating the right candidates:

```bash
# Preview wordlist + rules output
john --wordlist=filtered.txt --rules --stdout | head -20

# Preview PRINCE combinations
john --prince=wordlist.txt --prince-elem-cnt-min=3 --prince-elem-cnt-max=3 \
     --max-length=24 --stdout | head -20
```

If you see truncated words or unexpected output, fix the options before committing to a multi-hour crack.

### Retrieve Cracked Passwords

```bash
# Show all cracked passwords for a hash file
john --show hash.txt

# Show uncracked hashes (useful for large files)
john --show=left hash.txt
```

### Check Progress While Running

Press any key while John is running to print a one-line status update. For detailed status, press `Enter` or check a named session from another terminal:

```bash
john --status=my_crack
```

### Stop and Resume

John saves progress automatically. Interrupt safely with `Ctrl+C` and resume later:

```bash
# Resume the most recent session
john --restore

# Resume a named session
john --restore=my_crack
```

---

## References

### Challenges

| Source | Name | Notes |
|---|---|---|
| CTFd 2026 | [Decrypt](../../../ctf-writeups/ctfd/2026/decrypt/README.md) | GPG passphrase cracking with PRINCE mode |
| CTFd 2026 | [Hash Crack](../../../ctf-writeups/ctfd/2026/hash-crack/README.md) | SHA-512 crypt cracking with custom-filtered wordlist |
| Holiday Hack Challenge 2025, Act III | [Hack-a-Gnome](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/hack-a-gnome/README.md) | Unsalted MD5 cracking (CrackStation used instead) |

### Web Sites

- [John the Ripper documentation](https://www.openwall.com/john/doc/)
- [John the Ripper command-line options](https://www.openwall.com/john/doc/OPTIONS.shtml)
- [John the Ripper PRINCE mode](https://github.com/magnumripper/JohnTheRipper/blob/bleeding-jumbo/doc/PRINCE)
- [Hashcat example hashes](https://hashcat.net/wiki/doku.php?id=example_hashes) — useful for identifying hash types by prefix
