# CTF Techniques

## Overview

A personal reference repository of techniques, tools, and scripts collected from CTF (Capture The Flag) competitions, events, and security labs under the [CTF Writeups](../ctf-writeups/README.md).

Content is organized by topic rather than by event. This way, you can look things up by *what needs to be done* rather than *where was this technique used*.

---

## Structure

| Directory | Category | Description |
|---|---|---|
| 🌐 [`web/`](./web/README.md) | Web Applications | Web application attacks — SQLi, SSTI, RCE, XSS, JWT, Firebase, prototype pollution, cookies, Burp Suite, cURL |
| 🔐 [`crypto/`](./crypto/README.md) | Cryptography | Cryptography attacks and decryption workflows — GPG, hash cracking, XOR, DNS tunneling |
| 🕵️ [`forensics/`](./forensics/README.md) | Forensics | Log analysis, PCAP inspection, file carving, EXIF image metadata extraction |
| 📡 [`network/`](./network/README.md) | Network | Network recon, scanning, and tunneling — nmap, Nikto, WPScan, DNS enumeration, reverse shells |
| 💻 [`post-exploitation/`](./post-exploitation/README.md) | Post-Exploitation | System enumeration and privilege escalation — Linux and Windows |
| 🔁 [`reverse/`](./reverse/README.md) | Reverse Engineering | Binary reverse engineering — PyInstaller unpacking, bytecode disassembly, Go binaries with Ghidra, Java decompilation |
| 📱 [`mobile/`](./mobile/README.md) | Mobile Applications | Android APK reverse engineering and analysis |
| 🔌 [`hardware/`](./hardware/README.md) | Hardware | Hardware protocol capture and decoding — 1-Wire, I2C, SPI, CAN bus |

---

## Getting a macOS system ready for playing CTFs

