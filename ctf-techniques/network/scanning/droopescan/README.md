# Droopescan and Drupwn

## Table of Contents
- [Droopescan and Drupwn](#droopescan-and-drupwn)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Droopescan](#droopescan)
    - [Usage](#usage)
  - [Drupwn](#drupwn)
    - [Usage](#usage-1)
  - [Comparison](#comparison)
  - [References](#references)

---

## Overview

Two automated scanners for Drupal and other CMS (Content Management System) platforms. Drupal has fewer dedicated scanning tools than WordPress, and those that exist are occasionally abandoned, but they remain useful for quickly detecting version numbers and vulnerable plugins.

---

## Droopescan

The older and more established of the two scanners, Droopescan receives occasional updates and supports five CMS platforms:

1. Drupal
2. SilverStripe
3. WordPress
4. Joomla
5. Moodle

### Usage

There are not many options for this scanner:
* `scan` will run a series of automated scans to look for known modules, themes and versions. It performs several thousand checks in total and can take several minutes to complete.
  ```bash
  droopescan scan drupal -u http://TARGET
  ```
* `stats` shows which versions exist for each supported CMS and how many checks are made.
  ```bash
  droopescan stats
  ```

---

## Drupwn

A newer scanner with fewer module detection checks than Droopescan, but with additional capabilities including:
- user detection,
- default file detection, and
- a CVE/exploit module (still in development at time of writing).

> **Notes:**
> - Run Drupwn from its own directory: `cd drupwn` before executing commands.
> - Scans can take a long time: use optional arguments to limit scope where possible.

### Usage

```bash
# Full enumeration scan
python3 drupwn enum http://TARGET

# User detection only
python3 drupwn enum http://TARGET --users

# Show all available options
python3 drupwn -h
```

---

## Comparison

| Feature | Droopescan | Drupwn |
|---|---|---|
| Module detection | Extensive | Limited |
| Theme detection | Yes | Limited |
| User detection | No | Yes |
| Default file detection | No | Yes |
| CVE / exploit module | No | Yes (WIP) |
| CMS support | Drupal, SilverStripe, WordPress, Joomla, Moodle | Drupal |

> **Note:** Neither scanner is guaranteed to cover the latest vulnerabilities. Always cross-reference findings with up-to-date sources such as the [Drupal Security Advisories](https://www.drupal.org/security).

---

## References

- [Droopescan on GitHub](https://github.com/SamJoan/droopescan)
- [Drupwn on GitHub](https://github.com/immunIT/drupwn)
- [Drupal Security Advisories](https://www.drupal.org/security)
- [Kali Tools — Droopescan](https://www.kali.org/tools/droopescan/)
