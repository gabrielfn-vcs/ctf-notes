#!/usr/bin/env bash

read -p "Enter the passphrase to test: " p

#p="sweetfizzyriver"

cmd="gpg --batch --pinentry-mode loopback --passphrase ${p} -d QC_export.txt.gpg"
echo ${cmd}
${cmd}

