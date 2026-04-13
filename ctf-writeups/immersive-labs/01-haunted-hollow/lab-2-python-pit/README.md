# Lab 2 - Python Pit

## Table of Contents
- [Lab 2 - Python Pit](#lab-2---python-pit)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Setup](#setup)
    - [Database Content](#database-content)
    - [Login Request During Application Start](#login-request-during-application-start)
    - [Login Request from From](#login-request-from-from)
    - [Signup Request During Application Start](#signup-request-during-application-start)
  - [Analysis](#analysis)
    - [User Accounts](#user-accounts)
    - [Initial Values](#initial-values)
    - [Application Flow](#application-flow)
  - [Solution](#solution)

## Overview

The goals of the lab include the following:
1. Make sure all the rates provided via the endpoints are validated against the valid range `(0,100]`.
2. Make sure that nobody can hijack the signup form to create an account with admin privileges.
3. Prevent anyone from getting access to an admin account.

## Setup

We are given the source code for the Python application running as a web app.

We can modify the source code to add debugging information, run some tests and extract information from the execution.

### Database Content
```log
INFO in auth: id=1, name=Bobby, username=bobby, email=bobby@hollow.local, admin=False
INFO in auth: id=2, name=Spooks, username=spooks, email=spooks@hollow.local, admin=False
INFO in auth: id=3, name=Admin, username=admin, email=admin@hollow.local, admin=True
INFO in auth: id=4, name=Pypit, username=pypit, email=pypit@hollow.local, admin=True
INFO in auth: id=5, name=YBTwiUXmfX, username=YBTwiUXmfX, email=YBTwiUXmfX@hollow.local, admin=False
INFO in auth: id=6, name=ngOODbAuYQ, username=ngOODbAuYQ, email=ngOODbAuYQ@hollow.local, admin=False
INFO in auth: id=7, name=facgTOrjgI, username=facgTOrjgI, email=facgTOrjgI@hollow.local, admin=False
INFO in auth: id=8, name=ofCBjbdlHm, username=ofCBjbdlHm, email=ofCBjbdlHm@hollow.local, admin=False
INFO in auth: id=9, name=fExbvKrbNb, username=fExbvKrbNb, email=fExbvKrbNb@hollow.local, admin=False
INFO in auth: id=10, name=ZWZpbVtqfl, username=ZWZpbVtqfl, email=ZWZpbVtqfl@hollow.local, admin=False
INFO in auth: id=11, name=plbbvslQkW, username=plbbvslQkW, email=plbbvslQkW@hollow.local, admin=False
INFO in auth: id=12, name=oEzIntELGc, username=oEzIntELGc, email=oEzIntELGc@hollow.local, admin=False
INFO in auth: id=13, name=vBkQIteiFG, username=vBkQIteiFG, email=vBkQIteiFG@hollow.local, admin=False
INFO in auth: id=14, name=pBwQYLRXZu, username=pBwQYLRXZu, email=pBwQYLRXZu@hollow.local, admin=False
INFO in auth: id=15, name=wylFADowMy, username=wylFADowMy, email=wylFADowMy@hollow.local, admin=False
INFO in auth: id=16, name=fmlCgAXNrg, username=fmlCgAXNrg, email=fmlCgAXNrg@hollow.local, admin=False
INFO in auth: id=17, name=GZyoqBWTxL, username=GZyoqBWTxL, email=GZyoqBWTxL@hollow.local, admin=False
INFO in auth: id=18, name=pGOWmmSPzj, username=pGOWmmSPzj, email=pGOWmmSPzj@hollow.local, admin=False
INFO in auth: id=19, name=jmLqzDyAEn, username=jmLqzDyAEn, email=jmLqzDyAEn@hollow.local, admin=False
INFO in auth: id=20, name=eAaNlsfEjH, username=eAaNlsfEjH, email=eAaNlsfEjH@hollow.local, admin=False
INFO in auth: id=21, name=vpruxUzrYV, username=vpruxUzrYV, email=vpruxUzrYV@hollow.local, admin=False
INFO in auth: id=22, name=XyAjbrnuaC, username=XyAjbrnuaC, email=XyAjbrnuaC@hollow.local, admin=False
INFO in auth: id=23, name=ywIARVCUhs, username=ywIARVCUhs, email=ywIARVCUhs@hollow.local, admin=False
INFO in auth: id=24, name=jKOHsdkZLz, username=jKOHsdkZLz, email=jKOHsdkZLz@hollow.local, admin=False
INFO in auth: id=25, name=wTZHfpDdtP, username=wTZHfpDdtP, email=wTZHfpDdtP@hollow.local, admin=False
INFO in auth: id=26, name=CmPEpDGDSX, username=CmPEpDGDSX, email=CmPEpDGDSX@hollow.local, admin=False
INFO in auth: id=27, name=uRgrCoRAvQ, username=uRgrCoRAvQ, email=uRgrCoRAvQ@hollow.local, admin=False
```

### Login Request During Application Start
```log
INFO in auth: LOGIN REQUEST: <Request 'http://127.0.0.1/webapp/auth/login' [POST]>
    -> form data=ImmutableMultiDict([('email', 'admin@hollow.local'), ('password', 'leaf-sky-kid2')])
    -> received from IP: 127.0.0.1, User-Agent: python-requests/2.31.0
    -> headers: Host: 127.0.0.1\r
Sentry-Trace: e4a29da4386649eda205b848730327a2-ae11379eb76b8665\r
Baggage: sentry-trace_id=e4a29da4386649eda205b848730327a2,sentry-environment=production,sentry-release=1.32.3,sentry-public_key=8b4d4c1ff6a24c55b84f9bd36d0ed263\r
User-Agent: python-requests/2.31.0\r
Accept-Encoding: gzip, deflate\r
Accept: */*\r
Connection: keep-alive\r
Content-Length: 49\r
Content-Type: application/x-www-form-urlencoded\r
X-Forwarded-Prefix: /\r
\r
INFO in auth: Found user: name=Admin, username=admin, email=admin@hollow.local, admin=True
```

### Login Request from From
```log
INFO in auth: LOGIN REQUEST: <Request 'https://8428325.proxy-http.immersivelabs.online/webapp/auth/login' [GET]>
    -> form data=ImmutableMultiDict([])
    -> received from IP: 10.102.87.162, User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36
    -> headers: Cache-Control: no-cache\r
Host: 8428325.proxy-http.immersivelabs.online\r
X-Forwarded-For: 108.237.193.22, 10.102.78.150\r
X-Forwarded-Proto: https\r
X-Forwarded-Ssl: on\r
X-Real-Ip: 10.102.78.150\r
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36\r
Via: 3.0 0f807046e71299e5fc76e205c26dc9cc.cloudfront.net (CloudFront)\r
X-Amz-Cf-Id: KJYNTRKL76Lrqbc5CW95vIq7aA9N0MKmhtHS4bszgjuphVm_3xDwhw==\r
Accept-Language: en-US,en;q=0.9\r
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r
Cookie: jwt=eyJhbGciOiJIUzI1NiJ9.eyJpcCI6IjEwLjEwMi43OC4yMTEiLCJwb3J0Ijo4MH0.ZlQV8-PvbW6vRF7YBlaOob3cxFyxn_hP97cLAupHkag\r
Sec-Ch-Ua: "Google Chrome";v="129", "Not=A?Brand";v="8", "Chromium";v="129"\r
Sec-Ch-Ua-Mobile: ?0\r
Sec-Ch-Ua-Platform: "macOS"\r
Upgrade-Insecure-Requests: 1\r
Sec-Fetch-Site: same-site\r
Sec-Fetch-Mode: navigate\r
Sec-Fetch-User: ?1\r
Sec-Fetch-Dest: iframe\r
Accept-Encoding: gzip, deflate, br, zstd\r
Dnt: 1\r
Priority: u=0, i\r
Cloudfront-Is-Mobile-Viewer: false\r
Cloudfront-Is-Tablet-Viewer: false\r
Cloudfront-Is-Smarttv-Viewer: false\r
Cloudfront-Is-Desktop-Viewer: true\r
Cloudfront-Is-Ios-Viewer: false\r
Cloudfront-Is-Android-Viewer: false\r
Cloudfront-Viewer-Http-Version: 3.0\r
Cloudfront-Viewer-Country: US\r
Cloudfront-Viewer-Country-Name: United States\r
Cloudfront-Viewer-Country-Region: WI\r
Cloudfront-Viewer-Country-Region-Name: Wisconsin\r
Cloudfront-Viewer-City: Hartland\r
Cloudfront-Viewer-Postal-Code: 53029\r
Cloudfront-Viewer-Time-Zone: America/Chicago\r
Cloudfront-Viewer-Metro-Code: 617\r
Cloudfront-Viewer-Latitude: 43.12680\r
Cloudfront-Viewer-Longitude: -88.35750\r
Cloudfront-Forwarded-Proto: https\r
Cloudfront-Viewer-Address: 108.237.193.22:57502\r
Cloudfront-Viewer-Tls: TLSv1.3:TLS_AES_128_GCM_SHA256:connectionReused\r
Cloudfront-Viewer-Asn: 7018\r
X-Origin-Secret: 9fdf125c3d2c8335b7a1e356e3d1b0df\r
X-Request-Id: 698651bb-c328-94a8-a716-a2525339b566\r
X-Envoy-Expected-Rq-Timeout-Ms: 60000\r
X-Envoy-Original-Path: /webapp/auth/login\r
X-Datadog-Trace-Id: 2153668457681162753\r
X-Datadog-Parent-Id: 8433042447919870081\r
X-Datadog-Sampling-Priority: 1\r
X-Forwarded-Prefix: /\r
\r
```

### Signup Request During Application Start
```log
INFO in auth: SIGNUP REQUEST: <Request 'http://127.0.0.1/webapp/auth/signup' [POST]>
    -> form data=ImmutableMultiDict([('name', 'uRgrCoRAvQ'), ('username', 'uRgrCoRAvQ'), ('email', 'uRgrCoRAvQ@hollow.local'), ('password', 'leaf-sky-kid2'), ('admin', '0')])
    -> received from IP: 127.0.0.1, User-Agent: python-requests/2.31.0
    -> headers: Host: 127.0.0.1\r
Sentry-Trace: e4a29da4386649eda205b848730327a2-ae11379eb76b8665\r
Baggage: sentry-trace_id=e4a29da4386649eda205b848730327a2,sentry-environment=production,sentry-release=1.32.3,sentry-public_key=8b4d4c1ff6a24c55b84f9bd36d0ed263\r
User-Agent: python-requests/2.31.0\r
Accept-Encoding: gzip, deflate\r
Accept: */*\r
Connection: keep-alive\r
Content-Length: 98\r
Content-Type: application/x-www-form-urlencoded\r
X-Forwarded-Prefix: /\r
\r
INFO in auth: Creating user: name=uRgrCoRAvQ, username=uRgrCoRAvQ, email=uRgrCoRAvQ@hollow.local, password=leaf-sky-kid2, admin=0
```

## Analysis

### User Accounts
* By default, the database includes a few users with two of them having `admin` turned ON.
  ```log
  INFO in auth: id=1, name=Bobby, username=bobby, email=bobby@hollow.local, admin=False
  INFO in auth: id=2, name=Spooks, username=spooks, email=spooks@hollow.local, admin=False
  INFO in auth: id=3, name=Admin, username=admin, email=admin@hollow.local, admin=True
  INFO in auth: id=4, name=Pypit, username=pypit, email=pypit@hollow.local, admin=True
  ```
* The `Bobby` user is the one provided in the lab to use for testing.
* The `PyPit` user looks suspicious.

### Initial Values
* Two of the rate values are already out of range when the application starts:
  ```log
  INFO in dashboard: Loading dashboard obstacle smoke with rate 100
  INFO in dashboard: Loading dashboard obstacle rumble with rate 450   <--
  INFO in dashboard: Loading dashboard obstacle pythons with rate 100
  INFO in dashboard: Loading dashboard obstacle pegs with rate 200     <--
  ```

### Application Flow
* When the application starts after each deployment, there is an automated setup sequence executed:
1. Create a random user in the database:
   ```log
   INFO in auth: Creating new user: name=lRwxUwQYvF, username=lRwxUwQYvF, admin=0, email=lRwxUwQYvF@hollow.local, password=leaf-sky-kid2
   ```
2. Log into the **Admin** account and set the Python and Smoke rates to 100.
   ```log
   INFO in auth: /auth/login: <Request 'http://127.0.0.1/webapp/auth/login' [GET]> python-requests/2.31.0
   INFO in auth: /auth/login: <Request 'http://127.0.0.1/webapp/auth/login' [POST]> python-requests/2.31.0
   INFO in auth: Login email=admin@hollow.local, password=leaf-sky-kid2
   INFO in auth: Login failed
   INFO in auth: /auth/login: <Request 'http://127.0.0.1/webapp/auth/login' [GET]> python-requests/2.31.0
   INFO in auth: /auth/signup: <Request 'http://127.0.0.1/webapp/auth/signup' [POST]> python-requests/2.31.0
   INFO in auth: Creating new user: name=lRwxUwQYvF, username=lRwxUwQYvF, admin=0, email=lRwxUwQYvF@hollow.local, password=leaf-sky-kid2
   INFO in dashboard: /dashboard: <Request 'http://127.0.0.1/webapp/dashboard' [GET]>, User-Agent: python-requests/2.31.0
   INFO in dashboard: Loading dashboard obstacle smoke with rate 100
   INFO in dashboard: Loading dashboard obstacle rumble with rate 450
   INFO in dashboard: Loading dashboard obstacle pythons with rate 100
   INFO in dashboard: Loading dashboard obstacle pegs with rate 200
   INFO in auth: /auth/login: <Request 'http://127.0.0.1/webapp/auth/login' [POST]> python-requests/2.31.0
   INFO in auth: Login email=admin@hollow.local, password=leaf-sky-kid2
   INFO in auth: Login failed
   INFO in dashboard: /dashboard/rate/python: <Request 'http://127.0.0.1/webapp/dashboard/rate/python' [POST]>, User-Agent: python-requests/2.31.0
   INFO in dashboard: Updating Pythons rate to 100
   INFO in auth: /auth/login: <Request 'http://127.0.0.1/webapp/auth/login' [POST]> python-requests/2.31.0
   INFO in auth: Login email=admin@hollow.local, password=leaf-sky-kid2
   INFO in auth: Login failed
   INFO in dashboard: /dashboard/rate/smoke: <Request 'http://127.0.0.1/webapp/dashboard/rate/smoke' [POST]>, User-Agent: python-requests/2.31.0
   INFO in dashboard: Updating Smoke rate to 100
   ```

## Solution
To achieve the lab goals, the following changes need to be completed:
1. The code in `dashboard.py` contains the logic to check for the rate values, but they are inconsistent:
   - Check is available in the `/dashboard/rate/rumble` and `/dashboard/rate/pegs` endpoints.
   - Check is missing from the `/dashboard/rate/python` endpoint.
   - Check in the `/dashboard/rate/smoke` endpoint is only checking for values > 100, but not those < 0.
   - Need to updated the code to have a consistent range check for the input `rate` across all the endpoints.
     ```python
      rate = request.form["rate"]
      if int(rate) > 100 or int(rate) < 0:
          flash("Rate must be between 0 and 100")
          return redirect(url_for("dashboard.feed"))
     ```

2. The `signup.html` file includes a hidden field for `admin` defaulted to 0. However, in the `auth.py` file,
   there is no check to confirm that the value can be manipulated to 1 with a man-in-the-middle attack.
   - Need to change the login in the `/auth/signup` endpoint to set `admin = 0` and ignore the `request.form["admin"]` value.

3. The `login.html` file has a comment with credentials to a `PyPit` account.
   ```html
   <!-- New operators: log in with pypit/breakup-cloud-crates4 until you've been assigned your own account. -->
   ```
   - After further investigating the content of the database, it turns out that this is an admin account
   - Remove this comment from the file.

4. The `dashboard.html` file has a comment with the code needed for later.
   ```html
   <!-- If you want to shut this pit down for good and get out of this place, you'll need this code - OuroborosAreWheels -->
   ```
