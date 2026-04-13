# Lab 3 - Delving Deeper

## Table of Contents
- [Lab 3 - Delving Deeper](#lab-3---delving-deeper)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
    - [Web Application](#web-application)
    - [Terminal](#terminal)
    - [API](#api)
  - [Solution](#solution)

## Overview

This lab puts you in a room where you have to click around to find information. At some point you get access to a terminal with instructions to complete the challenge.

## Analysis

### Web Application
During the exploration, we get access to a JWT:
```
eyJhbGciOiJIUzI1NiJ9.eyJpcCI6IjEwLjEwMi44Ni4xMDkiLCJwb3J0Ijo4MH0.yvNfkPplS6vFDJSqdsNJHaRcfzDdLBk83C2OMPKkm_c
```

The Payload Data for this JWT is:
```json
{
  "ip": "10.102.86.109",
  "port": 80
}
```
This provides the details to run the web application.

### Terminal
Once the application is loaded, we can see a terminal with limited functionality.

After getting the [`main.bcde0d62.js`](./main.bcde0d62.js) file with the code from the browser Developer Tools, we can confirm all the supported terminal commands:
- `echo <string> <op> <filename>`
  - Supports `>` and `>>`
- `touch <filename>`
- `ls`
  - List files in the current directory
- `mkdir <directory>`
- `cat <filename>`
- `curl [flag] [params] [flag] [method] <url>`
  - Send a request to a server.
  - **HINT:** Try `curl -d "codeword=$$$" -X POST /$$$`

### API
There is a PostIt note in the room with:
```
  password: EbsEze10

  GET /API
````

At this point, we know that we can submit a PST request using the `curl` command syntax found above, but we need to find out the syntax of the payload.

Running the command `curl api` provides addtiional details about the expected syntax for the POST request payload:
```
API reference
/token METHOD=["POST"] PARAMS=["codeword"]
```

We now have everything we need to send the request.

## Solution

Let's send the API POST request with the given password and syntax to get the token:
```bash
$ curl -d "codeword=EbsEze10" -X POST /token METHOD=["POST"] PARAMS=["EbsEze10"]
```
```
The token is: 37dace
```
