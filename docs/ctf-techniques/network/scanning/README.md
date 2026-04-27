# Scanning and Enumeration

## Overview
Tools and techniques for host discovery, port scanning, service enumeration, and DNS recon.

The list of subdirectories below is organized from broad to specific. It starts with foundational host/network discovery, then moves into service identification, then CMS-specific tools, and finally DNS as its own cluster:

- `network-scanning` → `banner-grabbing`: these are the first two steps in any recon workflow, i.e., find live hosts and open ports then identify what's running on them.
- `nikto-and-dirb`: once you know a web server is running, you scan it and brute-force its paths.
- `wpscan` → `droopescan`: CMS-specific tools that follow web server discovery, grouped together since they serve the same purpose for different platforms.
- `dns-enumeration` → `dns-zone-transfer`: DNS is its own topic; enumeration naturally precedes zone transfer as the concepts build on each other.
- `port-knocking`: placed last since it's defensive/contextual knowledge rather than a primary recon technique.

---

## Subdirectories

| Directory | Description |
|---|---|
| [`network-scanning/`](./network-scanning/README.md) | Host discovery and port scanning with Nmap |
| [`banner-grabbing/`](./banner-grabbing/README.md) | Service and version identification via banner responses |
| [`nikto-and-dirb/`](./nikto-and-dirb/README.md) | Web server scanning and directory brute-forcing |
| [`wpscan/`](./wpscan/README.md) | WordPress vulnerability and user enumeration |
| [`droopescan/`](./droopescan/README.md) | Drupal and SilverStripe CMS enumeration |
| [`dns-enumeration/`](./dns-enumeration/README.md) | Subdomain and DNS record discovery |
| [`dns-zone-transfer/`](./dns-zone-transfer/README.md) | Extracting full DNS zone records from misconfigured nameservers |
| [`port-knocking/`](./port-knocking/README.md) | Unlocking hidden services by sequencing port connections |

---

## References

- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [HackTricks - Network Services Pentesting](https://angelica.gitbook.io/hacktricks/network-services-pentesting)
