# Network Scanning

## Table of Contents
- [Network Scanning](#network-scanning)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Two Types of Network Scanning](#two-types-of-network-scanning)
      - [Port scanning](#port-scanning)
      - [Vulnerability scanning](#vulnerability-scanning)
  - [Tools](#tools)
    - [Netcat — Basic Port Scanning](#netcat--basic-port-scanning)
    - [Nmap — Advanced Port and Service Scanning](#nmap--advanced-port-and-service-scanning)
    - [Nessus — Vulnerability Scanning](#nessus--vulnerability-scanning)
  - [Nmap Scan Types Reference](#nmap-scan-types-reference)
  - [References](#references)

---

## Overview

Network scanning is an information-gathering technique used to map a target network, identify live hosts, discover open ports, and detect vulnerabilities in running services. It is a core activity during the enumeration phase of a penetration test.

### Two Types of Network Scanning

#### Port scanning
Attempts to identify live (or active) hosts on a network by using features of the network protocol to signal devices and await a response. The characteristics of this response can determine if the targeted host is a live host and which ports are open. Other types of response can indicate if the host is situated behind a filter, such as a firewall.

#### Vulnerability scanning
Follows port scanning to identify known weaknesses in the services running on discovered open ports. Checks for vulnerable software versions, misconfigurations, weak/default passwords, and denial-of-service flaws.

> [!WARNING]
> Network scanning without explicit permission is illegal in most jurisdictions. Always ensure you have authorization before scanning any network.

---

## Tools

A simple network scan could involve sending a ping message to a range of IP addresses and then marking the hosts that respond as live hosts. Further scanning using other protocols can then be used on these live hosts to obtain more information about the target network. Many tried-and-tested tools exist for network scanning, below are the most popular of these.

### Netcat — Basic Port Scanning

Netcat is available natively on most Linux systems and can function as a basic port scanner using the `-z` flag (scan without connecting) and `-v` for verbose output. It lacks the sophistication of Nmap but is useful when more advanced tools are unavailable.

```bash
# Show help
nc -h

# Scan the first 1000 ports on a target
nc -z -v TARGET 1-1000

# Scan a specific port range
nc -z -v TARGET 20-25
```

Netcat can also be used for banner grabbing, data transfer between hosts, and connecting to remote shells. See [`../banner-grabbing/`](../banner-grabbing/README.md) for banner grabbing usage.

### Nmap — Advanced Port and Service Scanning

Nmap is the primary tool for network scanning, offering multiple scanning modes suited to different situations including stealth scanning.

The most common mode is **SYN scanning**, which sends the first stage of the TCP three-way handshake (the `SYN` packet) to determine live hosts in a range. If the host responds with the synchronization acknowledged (`SYN/ACK`) packet, then the port is open.

By default, Nmap scans the **top 1000 most common ports** on a target.

```bash
# Show help
nmap -h

# Basic SYN scan
nmap -sS TARGET

# Scan a specific port
nmap TARGET -p 80

# Scan a port range
nmap TARGET -p 1-1000

# Scan all 65535 ports
nmap TARGET -p-

# Service and version detection
nmap -sV TARGET

# OS detection
nmap -O TARGET

# Run default scripts with service detection
nmap -sC -sV TARGET

# Full scan — service detection, scripts, and all ports
nmap -sC -sV -p- TARGET

# Output results to a file
nmap -sV TARGET -oN output.txt
```

### Nessus — Vulnerability Scanning

Nessus extends beyond port and service discovery to actively scan for known vulnerabilities and misconfigurations across operating systems, network devices, databases, and web servers. Results are presented via a GUI web application, sorted by criticality with filtering and grouping tools.

Unlike Nmap, Nessus is a commercial tool (with a free Essentials tier for limited use). It is typically used for formal vulnerability assessments rather than CTF work.

---

## Nmap Scan Types Reference

| Flag | Scan Type | Notes |
|---|---|---|
| `-sS` | SYN scan (half-open) | Default for root — fast and stealthy |
| `-sT` | TCP connect scan | Used when SYN scan is unavailable (no root) |
| `-sU` | UDP scan | Slower; used for DNS, SNMP, DHCP |
| `-sV` | Version detection | Identifies service versions on open ports |
| `-sC` | Default scripts | Runs Nmap's default NSE scripts |
| `-O` | OS detection | Attempts to identify the operating system |
| `-A` | Aggressive scan | Combines `-sV`, `-sC`, `-O`, and traceroute |
| `-Pn` | Skip host discovery | Treats all hosts as online (useful if ICMP is blocked) |
| `-p-` | All ports | Scans all 65535 ports |
| `-oN` | Normal output | Saves results to a file |

---

## References

- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [Nmap NSE Script Database](https://nmap.org/nsedoc/)
- [HackTricks - Network Scanning](https://angelica.gitbook.io/hacktricks/generic-methodologies-and-resources/pentesting-network)
- [Nessus](https://www.tenable.com/products/nessus)
