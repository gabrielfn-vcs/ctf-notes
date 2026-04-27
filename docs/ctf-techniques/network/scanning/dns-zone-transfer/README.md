# DNS Zone Transfer

## Table of Contents
- [DNS Zone Transfer](#dns-zone-transfer)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Background](#background)
  - [DNS Record Types](#dns-record-types)
    - [Reading the SOA Record](#reading-the-soa-record)
  - [Performing a Zone Transfer](#performing-a-zone-transfer)
  - [CTF Approach](#ctf-approach)
    - [Example](#example)
  - [Securing DNS servers](#securing-dns-servers)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

DNS zone transfers are a mechanism for replicating DNS records between authoritative servers. When misconfigured, they can be exploited by attackers to enumerate the full DNS record set of a domain, revealing internal hosts, staging environments, VPNs, admin panels, and sometimes tokens or flags hidden in records.

---

## Background

Authoritative DNS servers contain one or more DNS zones. Each zone can have its own configurable rules and DNS information, ranging from CNAME to TXT records. Often large businesses will run several DNS servers across their network estate for reasons of resilience and availability. The use of DNS zone transfers allows a simple way to update all of these servers from a single managed authoritative DNS server.

When an update to an authoritative zone occurs, other domain servers that also use this zone will want to replicate the changes. Instead of updating each server individually, DNS servers can perform regular zone transfers to update their DNS records. When a secondary DNS server initializes a zone transfer, it will request a copy of all zone entries and update its own records.

Misconfigured DNS servers may allow attackers to perform a zone transfer which will present all DNS records to the attacker. This might allow the attacker to gain knowledge of sensitive domains that may expose previously unknown attack surfaces such as:

- Internal hostnames and IP addresses
- Staging and testing/UAT environments
- Mail servers, VPNs, and admin subdomains
- Flags or tokens embedded in TXT or CNAME records

---

## DNS Record Types

| Record | Description |
|---|---|
| `SOA` | Start of Authority — identifies the primary nameserver (MNAME) and admin contact (RNAME) |
| `NS` | Nameserver records |
| `A` | IPv4 address for a hostname |
| `CNAME` | Alias pointing to another hostname |
| `MX` | Mail exchange servers |
| `TXT` | Arbitrary text — often used for verification tokens or flags in CTFs |

### Reading the SOA Record

The SOA record contains two important fields:

- **MNAME** — the primary (master) nameserver for the zone
- **RNAME** — the responsible party's email address, with `@` replaced by `.`

```
bartertowngroup.com. IN SOA dns1.bartertowngroup.com. hostmaster.bartertowngroup.com. ...
                               └─ MNAME                └─ RNAME (hostmaster@bartertowngroup.com)
```

## Performing a Zone Transfer

There are several tools that can be used to query DNS servers. Most of these tools also have zone transfer capabilities. When initialising a zone transfer, the attacker will first need to know the name of the zone which they are targeting and then specify the IP address of the DNS server to perform the zone transfer against.

Use `dig` with the `axfr` (full zone transfer) argument to launch a zone transfer against a domain:

```bash
dig DOMAIN @DNS_SERVER_IP axfr
```

The ‘@’ symbol is used to specify the target DNS server.

For example, to target a domain (vulnerable-domain.com), targetting the DNS server 10.10.10.10:

```bash
dig vulnerable-domain.com @10.10.10.10 axfr
```

---

## CTF Approach

Zone transfer outputs reward careful reading. Work through each record type systematically:

| What to look for | Where to find it |
|---|---|
| Primary DNS server for the domain | In the `MNAME` field in the SOA record |
| Admin email | In the `RNAME` field in the SOA record; replace the first `.` with a `@` |
| Internal/staging hosts | In the `CNAME` and `A` records for non-www subdomains |
| Flags or tokens | Part of `TXT` records and unusual `CNAME` subdomain names |

> [!TIP]
> Flags and tokens are sometimes hidden as subdomain names in CNAME records (e.g., `the.token.is.FLAG.domain.com`), not just in TXT record values. Scan all record names, not just their values.

### Example
```bash
dig bartertowngroup.com @10.102.166.237 axfr
```
```
; <<>> DiG 9.18.8-1-Debian <<>> bartertowngroup.com @10.102.166.237 axfr
;; global options: +cmd
bartertowngroup.com.	86400	IN	SOA	dns1.bartertowngroup.com. hostmaster.bartertowngroup.com. 2020030501 21600 3600 604800 86400
bartertowngroup.com.	86400	IN	NS	dns1.bartertowngroup.com.
bartertowngroup.com.	86400	IN	NS	dns2.bartertowngroup.com.
bartertowngroup.com.	86400	IN	MX	10 mail.bartertowngroup.com.
bartertowngroup.com.	86400	IN	MX	20 mail2.bartertowngroup.com.
bartertowngroup.com.	86400	IN	A	203.0.113.10
bartertowngroup.com.	86400	IN	TXT	"Hello World!"
dns1.bartertowngroup.com. 86400	IN	A	203.0.113.1
dns2.bartertowngroup.com. 86400	IN	A	203.0.113.2
ftp.bartertowngroup.com. 86400	IN	CNAME	server1.bartertowngroup.com.
mail.bartertowngroup.com. 86400	IN	A	203.0.113.3
mail2.bartertowngroup.com. 86400 IN	A	203.0.113.4
server1.bartertowngroup.com. 86400 IN	A	203.0.113.10
server2.bartertowngroup.com. 86400 IN	A	203.0.113.20
the.token.is.sh79jlacnjwyi.bartertowngroup.com.	86400 IN CNAME server1.bartertowngroup.com.
staging.bartertowngroup.com. 86400 IN	CNAME	server2.bartertowngroup.com.
www.bartertowngroup.com. 86400	IN	CNAME	server1.bartertowngroup.com.
bartertowngroup.com.	86400	IN	SOA	dns1.bartertowngroup.com. hostmaster.bartertowngroup.com. 2020030501 21600 3600 604800 86400
;; Query time: 16 msec
;; SERVER: 10.102.166.237#53(10.102.166.237) (TCP)
;; WHEN: Fri Nov 08 06:09:16 UTC 2024
```

Answer the following questions:

1. What is the `MNAME` listed by the DNS server?
   * The `MNAME` in the SOA (primary DNS server for the domain) is `dns1.bartertowngroup.com`.

2. What is the RNAME listed by the DNS server?
   * The `RNAME` in the SOA record (email address of the person responsible for managing the DNS records) is `hostmaster.bartertowngroup.com`.
  
3. What is the IP address of the staging environment?
   * The staging environment’s address is listed as a CNAME pointing to `server2.bartertowngroup.com`. We can find the A record for `server2.bartertowngroup.com` as `203.0.113.20`.

4. What is the value of the TXT record?
   * The `TXT` record in the output appears as:
     ```
     bartertowngroup.com. 86400 IN TXT "Hello World!"
     ```
     the value is `"Hello World!"`.

5. What is the token value found?
   * The token value is found as a part of a `CNAME` record:
     ```
     the.token.is.sh79jlacnjwyi.bartertowngroup.com. 86400 IN CNAME server1.bartertowngroup.com.
     ```
     The token is `sh79jlacnjwyi`.

---

## Securing DNS servers

Depending on the DNS server running, it is often possible that misconfigured zone transfers can be locked down by restricting transfers to trusted IPs. This allows only trusted IP addresses to perform zone transfers, removing the ability to enumerate domain names.

Using BIND DNS, this can be done by modifying the `named.conf` configuration file using the ACL (access control list) option, which can then be added to a given zone.

Fos instance, let's configure a list of trusted secondaries for a DNS server.

```conf
acl bartertowngroup-trusted-zones {
    10.15.0.254; //ns2
    10.16.0.254; //ns3
};
zone bartertowngroup.com {
    type master;
    file "zones/bartertowngroup.com";
    allow-transfer { bartertowngroup-trusted-zones; };
};
```

The `bartertowngroup.com` server allows zone transfers to occur from either of the IP addresses found in the `bartertowngroup-trusted-zones` ACL.

For stronger security, admins can also implement TSIG (Secret Key Transaction Authentication for DNS) to cryptographically authenticate zone transfer requests between DNS servers.

---

## References

### Challenges
| Source | Name |
|---|---|
| Immersive Labs | [Scanning - DNS Zone Transfer](../../../../ctf-writeups/immersive-labs/03-scanning-dns-zone-transfer/README.md) |

### Web Sites
- [HackTricks - DNS Zone Transfer](https://angelica.gitbook.io/hacktricks/network-services-pentesting/pentesting-dns#zone-transfer)
- [CIRA — Using TSIG for Secure DNS Communication](https://www.cira.ca/en/resources/documents/cybersecurity/using-transaction-signatures-tsig-secure-dns-server-communication/)
- [dig man page](https://linux.die.net/man/1/dig)
