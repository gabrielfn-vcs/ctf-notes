# cURLing

## Table of Contents
- [cURLing](#curling)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
    - [Silver](#silver)
    - [Gold](#gold)
  - [References](#references)
  - [Navigation](#navigation)

---

## Overview

Well hello there! I’m Bow Ninecandle, bright as a twinkling star! Everyone’s busy unpacking, but I’ve grown quite bored of that. Care to join me for a lovely game?

Oh Joy! Today, We’re diving into something delightful: the curling challenge—without any ice, but plenty of sparkle!

No icy brooms here though! We’re all about Curl, sending web requests from the command line like magic messages.

So, have you ever wielded Curl before? If not, no worries at all, my friend!

It’s this clever little tool that lets you whisper directly to web servers. Pretty neat, right?

Think of it like sending secret scrolls through the interwebs, awaiting a wise reply!

To begin, you can type something like curl https://example.com. Voilà! The HTML of the page appears, like conjuring a spell!

Simple enough, huh? But oh, there’s a whole world of magic you can cast with Curl!

We’re just brushing the surface here, but trust me—it’s a hoot and a half!

If you get tangled up or need help, just give me a shout! I’m here to help you ace this curling spectacle.

So, are you ready to curl those web requests like a pro? Let’s see your magic unfold!

---

## Analysis

We are provided a terminal that provides a set of instructions to follow.

### Silver

Unlike the defined standards of a curling sheet, embedded devices often have web servers on non-standard ports. Use `curl` to retrieve the web page on host “curlingfun” port 8080.
```bash
curl curlingfun:8080
```

Embedded devices often use self-signed certificates, where your browser will not trust the certificate presented. Use `curl` to retrieve the TLS-protected web page at https://curlingfun:9090/.
```bash
curl -k https://curlingfun:9090
```

Working with APIs and embedded devices often requires making HTTP POST requests. Use `curl` to send a request to https://curlingfun:9090/ with the parameter “skip” set to the value “alabaster”, declaring Alabaster as the team captain.
```bash
curl -k https://curlingfun:9090/ -d 'skip=alabaster'
```

Working with APIs and embedded devices often requires maintaining session state by passing a cookie. Use `curl` to send a request to https://curlingfun:9090/ with a cookie called “end” with the value “3”, indicating we’re on the third end of the curling match.
```bash
curl -k https://curlingfun:9090/ -b 'end=3'
```

Working with APIs and embedded devices sometimes requires working with raw HTTP headers. Use `curl` to view the HTTP headers returned by a request to https://curlingfun:9090/.
```bash
curl -k https://curlingfun:9090/ -v
```

Working with APIs and embedded devices sometimes requires working with custom HTTP headers. Use `curl` to send a request to https://curlingfun:9090/ with an HTTP header called “Stone” and the value “Granite”.
```bash
curl -k https://curlingfun:9090/ -H "Stone: Granite"
```

`curl` will modify your URL unless you tell it not to. For example, use `curl` to retrieve the following URL containing special characters: https://curlingfun:9090/../../etc/hacks.
```bash
curl -k https://curlingfun:9090/../../etc/hacks --path-as-is
```

### Gold

Use `curl` to craft a request meeting these requirements:
- HTTP POST request to https://curlingfun:9090/
- Parameter "skip" set to "bow"
- Cookie "end" set to "10"
- Header "Hack" set to "12ft"

Lert's use `-d` to specify parameters, `-b` to set a cookie, and `-H` to set a header:
```bash
curl -k https://curlingfun:9090/ -d 'skip=bow' -b 'end=10' -H "Hack: 12ft"
```

Excellent!  Now, use `curl` to access this URL: https://curlingfun:9090/../../etc/button

Let's use `--path-as-is` to preserve directory traversal:
```bash
curl -k https://curlingfun:9090/../../etc/button --path-as-is
```

Great!  Finally, use `curl` to access the page that this URL redirects to: https://curlingfun:9090/GoodSportsmanship

Let's use `-I` or `-v` to get a redirection target:
```bash
curl -k -I https://curlingfun:9090/GoodSportsmanship
```
```
HTTP/1.1 301 Moved Permanently
Server: nginx/1.18.0 (Ubuntu)
Date: Wed, 13 Nov 2024 02:02:51 GMT
Content-Type: text/html
Content-Length: 178
Location: https://curlingfun:9090/SpiritOfCurling.php
Connection: keep-alive
```
```bash
curl -k https://curlingfun:9090/SpiritOfCurling.php
```

Excellent work, you have solved hard mode!  You may close this terminal once HHC grants your achievement.

---

## References

- [cURL techniques](../../../../../ctf-techniques/web/curl/README.md)

---

## Navigation

| |
|---:|
| [Frosty Keypad](../frosty-keypad/README.md) → |