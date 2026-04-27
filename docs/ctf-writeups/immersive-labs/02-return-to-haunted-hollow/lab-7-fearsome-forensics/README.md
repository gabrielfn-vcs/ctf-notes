# Lab 7 - Fearsome Forensics

## Table of Contents
- [Lab 7 - Fearsome Forensics](#lab-7---fearsome-forensics)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Steganography](#steganography)
  - [Analysis](#analysis)
    - [Port information about the Haunted Hollow Website](#port-information-about-the-haunted-hollow-website)
    - [Decode File 1](#decode-file-1)
    - [Decode File 2](#decode-file-2)
    - [Decode File 3](#decode-file-3)
    - [Play Details](#play-details)
  - [Solution](#solution)
  - [Navigation](#navigation)

---

## Overview

Welcome to the Haunted Hollow, I hope you've come to help. I cannot tell you too much on here, it will see. My website will give you everything you need.

The key holds the final clue to unlocking itself. But first you need the files to help.

Any passphrases required are lowercase, except for the last which is a direct quote.

---

## Steganography

Steganography is the art of concealing messages or information within other, non-secret files (images, audio, video) to avoid detection

In this lab, the `key.jpeg` file contains a hidden message we need to extract.

Let's check the metadata first.

```bash
$ exiftool key.jpeg 
```
```
ExifTool Version Number         : 12.76
File Name                       : key.jpeg
Directory                       : .
File Size                       : 191 kB
File Modification Date/Time     : 2024:10:19 22:37:57+00:00
File Access Date/Time           : 2024:10:19 22:38:21+00:00
File Inode Change Date/Time     : 2024:10:19 22:37:57+00:00
File Permissions                : -rw-r--r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.01
Resolution Unit                 : inches
X Resolution                    : 96
Y Resolution                    : 96
Comment                         : My favourite play is what you need, folger.edu is the best place to read.
Image Width                     : 1024
Image Height                    : 1024
Encoding Process                : Baseline DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 1024x1024
Megapixels                      : 1.0
```
There is information in the `Comment` field. Other images may provide additional clues.

---

## Analysis

### Port information about the Haunted Hollow Website
```bash
$ nmap -sC -sV -oA default 10.102.22.88
```
```
Starting Nmap 7.93 ( https://nmap.org ) at 2024-10-19 22:45 UTC
Nmap scan report for ip-10-102-22-88.eu-west-1.compute.internal (10.102.22.88)
Host is up (0.00015s latency).
Not shown: 999 closed tcp ports (conn-refused)
PORT     STATE SERVICE VERSION
3000/tcp open  ppp?
| fingerprint-strings:
|   GetRequest:
|     HTTP/1.1 200 OK
|     X-Powered-By: Next.js
|     ETag: "1857cz1hyq72pe"
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 3506
|     Vary: Accept-Encoding
|     Date: Sat, 19 Oct 2024 22:45:44 GMT
|     Connection: close
|     <!DOCTYPE html><html><head><meta charSet="utf-8"/><meta name="viewport" content="width=device-width"/><meta name="next-head-count" content="2"/><link data-next-font="" rel="preconnect" href="/" crossorigin="anonymous"/><link rel="preload" href="/_next/static/css/97802fb49a606e46.css" as="style"/><link rel="stylesheet" href="/_next/static/css/97802fb49a606e46.css" data-n-p=""/><noscript data-n-css=""></noscript><script defer="" nomodule="" src="/_next/static/chunks/polyfills-78c92fac7aa8fdd8.js"></script><script src="/_next/static/chunks/webpack-35b92941fc8726f9.js" defer=""></script><script src="/_next/static/chunks/framework-4be839806aa8e2d3.js" defer=""></script><script src="/_next/
|   HTTPOptions:
|     HTTP/1.1 405 Method Not Allowed
|     Allow: GET
|     Allow: HEAD
|     Cache-Control: no-cache, no-store, max-age=0, must-revalidate
|     X-Powered-By: Next.js
|     ETag: "eg6yzqtej91lo"
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 2076
|     Vary: Accept-Encoding
|     Date: Sat, 19 Oct 2024 22:45:44 GMT
|     Connection: close
|     <!DOCTYPE html><html><head><meta charSet="utf-8"/><meta name="viewport" content="width=device-width"/><title>405: Method Not Allowed</title><meta name="next-head-count" content="3"/><link data-next-font="" rel="preconnect" href="/" crossorigin="anonymous"/><noscript data-n-css=""></noscript><script defer="" nomodule="" src="/_next/static/chunks/polyfills-78c92fac7aa8fdd8.js"></script><script src="/_next/static/chunks/webpack-35b92941fc8726f9.js" defer=""></script><script src="/_next/static/chunks/framework-4be839806aa8e2d3.js" defer=""></script><script src="/_next/static/chunks/main-
|   Help, NCP:
|     HTTP/1.1 400 Bad Request
|_    Connection: close
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port3000-TCP:V=7.93%I=7%D=10/19%Time=67143698%P=x86_64-pc-linux-gnu%r(G
SF:etRequest,E81,"HTTP/1\.1\x20200\x20OK\r\nX-Powered-By:\x20Next\.js\r\nE
SF:Tag:\x20\"1857cz1hyq72pe\"\r\nContent-Type:\x20text/html;\x20charset=ut
SF:f-8\r\nContent-Length:\x203506\r\nVary:\x20Accept-Encoding\r\nDate:\x20
SF:Sat,\x2019\x20Oct\x202024\x2022:45:44\x20GMT\r\nConnection:\x20close\r\
SF:n\r\n<!DOCTYPE\x20html><html><head><meta\x20charSet=\"utf-8\"/><meta\x2
SF:0name=\"viewport\"\x20content=\"width=device-width\"/><meta\x20name=\"n
SF:ext-head-count\"\x20content=\"2\"/><link\x20data-next-font=\"\"\x20rel=
SF:\"preconnect\"\x20href=\"/\"\x20crossorigin=\"anonymous\"/><link\x20rel
SF:=\"preload\"\x20href=\"/_next/static/css/97802fb49a606e46\.css\"\x20as=
SF:\"style\"/><link\x20rel=\"stylesheet\"\x20href=\"/_next/static/css/9780
SF:2fb49a606e46\.css\"\x20data-n-p=\"\"/><noscript\x20data-n-css=\"\"></no
SF:script><script\x20defer=\"\"\x20nomodule=\"\"\x20src=\"/_next/static/ch
SF:unks/polyfills-78c92fac7aa8fdd8\.js\"></script><script\x20src=\"/_next/
SF:static/chunks/webpack-35b92941fc8726f9\.js\"\x20defer=\"\"></script><sc
SF:ript\x20src=\"/_next/static/chunks/framework-4be839806aa8e2d3\.js\"\x20
SF:defer=\"\"></script><script\x20src=\"/_next/")%r(Help,2F,"HTTP/1\.1\x20
SF:400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r\n")%r(NCP,2F,"HTTP/
SF:1\.1\x20400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r\n")%r(HTTPO
SF:ptions,952,"HTTP/1\.1\x20405\x20Method\x20Not\x20Allowed\r\nAllow:\x20G
SF:ET\r\nAllow:\x20HEAD\r\nCache-Control:\x20no-cache,\x20no-store,\x20max
SF:-age=0,\x20must-revalidate\r\nX-Powered-By:\x20Next\.js\r\nETag:\x20\"e
SF:g6yzqtej91lo\"\r\nContent-Type:\x20text/html;\x20charset=utf-8\r\nConte
SF:nt-Length:\x202076\r\nVary:\x20Accept-Encoding\r\nDate:\x20Sat,\x2019\x
SF:20Oct\x202024\x2022:45:44\x20GMT\r\nConnection:\x20close\r\n\r\n<!DOCTY
SF:PE\x20html><html><head><meta\x20charSet=\"utf-8\"/><meta\x20name=\"view
SF:port\"\x20content=\"width=device-width\"/><title>405:\x20Method\x20Not\
SF:x20Allowed</title><meta\x20name=\"next-head-count\"\x20content=\"3\"/><
SF:link\x20data-next-font=\"\"\x20rel=\"preconnect\"\x20href=\"/\"\x20cros
SF:sorigin=\"anonymous\"/><noscript\x20data-n-css=\"\"></noscript><script\
SF:x20defer=\"\"\x20nomodule=\"\"\x20src=\"/_next/static/chunks/polyfills-
SF:78c92fac7aa8fdd8\.js\"></script><script\x20src=\"/_next/static/chunks/w
SF:ebpack-35b92941fc8726f9\.js\"\x20defer=\"\"></script><script\x20src=\"/
SF:_next/static/chunks/framework-4be839806aa8e2d3\.js\"\x20defer=\"\"></sc
SF:ript><script\x20src=\"/_next/static/chunks/main-");

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 11.61 seconds
```

----------------------------------------------

### Decode File 1

From the image metadata:
```bash
$ exiftool gallery1.jpeg
```
```
...
Comment: The password to file 1 is my favorite album
...
```

From the blogs:
```
By the pricking of my thumbs, Something wicked this way comes.
Posted on March 14th, 2023

The creation process of FredAI is picking up the pace and its potential feels nothing short of magical. I am working night and day. I’ve been listening to the album ‘life on mars’ to stay awake.
```

Decode the file:
```bash
$ openssl enc -d -aes-256-cbc -in file1.enc -out file1 -k 'life on mars'
```
```
In order to find the phrase for the key, you need to search Act 4 not 3.
```

----------------------------------------------

### Decode File 2

From the image metadata:
```bash
$ exiftool gallery3.jpeg
```
```
...
Comment: For file 2 the fix is quick, just look at my profile pic.
...
```

From the fakebook profile picture: `mickey mouse`

Decode the file:
```bash
$ openssl enc -d -des3 -in file2.enc -k 'mickey mouse'
```
```
To find the phrase, this is your second clue. You should look for scene number 2.
```

----------------------------------------------

### Decode File 3
From the image metadata:
```bash
$ exiftool gallery5.jpeg
```
```
...
Comment: For file 3 you need to see the country where I love to ski.
...
```

From the fakebook posts: `austria`

Check the file content:
```bash
$ cat file3.enc
```
```
Fcftcty tbw pywle jzkrae yim flat umw, ezve fcnx za whul rfc neyv mf khoikx.
```

Vigenère Decode (key 'austria'):
```
Finally the whole phrase you must use, line five is what you need to choose.
```

----------------------------------------------

### Play Details

The blog posts reference Macbeth by William Shakespeare. Here are the key clues that connect them to this play:

"By the pricking of my thumbs, Something wicked this way comes."

- This line is from Act 4, Scene 1 of Macbeth. It is spoken by one of the witches as they sense the arrival of Macbeth, highlighting his transformation into a wicked figure.

"I Bear a Charmed Life"

- This is a reference to Act 5, Scene 8, where Macbeth tells his opponent, Macduff, that he "bears a charmed life," believing he is invincible due to the witches' prophecy.

"Look like the innocent flower, But be the serpent under it."

- This line comes from Act 1, Scene 5, where Lady Macbeth advises Macbeth to appear harmless while hiding his deadly intentions, embodying the themes of deception and ambition central to the play.

"What’s done cannot be undone."

- This line is from Act 5, Scene 1, where Lady Macbeth, while sleepwalking, expresses her guilt over the murders committed, showing her descent into madness.

All the clues point to:

- Macbeth, Act 4, Scene 2, Line 5: Our fears do make us traitors.

---

## Solution

Let's extract the secret message from the image using a steganography tool:
```bash
$ steghide extract -sf key.jpeg -p "Our fears do make us traitors."
```
```
wrote extracted data to ".gkJarCdxhy1rM7ymo36yHzrJtax".
```

Let's check the content of the extracted data:
```bash
$ cat .gkJarCdxhy1rM7ymo36yHzrJtax 
```
```
Well done, you cracked the final round. Your token is:
4a7b60
```

---

## Navigation

| | |
|:---|---:|
| ← [Haunted Helpdesk](../lab-6-haunted-helpdesk/README.md) | [Spooky, Scary, Silly Snaps](../lab-8-spooky-scary-silly-snaps/README.md) → |
