# Banner Grabbing

## Table of Contents
- [Banner Grabbing](#banner-grabbing)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [HTTP Banner Note](#http-banner-note)
  - [Tools](#tools)
    - [Netcat](#netcat)
    - [Telnet](#telnet)
    - [Curl](#curl)
    - [Nmap](#nmap)
  - [Quick Reference](#quick-reference)
  - [References](#references)

---

## Overview

Service banners are messages automatically returned by a service upon connection, often containing the service name, version, and other identifying information.

Banner grabbing is the process of collecting these banners to identify what software is running on a host and whether known vulnerabilities exist for that version.

## HTTP Banner Note

Services will often respond automatically to new connections with the service banner. However, in the case of HTTP, servers are sometimes configured only to respond if a specific request is made.

When attempting to banner grab with an HTTP server, if a connection opens but returns nothing, you can type `HTTP/1.1 200` after opening the connection to make this request. Sometimes, it is necessary to hit enter a few times for the server to respond.

---

## Tools

Many tools can be used for banner grabbing. See the list below for more details.

### Netcat

Netcat is a standard networking utility tool available by default on most systems including Kali that interact with network connections using TCP and UDP. You can use it to open a connection to the remote services that respond with their banners.

```bash
# Grab the FTP banner
nc -v TARGET 21

# Grab the SSH banner
nc -v TARGET 22

# Grab the HTTP banner (type the request manually after connecting)
nc -v TARGET 80
# Then type: HTTP/1.1 200
# Press Enter a couple of times to prompt a response
```

### Telnet

Functionally equivalent to Netcat for banner grabbing, but not available by default on Kali or most modern OS installations. Use Netcat instead where possible.

```bash
# Grab the SSH banner
telnet TARGET 22

# Grab the FTP banner
telnet TARGET 21
```

### Curl

Curl is a tool for transferring data to and from network servers. It is best suited for HTTP/HTTPS banner grabbing.

The `-I` flag fetches headers of the requested page only without downloading the response body.

```bash
# Fetch all HTTP headers
curl -I TARGET
```

You can then use `grep` to find the service header or banner. Here's an example of a `curl` command that will grab the HTTP headers and a `grep` command that will grab the server banner:

```bash
# Filter for the server banner specifically
curl -I TARGET | grep -e "Server:"
```

### Nmap

Nmap has a script specifically for banner grabbing that connects to all open TCP ports for a specified target and prints out anything sent by the listening service within five seconds. It is useful for grabbing banners across multiple services in a single pass.

Nmap will return all of the headers for listening services with the following command:

```bash
# Grab banners from all open TCP ports
nmap -sV --script=banner TARGET
```

This command uses the `-p` flag for targeting specific ports, which is useful when you already know which services are open and want to avoid a full scan:

```bash
# Combine with a port range for a targeted scan
nmap -sV --script=banner -p 21,22,80,443 TARGET
```

---

## Quick Reference

| Tool | Best For | Command |
|---|---|---|
| Netcat | Any TCP service, default on Kali | `nc -v TARGET PORT` |
| Curl | HTTP/HTTPS headers | `curl -I TARGET` |
| Nmap | Multi-service banner sweep | `nmap -sV --script=banner TARGET` |
| Telnet | Legacy use only — prefer Netcat | `telnet TARGET PORT` |

---

## References

- [Nmap Banner Script](https://nmap.org/nsedoc/scripts/banner.html)
- [HackTricks - Banner Grabbing](https://angelica.gitbook.io/hacktricks/network-services-pentesting/pentesting-ftp#banner-grabbing)
- [Netcat man page](https://linux.die.net/man/1/nc)
