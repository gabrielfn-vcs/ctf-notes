# Port Knocking

## Table of Contents
- [Port Knocking](#port-knocking)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Advantages and Disanvantages](#advantages-and-disanvantages)
  - [How It Works](#how-it-works)
  - [Usage](#usage)
    - [Using the `knock` Client](#using-the-knock-client)
    - [Using Netcat Manually](#using-netcat-manually)
    - [Using Nmap](#using-nmap)
  - [CTF Approach](#ctf-approach)
  - [References](#references)

---

## Overview

Port knocking is a defense-in-depth technique that hides open services behind a firewall until a specific sequence of connection attempts is made to pre-defined ports. Unless the correct knock sequence is sent, all ports appear closed to a scanner.

It is implemented on Linux via the **Knockd daemon**, which listens for knock sequences and runs a configured command (typically a firewall rule change) when the correct sequence is detected.

### Advantages and Disanvantages

The benefits of using port knocking are that it makes successful port access extremely difficult, especially when combined with other security measures, e.g., knock attempt-limiting, longer/more complex sequences, and cryptographic hashes. It is also flexible, customizable, and simultaneous sessions are easily accommodated.

One disadvantage of port knocking, however, is that it's dependent on the robustness of the port-knocking daemon. If the daemon fails, all users will be denied port access, which would be an undesirable single point of failure. However, this can be mitigated by providing a process-monitoring daemon, which can restart a failed or stalled port-knocking daemon process. Port knocking can be problematic on networks exhibiting high latency and should not be used as the primary authentication mechanism for a server.

> **Note:** Port knocking should be treated as one layer of a defense strategy, not a standalone security solution.
---

## How It Works

1. All target ports appear closed to an external port scan.
2. The client sends connection attempts to a pre-defined sequence of ports in order.
3. The Knockd daemon detects the sequence and opens the target port (e.g., SSH on 22, HTTP on 80).
4. The client connects to the now-open service.

---

## Usage

### Using the `knock` Client

```bash
knock TARGET_IP PORT1 PORT2 PORT3
```

After a successful knock, connect to the unlocked service:

```bash
# Example: SSH now accessible after knocking
ssh user@TARGET_IP

# Example: Web service now accessible after knocking
curl http://TARGET_IP
```

### Using Netcat Manually

If the `knock` client is unavailable, the sequence can be sent manually with Netcat:

```bash
nc -z TARGET_IP PORT1
nc -z TARGET_IP PORT2
nc -z TARGET_IP PORT3
```

### Using Nmap

```bash
nmap -Pn --host-timeout 201 --max-retries 0 -p PORT1 TARGET_IP
nmap -Pn --host-timeout 201 --max-retries 0 -p PORT2 TARGET_IP
nmap -Pn --host-timeout 201 --max-retries 0 -p PORT3 TARGET_IP
```

---

## CTF Approach

When port knocking is suspected in a CTF challenge:

1. Check for a `knockd.conf` file if you have filesystem access — it contains the knock sequence and the port it unlocks.
2. Common locations: `/etc/knockd.conf`, `/etc/knock.conf`.
3. If no config is accessible, look for the sequence in challenge hints, source code, or other artifacts.

```bash
# Read the knockd config if accessible
cat /etc/knockd.conf
```

A typical `knockd.conf` looks like:

```ini
[openSSH]
    sequence    = 7000,8000,9000
    seq_timeout = 5
    command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
    tcpflags    = syn
```
---

## References

- [Knockd on GitHub](https://github.com/jvinet/knock)
- [HackTricks - Port Knocking](https://book.hacktricks.xyz/network-services-pentesting/port-knocking)
- [Kali Tools — Knock](https://www.kali.org/tools/knockd/)
