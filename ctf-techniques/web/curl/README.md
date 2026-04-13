# cURL

## Table of Contents
- [cURL](#curl)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Quick Reference](#quick-reference)
  - [Commands](#commands)
    - [Simple Connection](#simple-connection)
    - [Bypass TLS Certificate Check](#bypass-tls-certificate-check)
    - [Submit a POST Payload](#submit-a-post-payload)
      - [Single field:](#single-field)
      - [Multiple fields:](#multiple-fields)
    - [Send a POST Payload with JSON Data](#send-a-post-payload-with-json-data)
    - [Set a Cookie](#set-a-cookie)
      - [Single value:](#single-value)
      - [Multiple values:](#multiple-values)
    - [Inspect Response Headers](#inspect-response-headers)
      - [Headers only (HEAD request)](#headers-only-head-request)
      - [Full request and response detail](#full-request-and-response-detail)
    - [Set a Custom Request Header](#set-a-custom-request-header)
      - [Single Header](#single-header)
      - [Multiple headers](#multiple-headers)
    - [Spoof IP via X-Forwarded-For](#spoof-ip-via-x-forwarded-for)
      - [Common use cases in CTFs](#common-use-cases-in-ctfs)
      - [Spoof as localhost](#spoof-as-localhost)
      - [Spoof as internal network IP](#spoof-as-internal-network-ip)
      - [Spoof with multiple IPs (some apps read the first or last entry)](#spoof-with-multiple-ips-some-apps-read-the-first-or-last-entry)
      - [Other forwarding headers to try if `X-Forwarded-For` does not work](#other-forwarding-headers-to-try-if-x-forwarded-for-does-not-work)
    - [Path Traversal — Prevent URL Normalization](#path-traversal--prevent-url-normalization)
      - [URL-encode the traversal sequence manually](#url-encode-the-traversal-sequence-manually)
      - [Pass the path exactly as-is without normalisation](#pass-the-path-exactly-as-is-without-normalisation)
    - [Follow Redirects](#follow-redirects)
    - [Save Response to File](#save-response-to-file)
  - [Combining Flags](#combining-flags)
  - [References](#references)
    - [Labs](#labs)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

A command-line tool for transferring data to and from servers using a wide range of protocols. In CTF challenges, `curl` is used to interact with web servers, bypass security checks, manipulate headers and cookies, submit POST payloads, and probe for path traversal vulnerabilities.

## Quick Reference

| Flag | Description |
|---|---|
| `-k` | Skip TLS certificate verification |
| `-X METHOD` | Specify HTTP method (GET, POST, PUT, DELETE, etc.) |
| `-d "data"` | Send POST body data |
| `-b "name=value"` | Set a cookie |
| `-H "Name: Value"` | Set a request header |
| `-I` | Fetch headers only (HEAD request) |
| `--verbose` | Show full request and response including headers |
| `--path-as-is` | Send the URL path exactly as given without normalisation |

---

## Commands

### Simple Connection
```bash
curl http://TARGET:PORT
```

### Bypass TLS Certificate Check
Useful when a target uses a self-signed or invalid certificate:

```bash
curl https://TARGET:PORT/ -k
```

### Submit a POST Payload

#### Single field:
```bash
curl https://TARGET:PORT/ -k -X POST -d "key=value"
```

#### Multiple fields:
```bash
curl https://TARGET:PORT/ -k -X POST -d "key1=value1&key2=value2"
```

### Send a POST Payload with JSON Data
```bash
curl https://TARGET:PORT/api -k -X POST -H "Content-Type: application/json" -d '{"key": "value"}'
```

### Set a Cookie

#### Single value:
```bash
curl https://TARGET:PORT/ -k -b "name=value"
```

#### Multiple values:
```bash
curl https://TARGET:PORT/ -k -b "name1=value1; name2=value2"
```

### Inspect Response Headers

#### Headers only (HEAD request)
```bash
curl https://TARGET:PORT/ -k -I
```

#### Full request and response detail
```bash
curl https://TARGET:PORT/ -k --verbose
```

### Set a Custom Request Header

#### Single Header
```bash
curl https://TARGET:PORT/ -k -H "X-Custom-Header: value"
```

#### Multiple headers
```bash
curl https://TARGET:PORT/ -k -H "X-Custom-Header-1: value1" -H "X-Custom-Header-2: value2"
```

### Spoof IP via X-Forwarded-For

Some web applications use the `X-Forwarded-For` header to determine the client's IP address rather than the direct TCP source. This is common in Flask and other reverse-proxy setups where the app trusts forwarded headers from a load balancer. If the application fails to validate that the header came from a trusted proxy, an attacker can spoof it from the client side.

#### Common use cases in CTFs
- Bypassing IP allowlist / denylist checks
- Triggering code paths that expect internal IPs, e.g., `127.0.0.1`, `10.x.x.x`
- Exploiting applications that skip auth when the request appears to come from localhost

#### Spoof as localhost
```bash
curl https://TARGET:PORT/login -k \
  -H "X-Forwarded-For: 127.0.0.1" \
  -X POST -d "username=admin&password=test"
```

#### Spoof as internal network IP
```bash
curl https://TARGET:PORT/login -k \
  -H "X-Forwarded-For: 10.0.0.1" \
  -X POST -d "username=admin&password=test"
```

#### Spoof with multiple IPs (some apps read the first or last entry)
```bash
curl https://TARGET:PORT/ -k \
  -H "X-Forwarded-For: 127.0.0.1, 8.8.8.8"
```

#### Other forwarding headers to try if `X-Forwarded-For` does not work
```bash
-H "X-Real-IP: 127.0.0.1"
-H "Forwarded: for=127.0.0.1"
-H "True-Client-IP: 127.0.0.1"
-H "CF-Connecting-IP: 127.0.0.1"
```

**Tip:** Combine with cookies and POST data for authenticated requests:
```bash
curl https://TARGET:PORT/login -k \
  -H "X-Forwarded-For: 127.0.0.1" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -b "session=abc123" \
  -X POST -d "username=admin&password=secret"
```

### Path Traversal — Prevent URL Normalization
By default, `curl` normalises paths like `../../etc/passwd` before sending the request, which defeats path traversal attempts.

There are two ways to prevent this:

#### URL-encode the traversal sequence manually
```bash
curl https://TARGET:PORT/..%2F..%2Fpath%2Fto%2Ffile -k
```

#### Pass the path exactly as-is without normalisation
```bash
curl https://TARGET:PORT/../../path/to/file -k --path-as-is
```

### Follow Redirects
```bash
curl https://TARGET:PORT/ -k -L
```

### Save Response to File

```bash
curl https://TARGET:PORT/file.zip -k -o output.zip
```

---

## Combining Flags

Most flags can be combined freely. Below is a common pattern for authenticated API interaction:

```bash
curl https://TARGET:PORT/api/endpoint -k \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TOKEN" \
  -b "session=abc123" \
  -d '{"command": "whoami"}' \
  --verbose
```

---

## References

### Labs
| Source | Name |
|---|---|
| N/A | N/A |

### Challenges
| Source | Name | Notes |
|---|---|---|
| Holiday Hack Challenge 2024, Act I | [cURLing](../../../ctf-writeups/holiday-hack-challenge/2024/act-i/curling/README.md) | Introduction to commands |
| Holiday Hack Challenge 2025, Act III | [Hack-a-Gnome](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/hack-a-gnome/README.md) | API execution |
| Holiday Hack Challenge 2025, Act III | [Schrödinger's Scope](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/schroedingers-scope/README.md) | IP spoofing |

### Web Sites
- [curl man page](https://curl.se/docs/manpage.html)
- [curl cookbook](https://catonmat.net/cookbooks/curl)
- [curl tutorial](https://curl.se/docs/tutorial.html)
