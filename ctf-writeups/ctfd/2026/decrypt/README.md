# Decrypt the Stolen Recipe Fragment

## Table of Contents
- [Decrypt the Stolen Recipe Fragment](#decrypt-the-stolen-recipe-fragment)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Hints](#hints)
  - [Analysis](#analysis)
  - [Step 0: Extract the hash](#step-0-extract-the-hash)
    - [Command](#command)
    - [Output](#output)
  - [Step 1: Verify PRICE output](#step-1-verify-price-output)
    - [Command](#command-1)
    - [What you should see](#what-you-should-see)
    - [Output](#output-1)
  - [Step 2: Run the actual crack (CPU format recommended)](#step-2-run-the-actual-crack-cpu-format-recommended)
    - [Command](#command-2)
    - [Output](#output-2)
  - [Step 3: Retrieve the password](#step-3-retrieve-the-password)
    - [Command](#command-3)
    - [Output](#output-3)
  - [Step 4: Decrypt the file and extract the flag](#step-4-decrypt-the-file-and-extract-the-flag)
    - [Command](#command-4)
    - [Output](#output-4)
  - [Solution](#solution)
  - [Files](#files)
  - [References](#references)

---

## Overview

The encrypted file feels heavy, even before it is opened. Wonka stares at its name—"QC_export"—and grips his cane.

"If this contains what I think it does," he says, "someone intends to sell my dreams by the ounce."

**Task:** Decrypt the file and extract the unique ingredient codename inside.

**Flag:** Enter the ingredient codename as the flag

**Files:**
* `wonka_wordlist.txt`
* `QC_export.txt.gpg`

---

## Hints

The goal of the challenge is to introduce a John the Ripper mode called PRINCE, which combines words in a word list together.

There is a hint with a video that mentions the number three (3), which is the number of words in the password.

---

## Analysis

We first need to extract the hash from the GPG file using `gpg2john`.

GPG S2K is slow; hence, few high-quality guesses is preferred over a brute force method.

The password is expected to contain three (3) words concatenated from `wonka_wordlist.txt`.

Order matters. If you use the PRINCE mode with the min and max words set to 3, it will generate permutations efficiently.

We also need to set the max password length to 24 (the max on John the Ripper). The default max password size in John the Ripper is 12. Default John settings will silently sabotage you unless you override them. Hence, if you do not change it, you will never crack it. You should use `--stdout` to view the output of the `john` command and see if it is truncating the wordlist.

The crack can be done quickly following the steps above. The password was chosen so that PRINCE would hit that word within the first ~330 tries.

## Step 0: Extract the hash

### Command
```
gpg2john QC_export.txt.gpg > gpg_hash.txt
```
This will create a file `gpg_hash.txt` that contains the hash we need to crack.

### Output
```
$gpg$*0*2127*1149ad4a15e138bf3b0dcf6407700e28a03bab975975f028d4f33cf430878a55d01bbcc73b38bfb51b87dae53decbb95fe318718da62a35d0cba38960aea3ea563b7117e22a9eca3ff733bbb298a282eef9a5a69b40b820ac6fa5543994b0957c12c9d2821b85869ff7bb1fb9faafb7321c8d81a6268ec2ef3113c791ddc37f80178ddc416ebc14ff169983e5e57f5f237e8ddaa175b50c86fd8a5a56a6116f65763e2eb98ac3ca3fa5dddc16e174b9c13bd011db40d9e674e0e12c0b5819b283ebaec44a88c88e1ff8eaa9e88a162324b243cb02e4881158d9792ac762c12e885ced9e6b931bc93a8487c5422166f861b35de1fad7440dd2b307508cb00669982d2e437b3cdf30ea67329e744f4c1db66ad09f1dc75288925000854494f22d0ae171beb52ea8d88c2f3029d430a335c6a1c2c362a2dab597ad4559d3603c9c5c4ea3fcebb460c553f63b50c01597e8348e373eee73121dfea4f5fe3febcb9be7032818769862f5005e8bf1c88d18e5a5612143fa39005100a39fa9f0a4100b786eb9ce5ceaef192ae500ba4007c0970f19cc911cd08b03c979c0e844fbbbc72e64c3105320e0ed350f7f2c80afc5490f10e48d7c2349abb2f50d22242af63e6a3ad7ee1075e950fe4fb2678891fabb1786b3d0d709aa2de7106971f5de00daf77929906c64f88b16b1dc4acfe09bd3b064250e0df1b8961c26b84e7f712077be1445dd280489ab4797bce135bb812af9b44fdbf86c412982f0a5928aeab8030bb5f51ad73b4cf39caa06c79209a8b66a73d29c67eb1e1ad787e05d5afd0a96c1f6d27964057106111912db19d0d67fd2aef66beed96518341c4564c49f39e4a815cd1064356c37922220fc216f6c2508aca8863d6e3e17692039607ced6423b798cd9b96c3a755c249129b24e790df7e63042f953a170908cee68d31b4aa72a2e7d09e29d44cd510506d2da43098b24b0f44b66ef9af225e3aa43dd4b04d2e316e0070e52fd3366d5cf3e8e6e8d799b5b3d4fe9e313b078901e88ecd54add9851efce6fa854782e6dc8371c3c657f421d1b2c43623abc3f1562e96dcd91bf32637d0bf3d10c25766c5b77bf19e72372e93cc3d13c508c490fd4ef9388717ad63445286ecfd5cba484755c47e18ff9f45d8db377168d7ed4419dc8756172c14aafba79fb99cc8083c57fa7b9bf3e1a5c966e5e32ef1bdb94d4da3ed5b27365305201c743a897e88f834d43e26d329a41dd712c67129a26729a02b3f53a07efd3776dba8c27b5bbec1a7b2ba1f6fbbdb0f92f4fd576b5b69c6696c752266e03a0f9409beb55c57485027f44b5dfe5263a7ca928c15eceab5148e9f74a90368003d3ebd156d07d1f8be9e2d6c61d37239b7abc54f9acad764dad9e0f7c121424aa0a99677f0422983fcad20819f6da0c5eb2a215c511ba78c2e319ee3e22184cb1424e727a36a604293570b49ec3f8c859a7d629ca25fbf44d344b0b676a20537b2ebf600f8ec0a3b389ffa940a3b51c7bef350aae9a0e6ba6993e7075121c163f0f57981e2c98147a2868bdb56bbe6afc20c88ddf848bc011d3f53add505ef69f330351743e91161a8d9e233bc81d85df36b0db30363e6a37aa9112c1d1b18d3a3bcd38023103e5802a11cc4fcaf99113404857067d0e325ad5e491e0055847065e30606d356cc016c5d17cd67e5c0e679ec25c31f73c026cab0f017c494a5d6c9ae1ece0bb565970793023e6795512f1fe94f36b52a0013c9fdbe4495a6bf79d36c65bf69d19554dbe821b8dad50206cf058da889b9d5258e5b5d9d090f16e7dde5368223e343c2f292854a9d44bcbcea86a5ef4044bca50af97a57ca66cc097818ef011b8af2d2e2e92f2e94baf9427b9a4270109d474d5093d9bfaee62bed5645c615b6636b54e809fd16b511578e67217646ec187738950eb055c6b064c2cc50fbe622441b9da9a7e3ea40eb5223260b1a0cdafae0aeeb24d71c887d121927168254c5631a14a4ffb34c53879b5129f952645c489dc9cad30232fea94dd3d945da9c9c26335b834aa5dc1fa56b98b46b7d1f7d1b9ce7915f6a9618903a3955060488f50d5d2bc620cac0c640004a3a0a44ae0d6ff0813ad5c0ab1a31e39d214046e93df208981388649dcdbe7ab4b6b5dde288d8b5e3c0b61949ed9feb65e9c3cacf74621fb4ec3680bf507cdac04f17d4e82a18fd583b9001cae02d7d4ab24292cead049667e0d071a55bd26223e091c2f35c9c04db1c3a4cbd6bc6001106543ca5c389aa5087aa14894064295b9e4f0b0e2d64596186abf1e588eeeba34aeb39ffc152c871fa8c8c2fe61294e8ade30ddaec65753dc2f4089928144b887e5ba94f14e57ff22940d57399a220ce423b73db823ad7636ffd69de15de1527519bb75f0a704dc3d38aa8d9e67baea3f3db879ccd68fc091be82c0c6894d641686188bae5d988a91263bcc5895456d433c45746e9045d6469712d4455c87dacb40091d36dd4589421fd064dcb221c0c917c3b7928136dc8b11b410be5c0ff12b93cc851c705036240813f683dae84ef702d6ad5b9e23b47a6dd476d911c57434af65a71a611529964c30d52e4812de6198411ac13180a211366bd540ebf5f77a34ee4f1cbd23773f2b6b57d997b9665c030b449bd3b517eac1caf5dee7a82d52c9d42179e88e090f4897b9549c6f8fd008bdc2c7f6f7704edc9b1604d19a7d9729b8b84b08064d5addf2398fd6222eedf374e57131332e36a85077ed28ba55a35a2f900ce4d9c82f7b7b6acb822287cdd298adf1ac6566d21264f7dfa4b0713a62d29cee5eda1d250b286da7441e8f8f56a1e752a744e96b5a236474fc1d28202b0756aca9407485d742557678df9506b094a621f2c6ad99397bdffa93aaacac17aa37a562db3d3b5f374619344bfb26d3db90c8144c17cf99c16f9c762e01bbf8d07a87c6acd9a0893d978a435f993f09270afb946ed9b901910e50a27526501dc3fdf3e4cf0b58bafa930341d48e*3*18*10*9*65011712*dbd2ed62e3df74ec
```

It is a long string that starts with `$gpg$` and is followed by several fields separated by `*`. Each field contains specific information about the hash, such as the version, the hash type, the cost parameters, and the actual hash value.

The prefix tells that this is a GnuPG / OpenPGP s@K (String-toKey) hash representation.
```
$gpg$*0*2127*1149ad4a15e138bf3b0dcf6407700e28a03ba...
```

Near the end we can see the fields that map to OpenPGP internals:
```
*3*18*10*9*65011712*dbd2ed62e3df74ec
```

| Field	| Meaning |
| --- | --- |
| 3 | S2K type (iterated & salted) |
| 18 | Cipher mode |
| 10 | Hash algorithm (SHA-512) |
| 9 | Cipher (AES-256) |
| 65011712 | Iteration count |
| dbd2ed62e3df74ec | Salt |

## Step 1: Verify PRICE output

Before cracking anything, confirm PRINCE is generating correct candidates.

### Command
```
john --prince=wonka_wordlist.txt --prince-elem-cnt-min=3 --prince-elem-cnt-max=3 --max-length=24 --stdout | head -n 20
```

### What you should see
* Three full words concatenated
* No truncation
* Lengths approaching 24 characters
* If you see chopped words, then stop and fix `--max-length`.

### Output
```
Press 'q' or Ctrl-C to abort, almost any other key for status
wonkawonkachocolate
fizzywonkachocolate
riverwonkachocolate
geesewonkachocolate
knidswonkachocolate
candywonkachocolate
sweetwonkachocolate
treatwonkachocolate
prizewonkachocolate
happywonkachocolate
merrywonkachocolate
partywonkachocolate
wonkafizzychocolate
fizzyfizzychocolate
riverfizzychocolate
geesefizzychocolate
knidsfizzychocolate
candyfizzychocolate
sweetfizzychocolate
treatfizzychocolate
```

## Step 2: Run the actual crack (CPU format recommended)

For OpenPGP, CPU mode is often more stable than OpenCL.

### Command
```
john --prince=wonka_wordlist.txt --prince-elem-cnt-min=3 --prince-elem-cnt-max=3 --max-length=24 --format=gpg --session=wonka_prince gpg_hash.txt 
```
* PRINCE generates only meaningful combinations
* Search space stays small and manageable
* The correct password appears in a short time

### Output
```
Using default input encoding: UTF-8
Loaded 1 password hash (gpg, OpenPGP / GnuPG Secret Key [32/64])
Cost 1 (s2k-count) is 65011712 for all loaded hashes
Cost 2 (hash algorithm [1:MD5 2:SHA1 3:RIPEMD160 8:SHA256 9:SHA384 10:SHA512 11:SHA224]) is 10 for all loaded hashes
Cost 3 (cipher algorithm [1:IDEA 2:3DES 3:CAST5 4:Blowfish 7:AES128 8:AES192 9:AES256 10:Twofish 11:Camellia128 12:Camellia192 13:Camellia256]) is 9 for all loaded hashes
Press 'q' or Ctrl-C to abort, almost any other key for status
sweetfizzyriver  (?)
1g 0:00:01:03 DONE (2026-02-27 14:58) 0.01568g/s 8.109p/s 8.109c/s 8.109C/s sweetfizzyriver
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

## Step 3: Retrieve the password

Confirm the cracked value.

### Command
```
john --show gpg_hash.txt
```
### Output
```
?:sweetfizzyriver

1 password hash cracked, 0 left
```

## Step 4: Decrypt the file and extract the flag

### Command
```
gpg --batch --pinentry-mode loopback --passphrase sweetfizzyriver -d QC_export.txt.gpg
```
Inside the decrypted file will be the ingredient codename: that is the flag.

### Output

This is the relevant portion of the decrypted file:

```
═══════════════════════════════════════════════════════════════

INGREDIENT SOURCING NOTES:

**AURORA-X7** - CRITICAL INFORMATION:
This proprietary compound is the key to the Everlasting Gobstopper 2.0's
extended duration and enhanced flavor cycling. It is synthesized in-house
using a secret process known only to Willy Wonka and head Oompa Loompa
chemist #3.

AURORA-X7 Properties:
- Appearance: Iridescent crystalline powder
- Color: Shifts between purple, blue, and gold
- Solubility: Highly soluble in sugar matrix above 95°C
- Stability: Stable at room temperature, reactive above 150°C
- Shelf Life: 6 months refrigerated

WARNING: Do not expose AURORA-X7 to competitors. Patent pending.
Industrial espionage attempts have been detected.

═══════════════════════════════════════════════════════════════
```

## Solution

The flag is `AURORA-X7`.

---

## Files

| File | Description |
|---|---|
| `QC_export.txt.gpg` | GPG-encrypted file containing the secret recipe |
| `QC_export.txt` | Decrypted plaintext output |
| `gpg_hash.txt` | Hash extracted from the GPG file via `gpg2john` |
| `wonka_wordlist.txt` | Custom wordlist used as the PRINCE input |
| `decrypt.py` | Python script to decrypt using the recovered passphrase |
| `decrypt.sh` | Bash script for interactive passphrase testing |

---

## References

- [`ctf-techniques/crypto/`](../../../ctf-techniques/crypto/) — GPG passphrase cracking and hash cracking reference
- [John the Ripper PRINCE mode](https://github.com/magnumripper/JohnTheRipper/blob/bleeding-jumbo/doc/PRINCE)
- [gpg2john](https://www.openwall.com/john/doc/OPTIONS.shtml)
- [HackTricks - GPG](https://book.hacktricks.xyz/crypto-and-stego/cryptography-tools#gpg)