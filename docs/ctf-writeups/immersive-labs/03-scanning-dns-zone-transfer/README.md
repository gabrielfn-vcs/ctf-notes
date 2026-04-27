# Scanning - DNS Zone Trasnfer

## Table of Contents
- [Scanning - DNS Zone Trasnfer](#scanning---dns-zone-trasnfer)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Flag format](#flag-format)
  - [Hints](#hints)
    - [Hint 1: DNS Server](#hint-1-dns-server)
    - [Hint 2: TCP Requests](#hint-2-tcp-requests)
  - [Constraints](#constraints)
  - [Analysis](#analysis)
    - [Step 1 — Identify the Attacker IP from the PCAP](#step-1--identify-the-attacker-ip-from-the-pcap)
      - [Interpreting the Output](#interpreting-the-output)
    - [Step 2 — Perform Reverse DNS Lookups Against the Challenge DNS Server](#step-2--perform-reverse-dns-lookups-against-the-challenge-dns-server)
      - [Testing `203.0.113.50` — REFUSED](#testing-203011350--refused)
      - [Testing `198.51.100.13` — NOERROR](#testing-1985110013--noerror)
    - [Step 3 — Enumerate the Subnet](#step-3--enumerate-the-subnet)
  - [Solution](#solution)
    - [Flag](#flag)
  - [Key Techniques](#key-techniques)
    - [`dig` Response Status Codes](#dig-response-status-codes)
    - [Reverse DNS Lookup (PTR Record)](#reverse-dns-lookup-ptr-record)
    - [Forcing TCP with `dig`](#forcing-tcp-with-dig)
    - [PCAP Analysis with `tshark`](#pcap-analysis-with-tshark)
  - [References](#references)

---

## Overview

**The Attacker Checks the Locks**
> A scan pushes against the defenses. It is brief, focused, patient.
> 
> Someone out there wants to know which doors remain unlocked.
> 
> Identify the network domain that is trying to push into the network by using the packet capture in this challenge.

--- 

## Flag format
Domain name (e.g., `google.com`)

---

## Hints

### Hint 1: DNS Server
You will need to use the DNS server at `0.cloud.chals.io` on port `31020` to solve the challenge.

### Hint 2: TCP Requests
The CTFd server only supports TCP requests so you will need to make sure any requests going to the DNS server use TCP. By default most DNS tools will default to UDP. You can use the container in the challenge to communicate with the DNS server.

---

## Constraints
- Server: `0.cloud.chals.io`
- Port: `31020`
- Protocol: TCP only (This is the "gotcha" because DNS tools default to UDP, so TCP must be forced explicitly)

---

## Analysis

The hints are very specific here. We are not looking for a domain name inside the packets; we are likely using the Attacker's IP to do a Reverse DNS Lookup (PTR record) using their specific DNS server.

### Step 1 — Identify the Attacker IP from the PCAP

To find the Attacker IP, need to check the provided packet capture (PCAP) file.

Since the challenge mentions the attacker is "scanning" and "checking the locks", we need to find the IP that is poking at the different ports:

* **Look for Scans:** Look for a high number of SYN packets or connection attempts to various ports from a single external IP.
* **Identify the "Attacker" IP:** Once you find the IP address that is "pushing against the defenses," make a note of it.

Let's use `tshark` to count packets by source IP and identify unusual traffic:
```bash
tshark -r FirewallPacketCapture.pcap -T fields -e ip.src | sort | uniq -c | sort -nr
```
```
47115 10.200.50.30
2757 13.33.88.64
2730 104.16.132.229
2677 142.250.185.46
2672 151.101.1.140
2626 172.217.14.206
2608 104.244.42.129
2551 31.13.71.36
2532 185.199.108.153
2532 13.107.42.16
2510 52.84.150.80
  40 203.0.113.50
   9 198.51.100.13
   7 198.51.100.19
   6 198.51.100.24
   5 198.51.100.22
   4 198.51.100.15
   3 198.51.100.20
   3 198.51.100.17
   2 198.51.100.23
   2 198.51.100.21
   2 198.51.100.12
   2 198.51.100.10
   1 198.51.100.18
   1 198.51.100.14
   1 198.51.100.11
```

#### Interpreting the Output
```
47115 10.200.50.30        ← internal host, ignore
 2757 13.33.88.64         ← CDN/infrastructure traffic (Cloudflare, AWS, Google)
 2730 104.16.132.229
  ...
   40 203.0.113.50        ← focused scan: low count, external IP
    9 198.51.100.13       ← suspicious cluster
    7 198.51.100.19
    6 198.51.100.24
    ...
```

The high-count IPs are standard CDN traffic. Two groups stand out:

- The first block of IPs (with counts in the thousands) looks like standard CDN or Infrastructure traffic (Google, Cloudflare, AWS).
- However, the IP 203.0.113.50 and the cluster of 198.51.100.x IPs are very suspicious.

The description mentioned the scan was "brief, focused, and patient."

- **`203.0.113.50`** — 40 packets, external IP, matches "brief and focused".
- **`198.51.100.0/24` range** — multiple IPs each with low counts, matching "patient", a classic low-and-slow scan spread across a subnet to evade threshold-based alerts.

> [!NOTE]
> `198.51.100.0/24` is TEST-NET-2 (RFC 5737), reserved for documentation and frequently used in CTFs to represent attacker-controlled external IP ranges.

In network security, an attacker often uses one primary IP to conduct the heavy scanning. Let's start with the most active "unusual" IP: `203.0.113.50`.

Alternatively, use Wireshark to visualize the scan:

1. Go to Statistics > Conversations > TCP.
2. Sort by Packets. Look for an external IP address that has sent many packets but received very few (or mostly RST/ACK packets) from your internal IPs.
3. Or use a filter for SYN-only packets (connection attempts without handshake completion): `tcp.flags.syn == 1 && tcp.flags.ack == 0`. This will show you the connection attempts.

---

### Step 2 — Perform Reverse DNS Lookups Against the Challenge DNS Server

The `dig` tool is the best for this. Use the `+tcp` flag to force TCP (Hint 2) and the -p flag for the non-standard port.

For example,
```bash
dig @0.cloud.chals.io -p 31020 -x ATTACKER_IP +tcp
```

#### Testing `203.0.113.50` — REFUSED
```bash
$ dig @0.cloud.chals.io -p 31020 -x 203.0.113.50 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 203.0.113.50 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 11956
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 5b69818dea616dc00100000069a069b1042afd86139b6835 (good)
;; QUESTION SECTION:
;50.113.0.203.in-addr.arpa.	IN	PTR

;; Query time: 40 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:41:37 UTC 2026
;; MSG SIZE  rcvd: 82
```

`status: REFUSED` means the DNS server is alive but does not hold a record for this IP. Either the wrong IP, or the server only handles a specific subnet.

Looking at the tshark output, there is a "patient" cluster of IPs in the `198.51.100.x` range. In many CTF network captures, an attacker uses a block of IP addresses to perform "low and slow" scanning to avoid triggering basic threshold-based alerts (like an alarm that goes off after 100 packets from a single IP).

Since the single scan IP didn't work, we should try to resolve the subnet and check the remaining 198.51.100.x IP addresses.

#### Testing `198.51.100.13` — NOERROR
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.13 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.13 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39851
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 46d5955bd8a438890100000069a06a3a17ba6cb7b4e0bd41 (good)
;; QUESTION SECTION:
;13.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
13.100.51.198.in-addr.arpa. 86400 IN	PTR	scan04.slugworth-industries.net.

;; Query time: 24 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:43:54 UTC 2026
;; MSG SIZE  rcvd: 128
```

A valid PTR record is returned. The `198.51.100.0/24` subnet belongs to the challenge DNS server.

---

### Step 3 — Enumerate the Subnet
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.19 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.19 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60802
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 81add125587080af0100000069a06ae6440eef6862f3dcad (good)
;; QUESTION SECTION:
;19.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
19.100.51.198.in-addr.arpa. 86400 IN	PTR	scan10.slugworth-industries.net.

;; Query time: 36 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:46:46 UTC 2026
;; MSG SIZE  rcvd: 128
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.24 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.24 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 26772
;; flags: qr aa rd; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: abc7bf9aff1a6fda0100000069a06aee05bb52a3a7472c53 (good)
;; QUESTION SECTION:
;24.100.51.198.in-addr.arpa.	IN	PTR

;; AUTHORITY SECTION:
100.51.198.in-addr.arpa. 86400	IN	SOA	ns1.slugworth-industries.net. admin.slugworth-industries.net. 2026021901 3600 1800 604800 86400

;; Query time: 20 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:46:54 UTC 2026
;; MSG SIZE  rcvd: 153
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.22 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.22 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 31209
;; flags: qr aa rd; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: a949b1067cc95b370100000069a06af6bf7205bae719dada (good)
;; QUESTION SECTION:
;22.100.51.198.in-addr.arpa.	IN	PTR

;; AUTHORITY SECTION:
100.51.198.in-addr.arpa. 86400	IN	SOA	ns1.slugworth-industries.net. admin.slugworth-industries.net. 2026021901 3600 1800 604800 86400

;; Query time: 16 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:02 UTC 2026
;; MSG SIZE  rcvd: 153
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.15 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.15 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21312
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: ca346e5506b9c4f70100000069a06afc9e93c2b75537fbad (good)
;; QUESTION SECTION:
;15.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
15.100.51.198.in-addr.arpa. 86400 IN	PTR	scan06.slugworth-industries.net.

;; Query time: 12 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:08 UTC 2026
;; MSG SIZE  rcvd: 128
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.20 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.20 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23075
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: f6d54948a4016d610100000069a06b0444a4991880e48eec (good)
;; QUESTION SECTION:
;20.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
20.100.51.198.in-addr.arpa. 86400 IN	PTR	www.slugworth-industries.net.

;; Query time: 12 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:16 UTC 2026
;; MSG SIZE  rcvd: 125
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.17 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.17 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53274
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 0b5f57004bdb62a00100000069a06b0ad7fe164ce464b40c (good)
;; QUESTION SECTION:
;17.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
17.100.51.198.in-addr.arpa. 86400 IN	PTR	scan08.slugworth-industries.net.

;; Query time: 24 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:22 UTC 2026
;; MSG SIZE  rcvd: 128
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.23 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.23 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 30855
;; flags: qr aa rd; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: ecef9650bec49e150100000069a06b0f75b95e3c0c7c285c (good)
;; QUESTION SECTION:
;23.100.51.198.in-addr.arpa.	IN	PTR

;; AUTHORITY SECTION:
100.51.198.in-addr.arpa. 86400	IN	SOA	ns1.slugworth-industries.net. admin.slugworth-industries.net. 2026021901 3600 1800 604800 86400

;; Query time: 24 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:27 UTC 2026
;; MSG SIZE  rcvd: 153
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.21 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.21 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42402
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 016977d09e95449a0100000069a06b15b3ff7aca1afd754d (good)
;; QUESTION SECTION:
;21.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
21.100.51.198.in-addr.arpa. 86400 IN	PTR	mail.slugworth-industries.net.

;; Query time: 12 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:33 UTC 2026
;; MSG SIZE  rcvd: 126
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.12 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.12 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55691
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 189ac9d74f3d92380100000069a06b25971ef6aa898ae860 (good)
;; QUESTION SECTION:
;12.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
12.100.51.198.in-addr.arpa. 86400 IN	PTR	scan03.slugworth-industries.net.

;; Query time: 32 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:49 UTC 2026
;; MSG SIZE  rcvd: 128
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.10 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.10 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13820
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: e3b6784af79bfa7c0100000069a06b293558f883b2b51f16 (good)
;; QUESTION SECTION:
;10.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
10.100.51.198.in-addr.arpa. 86400 IN	PTR	scan01.slugworth-industries.net.

;; Query time: 48 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:53 UTC 2026
;; MSG SIZE  rcvd: 128
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.18 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.18 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28288
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 70c861a5f577c0200100000069a06b2f6b115c69edbf1e98 (good)
;; QUESTION SECTION:
;18.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
18.100.51.198.in-addr.arpa. 86400 IN	PTR	scan09.slugworth-industries.net.

;; Query time: 12 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:47:59 UTC 2026
;; MSG SIZE  rcvd: 128
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.14 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.14 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3433
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: e3405d774cdcbf1b0100000069a06b33c20b96edb317fd22 (good)
;; QUESTION SECTION:
;14.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
14.100.51.198.in-addr.arpa. 86400 IN	PTR	scan05.slugworth-industries.net.

;; Query time: 16 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:48:03 UTC 2026
;; MSG SIZE  rcvd: 128
```
```bash
$ dig @0.cloud.chals.io -p 31020 -x 198.51.100.11 +tcp
```
```
; <<>> DiG 9.20.18 <<>> @0.cloud.chals.io -p 31020 -x 198.51.100.11 +tcp
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31314
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: f972015d017223b70100000069a06b38c323d28ec0bc1e5f (good)
;; QUESTION SECTION:
;11.100.51.198.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
11.100.51.198.in-addr.arpa. 86400 IN	PTR	scan02.slugworth-industries.net.

;; Query time: 12 msec
;; SERVER: 165.227.210.30#31020(0.cloud.chals.io) (TCP)
;; WHEN: Thu Feb 26 15:48:08 UTC 2026
;; MSG SIZE  rcvd: 128
```

The ANSWER SECTION shows the following names:
```
10.100.51.198.in-addr.arpa. 86400 IN    PTR     scan01.slugworth-industries.net.
11.100.51.198.in-addr.arpa. 86400 IN    PTR     scan02.slugworth-industries.net.                                             
12.100.51.198.in-addr.arpa. 86400 IN    PTR     scan03.slugworth-industries.net.                                             
13.100.51.198.in-addr.arpa. 86400 IN    PTR     scan04.slugworth-industries.net.                                             
14.100.51.198.in-addr.arpa. 86400 IN    PTR     scan05.slugworth-industries.net.
15.100.51.198.in-addr.arpa. 86400 IN    PTR     scan06.slugworth-industries.net.
17.100.51.198.in-addr.arpa. 86400 IN    PTR     scan08.slugworth-industries.net.
18.100.51.198.in-addr.arpa. 86400 IN    PTR     scan09.slugworth-industries.net.
19.100.51.198.in-addr.arpa. 86400 IN    PTR     scan10.slugworth-industries.net.
20.100.51.198.in-addr.arpa. 86400 IN    PTR     www.slugworth-industries.net.   
21.100.51.198.in-addr.arpa. 86400 IN    PTR     mail.slugworth-industries.net.  
100.51.198.in-addr.arpa. 86400	IN	SOA	ns1.slugworth-industries.net. admin.slugworth-industries.net. 2026021901 3600 1800 604800 86400
100.51.198.in-addr.arpa. 86400	IN	SOA	ns1.slugworth-industries.net. admin.slugworth-industries.net. 2026021901 3600 1800 604800 86400
100.51.198.in-addr.arpa. 86400	IN	SOA	ns1.slugworth-industries.net. admin.slugworth-industries.net. 2026021901 3600 1800 604800 86400
```

---

## Solution

Resolve all `198.51.100.x` IPs seen in the PCAP:

| IP | PTR Record |
|---|---|
| `198.51.100.10` | `scan01.slugworth-industries.net` |
| `198.51.100.11` | `scan02.slugworth-industries.net` |
| `198.51.100.12` | `scan03.slugworth-industries.net` |
| `198.51.100.13` | `scan04.slugworth-industries.net` |
| `198.51.100.14` | `scan05.slugworth-industries.net` |
| `198.51.100.15` | `scan06.slugworth-industries.net` |
| `198.51.100.17` | `scan08.slugworth-industries.net` |
| `198.51.100.18` | `scan09.slugworth-industries.net` |
| `198.51.100.19` | `scan10.slugworth-industries.net` |
| `198.51.100.20` | `www.slugworth-industries.net` |
| `198.51.100.21` | `mail.slugworth-industries.net` |

The SOA record also confirms the authoritative nameserver:
```
ns1.slugworth-industries.net.  admin.slugworth-industries.net.
```

### Flag
It is clear that the domain responsible for the patient scanning is `slugworth-industries.net`.

---

## Key Techniques

### `dig` Response Status Codes

| Status | Meaning |
|---|---|
| `NOERROR` | Query succeeded: record found |
| `REFUSED` | Server declined the query: wrong IP, wrong query type, or access restricted |
| `NXDOMAIN` | Record does not exist in this zone |

### Reverse DNS Lookup (PTR Record)

Resolves an IP address back to a hostname. `dig` reverses the IP octets and appends `.in-addr.arpa`:

```bash
# Reverse lookup for 198.51.100.13
dig @DNS_SERVER -p PORT -x 198.51.100.13 +tcp

# Equivalent manual form
dig @DNS_SERVER -p PORT 13.100.51.198.in-addr.arpa PTR +tcp
```

### Forcing TCP with `dig`

DNS defaults to UDP. Use `+tcp` when the server requires TCP:

```bash
dig @DNS_SERVER -p PORT -x IP +tcp
```

### PCAP Analysis with `tshark`

```bash
# Count packets by source IP
tshark -r capture.pcap -T fields -e ip.src | sort | uniq -c | sort -nr

# Count packets by destination IP
tshark -r capture.pcap -T fields -e ip.dst | sort | uniq -c | sort -nr

# Filter SYN packets only (port scan detection)
tshark -r capture.pcap -Y "tcp.flags.syn==1 && tcp.flags.ack==0"
```

---

## References

- [`network/scanning/dns-enumeration/`](../../../ctf-techniques/network/scanning/dns-enumeration/README.md) — DNS enumeration technique reference
- [`network/scanning/dns-zone-transfer/`](../../../ctf-techniques/network/scanning/dns-zone-transfer/README.md) — DNS zone transfer technique reference
- [RFC 5737 — TEST-NET IP ranges](https://www.rfc-editor.org/rfc/rfc5737)
- [dig man page](https://linux.die.net/man/1/dig)
