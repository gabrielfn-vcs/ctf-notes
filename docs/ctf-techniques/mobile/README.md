# Mobile Applications

## Table of Contents
- [Mobile Applications](#mobile-applications)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Topics Covered](#topics-covered)
  - [Quick Reference](#quick-reference)
    - [APK Decompilation](#apk-decompilation)
    - [AAB to APK Conversion](#aab-to-apk-conversion)
    - [Finding Secrets](#finding-secrets)
    - [SQLite Database Inspection](#sqlite-database-inspection)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Techniques for reverse engineering and analyzing Android applications encountered in CTF challenges.

---

## Topics Covered

**APK unpacking** — Extracting and decompiling Android APK files to recover source code, resources, and configuration.

**AAB analysis** — Inspecting Android App Bundle (`.aab`) files, which require conversion before decompilation.

**Hardcoded secrets** — Locating API keys, credentials, encryption keys, and flags embedded in app resources or source code.

**SQLite database analysis** — Inspecting local app databases for stored data, credentials, or flags.

**Encryption key extraction** — Recovering keys from app resources (`strings.xml`, compiled classes) and using them to decrypt data.

---

## Quick Reference

### APK Decompilation

```bash
# Unpack APK resources (AndroidManifest, resources, etc.)
apktool d app.apk -o output/

# Decompile to Java source
jadx -d output/ app.apk

# Or use jadx-gui for interactive browsing
jadx-gui app.apk
```

### AAB to APK Conversion

```bash
# Use bundletool to generate an APK set
bundletool build-apks --bundle=app.aab --output=app.apks --mode=universal

# Extract the universal APK
unzip app.apks -d apks/
# universal.apk is now in apks/
```

### Finding Secrets

```bash
# Search strings.xml for keys
grep -i "key\|secret\|password\|token" res/values/strings.xml

# Search decompiled source
grep -r "key\|secret\|AES\|encrypt" src/

# Strings in compiled binary
strings app.apk | grep -i flag
```

### SQLite Database Inspection

```bash
# Open with sqlite3
sqlite3 app.db

# List tables
.tables

# Dump a table
SELECT * FROM users;
```

---

## References

### Challenges
| Source | Name |
|---|---|
| Holiday Hack Challenge 2024, Act II | [Mobile Analysis](../../ctf-writeups/holiday-hack-challenge/2024/act-ii/mobile-analysis/README.md) |

### Web Sites
- [jadx — Android Decompiler](https://github.com/skylot/jadx)
- [apktool](https://apktool.org/)
- [bundletool](https://developer.android.com/tools/bundletool)
- [HackTricks - Android APK Checklist](https://angelica.gitbook.io/hacktricks/mobile-pentesting/android-app-pentesting/apk-decompilers)
