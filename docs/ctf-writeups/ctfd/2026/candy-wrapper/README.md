# Candy Wrapper Espionage, Hidden Command Channel

## Table of Contents
- [Candy Wrapper Espionage, Hidden Command Channel](#candy-wrapper-espionage-hidden-command-channel)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Challenge Description](#challenge-description)
  - [Executive Summary](#executive-summary)
  - [Technical Analysis of the Exfiltration](#technical-analysis-of-the-exfiltration)
  - [Analysis and Approach](#analysis-and-approach)
    - [Step 1 — Extract Base64 Subdomains from PCAP](#step-1--extract-base64-subdomains-from-pcap)
    - [Step 2 — Identify the Cipher](#step-2--identify-the-cipher)
      - [Cryptographic Progression](#cryptographic-progression)
    - [Step 3 — Brute Force Per-Packet Key with Frequency Analysis](#step-3--brute-force-per-packet-key-with-frequency-analysis)
      - [XOR Key Derivation Table](#xor-key-derivation-table)
      - [The Mathematical Formula](#the-mathematical-formula)
    - [Step 4 — Reassemble the Message](#step-4--reassemble-the-message)
  - [Solution](#solution)
  - [Key Techniques and Lessons Learned](#key-techniques-and-lessons-learned)
    - [DNS Tunneling Detection](#dns-tunneling-detection)
    - [Protocol Anchor Identification](#protocol-anchor-identification)
    - [Rolling XOR vs. Fixed XOR](#rolling-xor-vs-fixed-xor)
    - [Frequency Analysis as an Oracle](#frequency-analysis-as-an-oracle)
    - [Base64 Padding](#base64-padding)
  - [Files](#files)
  - [References](#references)
  - [Navigation](#navigation)

## Overview

This report summarizes the findings of the "Candy Wrapper" Command and Control (C2) challenge investigation. It details the methods used by the adversary to exfiltrate data and the mathematical progression used to obfuscate the communication.

### Challenge Description

Data flutters across the wire, each one tiny and unremarkable—like sugar crystals falling through the air. Together, though, they form a pattern—precise and intentional.

An Oompa Loompa squints at the screen. "That's not curiosity," he mutters. "That's conversation."

**Task:** Extract the hidden message being sent to the Command and Control server.

**Flag:** Enter the secret message as the flag.

**Download:** [`c2_server_packets.pcap`](./c2_server_packets.pcap)

---

## Executive Summary

A stealthy data exfiltration channel was discovered utilizing **DNS Tunneling** to bypass perimeter firewalls. The adversary used a custom **Rolling XOR Cipher** with an incrementing "wrapper" offset to transmit a sensitive message regarding the acquisition of a proprietary formula.

---

## Technical Analysis of the Exfiltration

The breach utilized the DNS protocol as a covert transport mechanism. Instead of normal web traffic, the "Agent" encoded data into the **subdomains** of a seemingly innocuous domain: `sweetinfo.net`.

* **Transport Mechanism:** DNS Query (Type A)
* **Encoding:** Base64
* **Obfuscation:** Multi-layered bitwise XOR ($\oplus$)
* **Target Domain:** `sweetinfo.net`

---

## Analysis and Approach

### Step 1 — Extract Base64 Subdomains from PCAP

Open `c2_server_packets.pcap` in Wireshark and filter for DNS traffic to `sweetinfo.net`:
```
dns && dns.qry.name contains "sweetinfo.net"
```

Below are the specifc DNS entries that contain suspicious content:
```
92      1.403599        10.200.10.105   198.51.100.13   DNS     115     Standard query 0x0000 A TVNHMDAwMEFHRU5UIEFDVElWRS4.sweetinfo.net
111     2.008116        198.51.100.13   10.200.10.105   DNS     172     Standard query response 0x0000 A TVNHMDAwMEFHRU5UIEFDVElWRS4.sweetinfo.net A 45.33.32.156

163     3.008963        10.200.10.105   198.51.100.13   DNS     115     Standard query 0x0000 A MVRHVENdUEJFWF9WMVZeU0JFXkE.sweetinfo.net
177     3.388153        198.51.100.13   10.200.10.105   DNS     172     Standard query response 0x0000 A MVRHVENdUEJFWF9WMVZeU0JFXkE.sweetinfo.net A 45.33.32.156

250     4.778305        10.200.10.105   198.51.100.13   DNS     115     Standard query 0x0000 A cmdwAmRtcG93bmMCY2Fzd2twZ2Y.sweetinfo.net
270     4.910697        198.51.100.13   10.200.10.105   DNS     172     Standard query response 0x0000 A cmdwAmRtcG93bmMCY2Fzd2twZ2Y.sweetinfo.net A 45.33.32.156

318     6.213705        10.200.10.105   198.51.100.13   DNS     115     Standard query 0x0000 A HRNnYXJ9YH56Z2d6fXQTd3JnchM.sweetinfo.net
336     6.331881        198.51.100.13   10.200.10.105   DNS     172     Standard query response 0x0000 A HRNnYXJ9YH56Z2d6fXQTd3JnchM.sweetinfo.net A 45.33.32.156

361     6.973177        10.200.10.105   198.51.100.13   DNS     115     Standard query 0x0000 A EAtkBwsJCQUKAGQXARYSARZqZAk.sweetinfo.net
375     7.013807        198.51.100.13   10.200.10.105   DNS     172     Standard query response 0x0000 A EAtkBwsJCQUKAGQXARYSARZqZAk.sweetinfo.net A 45.33.32.156

425     8.225357        10.200.10.105   198.51.100.13   DNS     110     Standard query 0x0000 A HAYGHBobdRYaGAUZEAEQew.sweetinfo.net
433     8.249025        198.51.100.13   10.200.10.105   DNS     162     Standard query response 0x0000 A HAYGHBobdRYaGAUZEAEQew.sweetinfo.net A 45.33.32.156
```

Extract the subdomain portion (everything before `.sweetinfo.net`) from each suspicious query. These are the Base64-encoded, XOR-encrypted message fragments.

* **Packet 0:** `TVNHMDAwMEFHRU5UIEFDVElWRS4`
* **Packet 1:** `MVRHVENdUEJFWF9WMVZeU0JFXkE`
* **Packet 2:** `cmdwAmRtcG93bmMCY2Fzd2twZ2Y`
* **Packet 3:** `HRNnYXJ9YH56Z2d6fXQTd3JnchM`
* **Packet 4:** `EAtkBwsJCQUKAGQXARYSARZqZAk`
* **Packet 5:** `HAYGHBobdRYaGAUZEAEQew`

### Step 2 — Identify the Cipher

Decode the first subdomain in packet 0 through a standard Base64 decoder:

```bash
echo "TVNHMDAwMEFHRU5UIEFDVElWRS4=" | base64 -d
```
```
MSG0000AGENT ACTIVE.
```

The first packet decodes cleanly. The remaining packets produce garbled output.

#### Cryptographic Progression

- The "Oompa Loompa" analyst noted a "sugar crystal" pattern, which refers to the predictable bit-flips in the binary data.
- This points to an encryption using a **rolling XOR cipher** as the flavor (wrapper) that changes the key with each packet rather than being fixed.
- Evolving the key with every packet prevents simple signature-based detection.

### Step 3 — Brute Force Per-Packet Key with Frequency Analysis

Since the XOR key is unknown for packets 1–5, let's brute-forces all 256 possible single-byte keys per packet and score each result using **English frequency analysis** where the result with the most letters, spaces, and printable characters wins:

Sample Python code:
```python
def get_english_score(data: bytes):
    score = 0
    for b in data:
        if ord('a') <= b <= ord('z') or ord('A') <= b <= ord('Z'):
            score += 10      # letters
        if b == ord(' '):
            score += 12      # spaces
        if ord('0') <= b <= ord('9') or b in b'._!':
            score += 5       # digits and common punctuation
        if b < 32 or b > 126:
            score -= 20      # heavy penalty for non-printable bytes
    return score
```

#### XOR Key Derivation Table

Running through the algorithm above produces the following output:

| Packet | Sequence Index | Wrapper (Flavor) | Resulting XOR Key | Base64 Input | Decrypted Segment |
| --- | --- | --- | --- | --- | --- |
| **0** | $0$ | $0x00$ | $0x00$ | `TVNHMDAwMEFHRU5UIEFDVElWRS4=` | `MSG0000AGENT ACTIVE.` |
| **1** | $1$ | $0x10$ | $0x11$ | `MVRHVENdUEJFWF9WMVZeU0JFXkE=` | ` EVERLASTING GOBSTOP` |
| **2** | $2$ | $0x20$ | $0x22$ | `cmdwAmRtcG93bmMCY2Fzd2twZ2Y=` | `PER FORMULA ACQUIRED` |
| **3** | $3$ | $0x30$ | $0x33$ | `HRNnYXJ9YH56Z2d6fXQTd3JnchM=` | `. TRANSMITTING DATA ` |
| **4** | $4$ | $0x40$ | $0x44$ | `EAtkBwsJCQUKAGQXARYSARZqZAk=` | `TO COMMAND SERVER. M` |
| **5** | $5$ | $0x50$ | $0x55$ | `HAYGHBobdRYaGAUZEAEQew==`     | `ISSION COMPLETE.` |

#### The Mathematical Formula
The attacker implemented a nested mathematical sequence for the XOR keys.

The key for each packet follows this logic:

$$Key = \text{Index} \oplus \text{Wrapper}$$

where the $Wrapper$ increments by `0x10` (16) for each packet: `0x00`, `0x10`, `0x20`, `0x30`, `0x40`, `0x50`.

$$Key = \text{Index} \oplus (\text{Index} \times 16)$$

### Step 4 — Reassemble the Message

Each decrypted packet segment is concatenated in order to recover the full plaintext message.

---

## Solution

The full decryption is implemented in [`decode_wrapper.py`](./decode_wrapper.py).

By reassembling the decrypted segments, the following cleartext was recovered as the flag:
```
MSG0000AGENT ACTIVE. EVERLASTING GOBSTOPPER FORMULA ACQUIRED. TRANSMITTING DATA TO COMMAND SERVER. MISSION COMPLETE.
```

---

## Key Techniques and Lessons Learned

### DNS Tunneling Detection
Long, high-entropy subdomains in a PCAP are almost always Base64 or hex-encoded data being exfiltrated. When you see random-looking strings prefixed to a domain, decode them immediately.

### Protocol Anchor Identification
The first packet decoded cleanly to `MSG0000AGENT ACTIVE.` without any XOR manipulation. Known protocol headers (`MSG`, `HTTP`, `GET`) reveal the initial key and confirm the encoding scheme.

### Rolling XOR vs. Fixed XOR
When the first packet decodes but the rest are garbled, the key is changing per packet. Look for mathematical progressions in the keys, e.g., linear growth (`0x11`, `0x22`, `0x33`) or additive steps (`0x00`, `0x10`, `0x20`) are common patterns.

### Frequency Analysis as an Oracle
When the key is unknown, English frequency scoring (high weight for letters and spaces, heavy penalty for non-printable bytes) reliably identifies the correct key from 256 candidates without any known plaintext.

### Base64 Padding
Base64 strings in DNS subdomains often have padding (`=`) stripped since `=` is not valid in a hostname. Always restore padding before decoding: add `=` signs until the string length is a multiple of 4.

To prevent future "Candy Wrapper" style breaches, the following security controls are recommended:

1. **Entropy Monitoring:** Implement logic to monitor DNS logs for high-entropy subdomains (random-looking strings) which are indicative of encoded data.
2. **DNS Request Length Filtering:** Flag or block DNS queries where the subdomain length exceeds standard naming conventions (e.g., queries longer than 50 characters).
3. **Beaconing Detection:** Utilize behavioral analytics to alert on regular intervals of DNS queries to external domains that do not resolve to known business services or CDNs.
4. **Protocol Inspection:** Use Deep Packet Inspection (DPI) to identify non-standard data structures within the `dns.qry.name` field.

---

## Files

| File | Description |
|---|---|
| [`c2_server_packets.pcap`](./c2_server_packets.pcap) | Packet capture containing the covert DNS C2 channel |
| [`decode_wrapper.py`](./decode_wrapper.py) | Python script to extract, brute-force, and reassemble the hidden message |

---

## References

- [`ctf-techniques/network/scanning/dns-enumeration`](../../../../ctf-techniques/network/scanning/dns-enumeration/README.md) — DNS enumeration technique reference
- [`ctf-techniques/crypto/`](../../../../ctf-techniques/crypto/README.md) — XOR cipher key recovery reference
- [DNS Tunneling — SANS](https://www.sans.org/blog/dns-data-exfiltration-what-is-it-and-how-to-detect-it/)
- [XOR cipher — Wikipedia](https://en.wikipedia.org/wiki/XOR_cipher)
- [Base64 — Wikipedia](https://en.wikipedia.org/wiki/Base64)
- [Wireshark DNS filter reference](https://www.wireshark.org/docs/dfref/d/dns.html)

---

## Navigation

| |
|---:|
| [Decrypt](../decrypt/README.md) → |
