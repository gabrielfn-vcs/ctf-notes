'''
The third riddle
"In the eerie silence of this Halloween night, a cryptic clue takes flight. I'm not a specter, nor a pumpkin's glow, but a duo of tools in the cryptographer's show.

First, a system of eight, a numerical state.
Next, I'm a cipher with a spectral key, a Frenchman's name for this cipher's fame.

Decipher me if you dare, for I am the cryptographer's affair."

The answer:
"A round of witch's brew to you for solving this enigma! ThA cauldron bubbles and reveals your bewitching brew: WITCHESBREW."
'''

def octal_to_ascii(octal_string: str):
    # Split the string into individual octal numbers
    octal_numbers = octal_string.split()
    
    # Convert each octal number to decimal and then to ASCII character
    ascii_characters = [chr(int(oct_num, 8)) for oct_num in octal_numbers]
    
    # Join the characters into a single string
    decoded_string = ''.join(ascii_characters)
    
    return decoded_string

# None of the algorithms I found work. I used the CyberChef online tool to decrypt the ASCII string
def extend_key(msg, key):
    key = list(key)
    if len(msg) == len(key):
        return key
    else:
        for i in range(len(msg) - len(key)):
            key.append(key[i % len(key)])
    return "".join(key)

def vigenere_decrypt(msg, key):
    decrypted_text = []
    key = extend_key(msg, key)
    for i in range(len(msg)):
        char = msg[i]
        if char.isupper():
            decrypted_char = chr((ord(char) - ord(key[i]) + 26) % 26 + ord('A'))
        elif char.islower():
            decrypted_char = chr((ord(char) - ord(key[i]) + 26) % 26 + ord('a'))
        else:
            decrypted_char = char
        decrypted_text.append(decrypted_char)
    return "".join(decrypted_text)


# Given octal text
OCTAL_TEXT = "107 40 171 143 155 147 152 40 166 164 40 157 142 172 152 166 47 153 40 165 170 154 153 40 154 150 40 145 166 151 40 170 150 170 40 172 143 144 157 157 165 165 40 154 141 157 172 40 163 146 142 155 164 157 41 40 114 141 107 40 152 157 155 145 152 171 143 146 40 165 141 151 160 144 170 171 40 150 142 166 40 153 153 143 163 163 145 171 40 146 143 155 153 40 150 154 153 141 155 151 157 167 146 172 40 150 171 163 157 72 40 120 117 101 121 132 130 131 111 106 127 120 56"

# 1. Decode the octal text into an ASCII string
ascii_string = octal_to_ascii(OCTAL_TEXT)
print(ascii_string)

# 2. Decrypt the ASCII string using the Vigenère cipher

# The Vigenère keyword
KEYWORD = "GHOST"

# Decrypt the message
decrypted_message = vigenere_decrypt(ascii_string, KEYWORD)
print(decrypted_message)
