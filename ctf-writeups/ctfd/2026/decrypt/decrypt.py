#!/usr/bin/env python3

import subprocess

passphrase = "sweetfizzyriver"
gpg_file = "QC_export.txt.gpg"

# Attempt decryption
print(f"\n[!] Using Passphrase: \"{passphrase}\" to decrypt [{gpg_file}]")
proc = subprocess.Popen(
    ['gpg', '--batch', '--yes', '--passphrase', passphrase, '-d', gpg_file],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE
)
stdout, stderr = proc.communicate()

if proc.returncode == 0:
    print(f"[+] SUCCESS! Contents of Decrypted File:")
    print(stdout.decode())
else:
    print(f"[-] FAILURE!")