Below is a detailed guide to the [OSX-CTF-Ready](https://github.com/chikko80/OSX-CTF-Ready) GitHub repository.

### Pre-requisites

We will use Homebrew for the main installation of the binaries.

The Xcode Command Line Tools (CLT) are a prerequisite for Homebrew to function properly. Homebrew itself and many of the packages it installs ("formulae") rely on the compilers and other Unix-based utilities included in the CLT package.

If you run the Homebrew installation script without the tools already installed, it will automatically prompt you to install the Xcode Command Line Tools as part of its process.

> [!INFO]
> You can install the smaller CLT package without the full, multi-gigabyte Xcode IDE by running the command `xcode-select --install` in your terminal. This is the most common and recommended approach for most developers who just need command-line tools.

Once the Xcode CLT is available, the following command installs Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Let's install now Python 3, Pip, Pipx, Wget, OpenSSL and Git.

```bash
brew install python3
brew install pipx
brew install wget
brew install openssl
brew install git
```

At this point, it is recommended to reboot the system. In some cases, `wget` does not work properly without a reboot and therefore cannot establish SSL connections.

### Main Installation

Now, we can start with the installation of the pentest tools. Let's start with the GUI applications:
```bash
brew install burp-suite
brew install owasp-zap
brew install ghidra
brew install wireshark
```

Continue with the kali-linux-top10 metapackage applications and more:
```bash
brew install nmap
brew install gobuster
brew install nikto
brew install wpscanteam/tap/wpscan
brew install metasploit
brew install exploitdb
brew install hashcat
brew install samba
brew install binwalk
brew install exiftool
brew install aircrack-ng
brew install hydra
brew install sqlmap
```

Similar to Hashcat, John the Ripper (often simply referred to as 'John') is a powerful tool for cracking passwords.

Installing John the Ripper via Homebrew is very convenient, but it has some disadvantages under macOS:

1. Only the `john` binary is installed with the main Homebrew package, which means that important scripts like `ssh2john` or `zip2john` are missing. These are only included in the John the Ripper jumbo package.
2. The `john` binary only runs on one core and does not support multicore. The reason for this is the lack of OpenMP support. If we want to use `john` with multicore, we have to compile it locally with OpenMP support from source. This [article](https://medium.com/@seitzmanuel/how-to-compile-john-the-ripper-on-mac-osx-with-openmp-support-multicore-big-sur-a60cad850b7d) provides details on how to do that.

If you don't want/need multicore and want the main binary with the extra utilities, it is better install the "jumbo" package:
```bash
brew install john-jumbo
```

A couple of enumeration tools are not available in Homebrew:

* **SMBMap:** a Python script that allows users to enumerate samba share drives across an entire domain.
* **Enum4linux:** a Perl-based tool used for enumerating information from Windows and Samba systems.

To install SMBMap:

1. Clone the repository to Homebrew's directory:
    ```bash
    git clone https://github.com/ShawnDEvans/smbmap.git /usr/local/Cellar/smbmap
    ```
2. Install Python package requirements:
    ```bash
    pip3 install impacket pyasn1 pycryptodome termcolor
    ```
3. Create a symbolic link:
    ```bash
    ln -s /usr/local/Cellar/smbmap/smbmap.py /usr/local/bin/smbmap
    ```

To install Enum4linux:

1. Clone the repository to Homebrew's directory:
    ```bash
    git clone https://github.com/CiscoCXSecurity/enum4linux.git /usr/local/Cellar/enum4linux
    ```
2. Create a symbolic link:
    ```bash
    ln -s /usr/local/Cellar/enum4linux/enum4linux.pl /usr/local/bin/enum4linux
    ```

### Wordlists

Let's install the popular kali linux wordlists under `/usr/local/share`.
```bash
git clone https://github.com/3ndG4me/KaliLists.git /usr/local/share/wordlists && gzip -d /usr/local/share/wordlists/rockyou.txt.gz

wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O /tmp/master.zip ; unzip /tmp/master.zip -d /tmp ; mv /tmp/SecLists-master /tmp/seclists ; mv /tmp/seclists /usr/local/share/
```

### Additional Tools

There are several tools for privilege escalation and enumeration:

* **Chisel:** a fast, open-source TCP/UDP tunnel tool written in Go (Golang).
* **PEASS-ng (Privilege Escalation Awesome Scripts - Next Generation):** a suite of automated security auditing tools designed to help penetration testers and ethical hackers identify and exploit local privilege escalation (privesc) paths on Windows, Linux, and macOS systems.
* **LinEnum:** a widely used, comprehensive bash script designed for local Linux privilege escalation and system enumeration.
* **LSE (Linux Smart Enumeration):** a shell script that shows relevant information about the security of the local Linux system, helping to escalate privileges.
* **Pspy:** a command-line Linux tool for monitoring processes without root permissions, commonly used in post-exploitation for privilege escalation.
* **PowerUp:** a PowerShell tool (part of the PowerSploit collection, often used within the PowerShell Empire framework) designed to assist with local privilege escalation on Windows systems.
* **JAWS (Just Another Windows (Enum) Script):** a PowerShell script designed for penetration testers and CTF players to quickly identify potential privilege escalation vectors on Windows systems.
* **PrintSpoofer:** a privilege escalation tool used in CTF competitions and penetration testing to gain `NT AUTHORITY\SYSTEM` privileges on Windows machines.

Below are other useful tools:

* **Token Breaker:** a script focused on 2 particular vulnerabilities related to JWT tokens: None Algorithm and RSAtoHMAC.
* **JWT cracker:** a multi-threaded JWT brute-force cracker written in C.
* **Hash Identifier:** a command-line tool to identify the algorithm used to create a specific hash (e.g., MD5, SHA-1, SHA-256).
* **LinkFinder:** a Python script written to discover endpoints and their parameters in JavaScript files.

All of these can be installed in one central location.

At this point, the system should have all the basic tools for playing some CTF games.
