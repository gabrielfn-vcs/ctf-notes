# Nikto and DIRB

## Table of Contents
- [Nikto and DIRB](#nikto-and-dirb)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Nikto](#nikto)
    - [Usage](#usage)
    - [Example Output](#example-output)
  - [DIRB](#dirb)
    - [Usage](#usage-1)
    - [Example Output](#example-output-1)
  - [References](#references)

---

## Overview

Two complementary web server scanning tools commonly used during the enumeration phase of a penetration test. Nikto identifies vulnerabilities in the server itself, while DIRB discovers hidden directories and files through brute-forcing.

---

## Nikto

Nikto is an open source scanner that runs over 600 tests against a web server, identifying potential vulnerabilities such as misconfigurations, outdated software, and insecure headers. Findings may reference Open Source Vulnerability Database (OSVDB) entries.

> **Note:** Nikto is not stealthy — its behavior is easily detected in IDS logs. This also makes it useful for testing whether an IDS solution is generating false positives.

### Usage

```bash
# Basic scan
nikto -host http://TARGET

# Check if the web server is running the latest version
nikto -host http://TARGET -plugin outdated
```

### Example Output

```
- Nikto v2.5.0
---------------------------------------------------------------------------
+ Target IP:          10.102.90.66
+ Target Hostname:    TARGET
+ Target Port:        80
---------------------------------------------------------------------------
+ Server: nginx
+ /: Cookie TrackingID created without the httponly flag.
+ /: The anti-clickjacking X-Frame-Options header is not present.
+ /: The X-Content-Type-Options header is not set.
+ /#wp-config.php#: #wp-config.php# file found. This file contains the credentials.
+ 7963 requests: 0 error(s) and 7 item(s) reported on remote host
---------------------------------------------------------------------------
```

---

## DIRB

DIRB (the command line version of DirBuster) is a web content scanner that comes pre-installed on Kali Linux. It brute-forces directories and file names on a web server using a wordlist, making it useful for discovering hidden paths that aren't linked or listed from the main domain.

DIRB is often used to help with web application auditing. It can recursively scan IPs and domains for directories and, with a command line switch, it can brute force file names too.

DIRB uses HTTP status codes to determine whether a file or directory exists. For targets with custom 404 pages that return `200 OK`, additional options are available to distinguish missing files from valid ones.

### Usage

```bash
# Basic scan using the default wordlist
# Scans everything under /var/www/html on the target
dirb http://TARGET

# Scan using a custom wordlist
dirb http://TARGET /usr/share/wordlists/custom/wordlist.txt

# Recursively scan and brute-force file names
dirb http://TARGET -r
```

### Example Output

```
-----------------
DIRB v2.22
-----------------
URL_BASE: http://TARGET/
WORDLIST_FILES: /usr/share/wordlists/custom/wordlist.txt

---- Scanning URL: http://TARGET/ ----
+ http://TARGET/login (CODE:200|SIZE:4692)

DOWNLOADED: 64 - FOUND: 1
```

---

## References

- [Nikto on GitHub](https://github.com/sullo/nikto)
- [DIRB](https://dirb.sourceforge.net/)
- [Kali Tools — Nikto](https://www.kali.org/tools/nikto/)
- [Kali Tools — DIRB](https://www.kali.org/tools/dirb/)
