# WPScan

## Table of Contents
- [WPScan](#wpscan)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Usage](#usage)
    - [Basic Vulnerability Scan](#basic-vulnerability-scan)
    - [User Enumeration](#user-enumeration)
    - [Plugin Scan](#plugin-scan)
    - [Theme Enumeration](#theme-enumeration)
    - [Brute Force](#brute-force)
    - [Combined Scan](#combined-scan)
  - [Quick Reference](#quick-reference)
  - [References](#references)

---

## Overview

WPScan is an automated black box WordPress vulnerability scanner that comes pre-packaged in Kali Linux. 

It is formed of two parts:

1. The **WPScan Vulnerability Database (WpVulnDB)** is a website with a catalogue that lists all known vulnerabilities in WordPress core, plugins and themes. For each vulnerability, it lists basic details such as the impacted versions and their release dates. It does not contain any exploit code; however, with some versions of WordPress and WordPress plugins, WPScan will provide links to known vulnerabilities.

2. WPScan is the command-line tool that uses the database and other plugins to scan WordPress sites for known vulnerabilities.

WPScan's primary strength is enumeration, making it a natural first step before moving into exploitation with tools like Hydra.

---

## Usage

WPScan's primary strength is enumeration, making it a natural first step to discover information on the WordPress site before moving into exploitation with tools like Hydra.

WPScan has a variety of capabilities when it comes to testing Wordpress sites. It can enumerate users, scan for vulnerable themes and plugins, and even brute force passwords. You can use the `--help` option to learn more about WPScan's other features.

### Basic Vulnerability Scan

```bash
wpscan --url http://TARGET
```

### User Enumeration

Generates a list of WordPress usernames, which can then be used as input for a brute force attack:

```bash
wpscan -e u --url http://TARGET
```
or
```bash
wpscan --enumerate u --url http://TARGET
```

### Plugin Scan

Scans for installed plugins and attempts to identify their version numbers. By default, only plugins with known vulnerabilities are checked:

```bash
wpscan -e p --url http://TARGET

# Scan all plugins, not just vulnerable ones
wpscan --enumerate ap --url http://TARGET

# Use aggressive detection if the default returns no results
wpscan --enumerate ap --plugins-detection aggressive --url http://TARGET
```

> **Note:** Aggressive plugin scanning takes longer than a standard scan.

### Theme Enumeration

Lists installed themes and flags any known vulnerabilities:

```bash
wpscan -e t --url http://TARGET
# or
wpscan --enumerate t --url http://TARGET
```

### Brute Force

Attempts to guess a user's password against a wordlist. Combine with discovered usernames from the enumeration step:

```bash
wpscan --url http://TARGET --passwords /usr/share/wordlists/rockyou.txt

# Target a specific user
wpscan --url http://TARGET --usernames admin --passwords /usr/share/wordlists/rockyou.txt

# Kali metasploit wordlist (referenced in lab)
wpscan --url http://TARGET --passwords /usr/share/wordlists/metasploit/namelist.txt
```

### Combined Scan

Run user enumeration, plugin scan, and theme enumeration together:

```bash
wpscan --url http://TARGET --enumerate u,p,t
```

---

## Quick Reference

| Option | Description |
|---|---|
| `--url` | Target URL or IP address |
| `-e u` / `--enumerate u` | Enumerate users |
| `-e p` / `--enumerate p` | Enumerate vulnerable plugins |
| `-e ap` | Enumerate all plugins |
| `-e t` / `--enumerate t` | Enumerate themes |
| `--plugins-detection aggressive` | More thorough plugin detection |
| `--passwords FILE` | Brute force with a wordlist |
| `--usernames USER` | Target a specific username for brute force |
| `--help` | Full list of options |

---

## References

- [WPScan Official Site](https://wpscan.com/)
- [WPScan on GitHub](https://github.com/wpscanteam/wpscan)
- [WPScan Vulnerability Database](https://wpscan.com/plugins)
- [Kali Tools — WPScan](https://www.kali.org/tools/wpscan/)
