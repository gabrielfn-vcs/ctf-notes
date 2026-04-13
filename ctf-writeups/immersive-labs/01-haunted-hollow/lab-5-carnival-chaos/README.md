# Lab 5 - Carnival Chaos

## Table of Contents
- [Lab 5 - Carnival Chaos](#lab-5---carnival-chaos)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
  - [Solution](#solution)

## Overview

This lab provides a web application that needs to be exploited with a NoSQL attack to extract hidden information.

## Analysis

Using Burp Suite:
1. Go to **Proxy**.
2. Turn ON **Intercept**.
3. Start web site with the given IP address.
4. Enter anything in the username and password fields to capture the request.
5. Under **Actions** select **Send to Repeater**.
6. Set payload to this JSON:
   ```json
   {"username": {"$ne":""}, "password": {"$ne":""}}
   ```
7. Click "Send".
8. On the Response, confirm the successful request and grab the value for the `session` cookie.

In the web browser:
1. Start the **Developer Tools** on the browser with the website.
2. On the **Debug** side, check the code to confirm the page name with the desired information.  It is `/prizes`.
3. Go to **Application > Cookies** and **Add Item** with name `session` and value set to the one captured above.
4. Change the URL to be `<IP address>/prizes` to load the page with the information.
5. Scroll down to the entry with the skeleton key and extract the name.

## Solution
- What is the six character token at the end of the skeleton key prize name? `e28106`
- What is the name of the skeleton key? `sp00ky-Sk3L3T0N-k3y`
