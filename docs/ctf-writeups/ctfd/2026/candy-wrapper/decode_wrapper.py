#!/usr/bin/env python3

"""
Candy Wrapper Espionage, Hidden Command Channel

Data flutters across the wire, each one tiny and unremarkable—like sugar crystals falling through the air. Together, though, they form a pattern—precise and intentional.

An Oompa Loompa squints at the screen. "That's not curiosity," he mutters. "That's conversation."

Task: Extract the hidden message being sent to the Command and Control server

Download: c2_server_packets.pcap
"""

import base64

"""
Looking at the DNS entries in the given PCAP file, there are a few suspicious subdomains under sweetinfo.net.

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

These strings were extracted from the DNS subdomains, i.e., [BASE64].sweetinfo.net

Running the strings through a Base64 decoder shows that the first one (TVNHMDAwMEFHRU5UIEFDVEl) is a readable string "MSG0000AGENT ACTIVE.", but the reamining ones are garbled.

This usually points to a rolling XOR cipher.
"""
encoded_subdomains = [
    "TVNHMDAwMEFHRU5UIEFDVElWRS4", # P0
    "MVRHVENdUEJFWF9WMVZeU0JFXkE", # P1
    "cmdwAmRtcG93bmMCY2Fzd2twZ2Y", # P2
    "HRNnYXJ9YH56Z2d6fXQTd3JnchM", # P3
    "EAtkBwsJCQUKAGQXARYSARZqZAk", # P4
    "HAYGHBobdRYaGAUZEAEQew"       # P5
]

def get_english_score(data: bytes):
    """
    Heuristic scoring function to evaluate how much the given data byte array looks like English text.
    Scores the bytes in the array based on common English patterns and printable characters.
    This 'Frequency Analysis' mimics the way a human recognizes patterns.
    Malware analysts use this to find keys automatically.
    """
    score = 0
    for b in data:
        # High points for letters and spaces
        if ord('a') <= b <= ord('z') or ord('A') <= b <= ord('Z'):
            score += 10
        if b == ord(' '):
            score += 12
        # Moderate points for numbers and common punctuation
        if ord('0') <= b <= ord('9') or b in b'._!':
            score += 5
         # Heavy penalty for non-printable bytes (0-31 or 127-255), e.g., control characters
        if b < 32 or b > 126:
            score -= 20
    return score

def final_candy_unwrapper():
    """
    The challenge description hints towards a wrapper and a "sugar crystal" pattern
    indicating the wrapper itself may be incrementing by a value with every packet.
    This function decodes the rotating XOR cipher by testing 256 possible 'wrappers' 
    per packet and picking the one that results in the highest English score.
    """

    # Initialize the full message string
    full_message = ""

    # Output header
    print(f"{'Pkt':<4} | {'Index':<6} | {'Wrapper':<8} | {'Resulting Key':<13} | {'Base64 Input':<28} | {'Decrypted String'}")
    print("-" * 105)
    


    for i, s in enumerate(encoded_subdomains):
        # 1. FIX PADDING: Base64 strings must be multiples of 4.
        # If the string isn't long enough, we add '=' signs to the end.
        missing_padding = len(s) % 4
        if missing_padding:
            s += '=' * (4 - missing_padding)

        # Convert Base64 ASCII back into raw bytes
        raw_bytes = base64.b64decode(s)

        # Initialize 'best' scores
        best_wrapper = 0
        best_score = -float('inf')
        best_decoded = ""

        # 2. BRUTE FORCE: Try every possible 1-byte 'Wrapper' (0x00 to 0xFF) for THIS specific packet.
        # This is the 'squinting' process to see which key 'unwraps' the message.
        # In this challenge, we will discover the wrapper increments by 0x10 for every packet.
        for wrapper_candidate in range(256):
            # THE CRYPTOGRAPHIC PATTERN:
            # The Key is the Packet Index (rolling) XORed with the Wrapper Candidate (the layer or flavor)
            # Key = Index ^ Wrapper
            key = i ^ wrapper_candidate

            # Perform the bytewise XOR flip on every byte in the packet
            # (Scrambled Byte) ^ (Key) = (Original Byte)
            decrypted_bytes = bytes([b ^ key for b in raw_bytes])

            # Score this specific result using the English frequency rules
            # to determine how 'human-readable' ths specific result is
            score = get_english_score(decrypted_bytes)

            # If this is the most readable result yet, then save it as the winner
            if score > best_score:
                best_score = score
                best_wrapper = wrapper_candidate
                # Format for display: replace non-printables bytes with dots
                best_decoded = "".join([chr(b) if 32 <= b <= 126 else "." for b in decrypted_bytes])

        # 3. LOGGING: Calculate the final key used and display the row in our analysis table
        # showing the mathematical progression we found
        key_used = i ^ best_wrapper
        print(f"{i:<4} | {i:<6} | {hex(best_wrapper):<8} | {hex(key_used):<13} | {s:<28} | {best_decoded}")

        # 4. REASSEMBLY: Stitch the discovered message parts together
        full_message += best_decoded

    # Remove any remaining padding and print the final reasslembled message
    print("\n--- THE REASSEMBLED MESSAGE ---")
    print(full_message.strip())

if __name__ == "__main__":
    final_candy_unwrapper()
    """
OUTPUT:
Pkt  | Index  | Wrapper  | Resulting Key | Base64 Input                 | Decrypted String
---------------------------------------------------------------------------------------------------------
0    | 0      | 0x0      | 0x0           | TVNHMDAwMEFHRU5UIEFDVElWRS4= | MSG0000AGENT ACTIVE.
1    | 1      | 0x10     | 0x11          | MVRHVENdUEJFWF9WMVZeU0JFXkE= |  EVERLASTING GOBSTOP
2    | 2      | 0x20     | 0x22          | cmdwAmRtcG93bmMCY2Fzd2twZ2Y= | PER FORMULA ACQUIRED
3    | 3      | 0x30     | 0x33          | HRNnYXJ9YH56Z2d6fXQTd3JnchM= | . TRANSMITTING DATA 
4    | 4      | 0x40     | 0x44          | EAtkBwsJCQUKAGQXARYSARZqZAk= | TO COMMAND SERVER. M
5    | 5      | 0x50     | 0x55          | HAYGHBobdRYaGAUZEAEQew==     | ISSION COMPLETE.

--- THE REASSEMBLED MESSAGE ---
MSG0000AGENT ACTIVE. EVERLASTING GOBSTOPPER FORMULA ACQUIRED. TRANSMITTING DATA TO COMMAND SERVER. MISSION COMPLETE.

ANALYSIS:
Look at the Wrapper column in the final output: 0x00, 0x10, 0x20, 0x30, 0x40, 0x50.

This reveals the true "Sugar Crystal" pattern the Oompa Loompa was talking about.
It wasn't just a rolling index; the Wrapper itself was incrementing by $0x10$ (16) with every packet.

The final "Crystal" logic, the attacker used was a nested mathematical sequence for the XOR keys:

Key = Packet Index XOR (Packet Index X 16)

This is a clever way to ensure that even if a security tool identifies the pattern of the first two packets,
the key for the next packet would be completely different and seemingly unrelated.

LEARNING:
* The "MSG" Anchor: Always look for common protocol headers (MSG, HTTP, GET, POST) to find your first XOR key.
* Linear Growth: If the keys look like 0x11, 0x22, 0x33, you are dealing with a mathematical progression.
* DNS Exfiltration: When you see long, random subdomains in a .pcap, it is almost always Base64 or Hex-encoded data being "leaked" out of a network.
"""
