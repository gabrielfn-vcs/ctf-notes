# DNS Enumeration

## Table of Contents
- [DNS Enumeration](#dns-enumeration)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [How DNS Works](#how-dns-works)
  - [Top-Level Domain (TLD)](#top-level-domain-tld)
  - [DNS Packet Structure](#dns-packet-structure)
    - [Request and Response](#request-and-response)
      - [Header](#header)
      - [Question/Query](#questionquery)
      - [Answer](#answer)
      - [Authority](#authority)
  - [DNS Record Types](#dns-record-types)
  - [DNS Zone](#dns-zone)
    - [DNS Zone File](#dns-zone-file)
  - [Zone Transfer](#zone-transfer)
  - [Enumeration Tools](#enumeration-tools)
    - [dig — DNS Lookup and Zone Transfers](#dig--dns-lookup-and-zone-transfers)
    - [nslookup — Interactive DNS Queries](#nslookup--interactive-dns-queries)
    - [host — Quick DNS Lookups](#host--quick-dns-lookups)
    - [dnsenum — Automated DNS Enumeration](#dnsenum--automated-dns-enumeration)
    - [gobuster — Subdomain Brute-forcing](#gobuster--subdomain-brute-forcing)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

DNS (Domain Name System) runs on **port 53** and translates human-readable domain names (e.g., `www.testwebsite.com`) into IP addresses (e.g., from `10.10.10.10`). It enables web browsers to load internet resources by locating the correct server, allowing users to navigate the internet without remembering complex numerical addresses.

From a penetration testing perspective, DNS is a valuable reconnaissance target becuase a misconfigured DNS server can expose the full network topology of a target, including subdomains, internal servers, mail infrastructure, and admin email addresses.

---

## How DNS Works

Networks and servers cannot understand strings like `www.youtube.com` or `www.google.com`, which is why IP addresses are used.

When a client makes an HTTP request to a website with no local DNS record, the request is sent to a DNS server. It will assign the website's IP address with a specified domain name based on the client's location. These DNS servers can be held locally by a network admin or, in most general cases, by the ISP itself.

DNS servers break the name into different sections, starting from the right side of the domain name. For example, the website address `www.google.com` would be split into `com`, `google`, and `www`.

---

## Top-Level Domain (TLD)

A top-level domain or TLD refers to the domain that follows right after the second 'dot' symbol on a web link (`www.immersivelabs.com`).

There are two types of TLDs: generic and country-specific.

A TLD describes the website's objective. For example, `.gov` represents US government agencies. Globally, there are approximately 1000 top-level domains in use. Some other TLDs are listed below.

| TLD | Purpose |
|---|---|
| `.com` | Commercial businesses |
| `.org` | Organisations (generally charitable) |
| `.net` | Network organisations |
| `.gov` | US government agencies |
| `.mil` | Military |
| `.edu` | Educational institutions |
| `.co.uk` / `.ca` / `.au` | Country-specific domains |

---

## DNS Packet Structure

DNS tends to use the User Datagram Protocol (UDP) as the standard transfer protocol, as it is fast and can send single packets.

DNS packets have to be below 512 bytes to be sent over UDP. The UDP port number for DNS is 53. If the packet size increases (e.g., multiple IPv6 entries in the DNS records), the DNS will use TCP.

Within that DNS message are 10 parts, each with a unique purpose. Each field value will differ according to the specific request or response.

### Request and Response

A DNS packet features a set of resource records that describe the basic elements of the domain name system. Below is a breakdown of each section that forms a request or response packet:

#### Header
This section carries six 16-bit fields carrying key control flags and lists of other sections used in a particular message. The header carries all the required control fields within the request and response.

1. Identification
2. Control
3. Question count
4. Answer count
5. Authority count
6. Additional count

#### Question/Query
A query, also known as a question, comprises three parts: name, type, and class.

- The query **name** is the website the client requests.
- The **type** field states what type of DNS record the website is. These can be found using the `dig` tool and viewing the DNS zone files.
- The query **class** will almost always display `1` or `IN` (for Internet.)

#### Answer
Answers are in the response packets under 'Domain Name System (response).'

There are five parts to a response packet's answer: name, type, class, time to live, and data length/address.

- The first three parts (**name**, **style**, and **class**) serve the same function as the query from a request packet. 
- The **time to live** (TTL) describes, in seconds, how long the DNS record will last (this should not be confused with the packet's TTL under Internet Protocol Version 4).
- The **data length** represents how large the data being transferred is (e.g., 16 bits), while the **address** segment will detail the resolved host address.

#### Authority
The authority section of a DNS packet gives information about servers that are authoritative for the domain name in question. The authority section of a packet will always show as a name server (`NS`) record.

---

## DNS Record Types

| Record | Description |
|---|---|
| `A` | Maps a hostname to an IPv4 address |
| `AAAA` | Maps a hostname to an IPv6 address |
| `CNAME` | Alias pointing to another hostname |
| `MX` | Mail exchange server for the domain |
| `NS` | Authoritative nameserver for the domain |
| `TXT` | Arbitrary text — used for verification, SPF, flags in CTFs |
| `SOA` | Start of Authority — primary nameserver and admin contact for the zone |

---

## DNS Zone

Every website has a root server containing the primary domain name (e.g., `.com`). This primary domain can be broken down into different zones. A DNS zone is a portion of the DNS namespace managed by a specific authoritative server. With a DNS server in place, these subdomains will be assigned a unique name which can be based on things like locations or departments within an organization.

A company that operates all over the world will have different domains on the servers based on a particular location, e.g. `company.co.uk` (UK) and `company.au` (Australia). The domain in Australia may also have subdomains throughout different cities, but having all this on one server can slow it down. To counter this, domains and their subdomains are organized into different zones.

DNS zones are represented and organized hierarchically with the primary domain name at the top. DNS zones may contain one domain, many domains, or many subdomains.

### DNS Zone File
DNS records can hold a wealth of information. A **zone file** specifies all the information about a certain DNS zone.

- The name of the DNS zone.
- TTL (time to live) values to specify how long records are kept in the DNS server cache.
- Information about the network’s topology and DNS mapping:
  - Hostnames and IP addresses of other servers.
  - Mail server configuration.
  - Potentially email addresses of server administrators.

Zone files also contain information about the DNS record type; they describe information about a specific object and the different types have different associations. For example, a type `A` record specifies an IPv4 address for a given host.

---

## Zone Transfer

A zone transfer (`AXFR`) is a specific DNS request to retrieve all information on that DNS server’s zone. Properly configured servers restrict this to trusted secondary nameservers only.

A **misconfigured DNS server** will give anyone access to the DNS records if they ask for it. This technique can be valuable for penetration testers as it can reveal all the subdomains, internal IP addresses, mail server, and any other records, enabling them to predict the IP schema and identify different servers in the network. It is a useful tool for reconnaissance of a target, especially during the enumeration stage.

```bash
# Attempt a zone transfer with dig
dig DOMAIN @DNS_SERVER_IP axfr

# Example
dig example.com @10.10.10.10 axfr
```

Zone transfers use TCP (Transmission Control Protocol), but where this is disabled, it is often possible to brute force addresses by using a wordlist of host names and submitting many queries to the server. See [`../dns-zone-transfer/`](../dns-zone-transfer/README.md) for a full walkthrough and example output.

---

## Enumeration Tools

### dig — DNS Lookup and Zone Transfers

```bash
# Query an A record
dig example.com A

# Query a specific record type
dig example.com MX
dig example.com NS
dig example.com TXT

# Use a specific DNS server
dig example.com @10.10.10.10

# Attempt zone transfer
dig example.com @10.10.10.10 axfr
```

---

### nslookup — Interactive DNS Queries

```bash
nslookup example.com
nslookup -type=MX example.com
nslookup -type=NS example.com
```

### host — Quick DNS Lookups

```bash
host example.com
host -t MX example.com
host -t NS example.com
```

### dnsenum — Automated DNS Enumeration

Automates record lookup, zone transfer attempts, and subdomain brute-forcing:

```bash
dnsenum example.com
dnsenum --dnsserver 10.10.10.10 example.com
```

### gobuster — Subdomain Brute-forcing

Used when zone transfers are blocked:

```bash
gobuster dns -d example.com -w /usr/share/wordlists/subdomains.txt
```

---

## References

### Challenges
| Source | Name |
|---|---|
| Immersive Labs | [Scanning - DNS Zone Transfer](../../../../ctf-writeups/immersive-labs/03-scanning-dns-zone-transfer/README.md) |

### Web Sites
- [RFC 1034 — DNS Concepts](https://www.rfc-editor.org/rfc/rfc1034)
- [RFC 1035 — DNS Implementation](https://www.rfc-editor.org/rfc/rfc1035)
- [HackTricks - DNS Enumeration](https://angelica.gitbook.io/hacktricks/network-services-pentesting/pentesting-dns)
- [PayloadsAllTheThings - DNS Rebinding](https://swisskyrepo.github.io/PayloadsAllTheThings/DNS%20Rebinding/)
- [dig man page](https://linux.die.net/man/1/dig)
