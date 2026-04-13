#!/usr/bin/env python3

import string

"""
Paswword policy:
* only letters and symbols
* one capital letter
* one symbol

Special rule:
* the eleventh character must be capitalized
"""

#def matches(p):
#    if not p: return False
#    # Ignore any entry with a number
#    if any(c.isdigit() for c in p): return False
#    # Ignore any entry without a symbol
#    if sum(1 for c in p if c in symbols_set) < 1: return False
#    # Ignore any entry without a capital letter
#    #if sum(1 for c in p if c.isupper()) < 1: return False
#    return True
#
#ifname="rockyou.txt"
#ofname="filtered.txt"
#with open(ifname,'rb') as f, open(ofname,'w') as o:
#    for line in f:
#        try:
#            p = line.decode('utf-8').strip()
#            if matches(p): o.write(p+'\n')
#        except: pass
#
#print(f"Finished filtering the wordlist according to the password policy. Output in {ofname}")

INPUT_FILE = "rockyou.txt"
OUTPUT_FILE = "filtered.txt"

digits = set(string.digits)
letters = set(string.ascii_letters)
symbols = set(string.printable) - letters - digits
#symbols = set(string.punctuation) | {' '}

def validate_and_transform(word: str) -> str | None:
    # Strip newline and surrounding whitespace
    word = word.rstrip("\n")

    # Rule 1: word cannot be null
    if not word:
        return None

    # Rule 2: must have at least 11 characters
    if len(word) < 11:
        return None

    # Rule 3: cannot contain a number
    if any(c in digits for c in word):
        return None

    # Rule 4: must contain at least one symbol (space counts)
    if not any(c in symbols for c in word):
        return None

    # Rule 5: capitalize the 11th character if needed
    if not word[10].isupper():
        word = word[:10] + word[10].upper() + word[11:]

    return word


def main():
    seen = set()
    kept = 0

    with open(INPUT_FILE, "r", encoding="latin-1", errors="ignore") as infile, \
         open(OUTPUT_FILE, "w", encoding="utf-8") as outfile:

        for line in infile:
            transformed = validate_and_transform(line)
            if transformed and transformed not in seen:
                seen.add(transformed)
                outfile.write(transformed + "\n")
                kept += 1

    print(f"[+] Finished. {kept} passwords written to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
