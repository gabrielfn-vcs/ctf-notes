'''
The first riddle:
"On this eerie Halloween night, a cryptic clue takes flight. I'm not a witch, nor a black cat's hiss, but a trio of tools in the cryptographer's abyss.

First, I'm a code of six and four, used in data lore.
Next, I'm a compressor's release, where file sizes cease.
Lastly, I'm a system of sixteen, in the coder's routine.

Unravel me if you can, for I am the cryptographer's plan."

The answer:
"Well done, brave soul, you've cracked the code! The ghostly whisper in the wind reveals your spectral secret: GHOST."
'''
import zlib
import base64

# The encoded text provided
ENCODED_TEXT = "H4sIACDaJ2UA/12P/bGDMAzDV9EIkDg2jNNysP8ISHZa3utd/gg/FH2MgA/4odMWuMEv+CnYijREg68IT7ggujSRr0oT+yQtHpn3+ZAXf2eKpZgR26NRHAk/V5Hx9y+78U5nWpEfCpJD8T05ZUNB0rPG+RshcfKZzkrUZ0l1o2f/N6Gsvs5aYZ8hNZadi5eVob/ELWAb7MLoWtHOG8fDXR1bAQAA"

# 1. Decode the base64 encoding
decoded_base64 = base64.b64decode(ENCODED_TEXT)

# 2. Decompress the zlib compression
decompressed_data = zlib.decompress(decoded_base64, 16+zlib.MAX_WBITS)

# 3. Get the hex values
hex_string = decompressed_data.decode("utf-8")

# Remove spaces
hex_string = hex_string.replace(" ", "")

# Convert hex to bytes and decode to string
decoded_message = bytes.fromhex(hex_string).decode('utf-8')

# Output the result
print(decoded_message)
