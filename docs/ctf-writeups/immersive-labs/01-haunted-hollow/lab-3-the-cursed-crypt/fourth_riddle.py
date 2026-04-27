"""
The fourth riddle
"In the chilling darkness of this Halloween night, a cryptic clue takes flight. Not a specter, nor a witch's delight, but a quartet of tools in the cryptographer's sight.

First, I transform to a base of thirty-two, a more complex view.
Next, I'm a conversion to a system of sixteen in the coder's routine.
Then, I'm a conversion to a base of ten, a system known to many.
Lastly, I'm an operation of exclusive disjunction, a bitwise function.

Decode me if you dare, for I am the cryptographer's scare."

The answer:
"Kudos to you, cryptic explorer The candles glow illuminates your lantern's lore: PUMPKIN."
"""

import base64

# Input Base32 encoded message
encoded_message = "GM3DGNZSGAZTCMZSGM2TEMBTGEZTAMZYGIYDGMJTGAZTGMRQGMYTGMRTGMZDAMZUGMYDEMBTGEZTEMZUGIYDGMJTGAZTGMRQGM2DGMBSGAZTCMZRGMZTEMBTGEZTAMZTGIYDGMJTGIZTKMRQGMZTGNRSGAZTIMZQGIYDGMJTGAZTOMRQGMYTGMRTGIZDAMZRGMYTGMZSGAZTCMZSGMYDEMBTGEZTEMZUGIYDGOJTG4ZDAMZRGMYDGNZSGAZTIMZQGIYDGMJTGAZTSMRQGMYTGMJTGIZDAMZRGMZDGMBSGAZTCMZQGMYDEMBTGEZTAMZTGIYDGMJTGIZTEMRQGMYTGMBTHEZDAMZRGMZDGMRSGAZTIMZQGIYDGOJTGIZDAMZZGM3DEMBTGEZTAMZZGIYDGNBTGAZDAMZRGMYDGNZSGAZTCMZQGM2TEMBTGEZTAMZSGIYDGMJTGAZTQMRQGMYTGMBTGAZDAMZRGMYDGOJSGAZTCMZSGMZTEMBTGQZTAMRQGMYTGMJTGEZDAMZRGMYDGMBSGAZTCMZQGMZTEMBTGEZTEMZXGIYDGNBTGAZDAMZZGM3TEMBTGEZTAMZQGIYDGMJTGAZTAMRQGMYTGMRTGUZDAMZRGMYDGMJSGAZTSMZXGIYDGMJTGAZTEMRQGMYTGMBTGUZDAMZRGMZDGNBSGAZTCMZQGM4TEMBTGEZTEMZTGIYDGNBTGAZDAMZRGMYTGMZSGAZTCMZQGMZTEMBTGEZTEMZVGIYDGMJTGIZTEMRQGM2DGMBSGAZTCMZQGMYDEMBTGEZTAMZVGIYDGMJTGAZTEMRQGMYTGMRTGQZDAMZRGMYDGOJSGAZTCMZSGMZDEMBTGEZTAMZSGIYDGNBTG4ZDAMZRGMZDGMZSGAZTIMZQGIYDGMJTGAZTAMRQGMYTGMBTGMZDAMZRGMZDGMRSGAZTCMZQGM4TEMBTGUZTAMRQGM2DGMBSGAZTQMZYGIYDGOJTGMZDAMZWGM4TEMBTHAZTQMRQGM3DGNZSGAZTMMZVGIYDGNZTGAZDAMZTGM4A===="


def xor_with_key(values: list[int], key: int):
    # """XOR each byte in the byte array with the given key."""
    # return bytes(b ^ key for b in byte_array)
    """Apply XOR on each value with the given key, e.g., character (decimal value)"""
    return bytes(value ^ key for value in values)

def is_printable(byte_array: bytes):
    """Check if the byte array consists of printable ASCII characters."""
    return all(32 <= b <= 126 for b in byte_array)


def brute_force_xor(text: str):
    # Convert the text message into its ASCII decimal values
    decimal_values = [ord(char) for char in text]

    """Try all possible single-byte keys to decrypt the decimal values."""
    for key in range(256):  # Try every possible byte value (0x00 to 0xFF)
        xor_result_as_bytes = xor_with_key(decimal_values, key)

        # Check if the result is printable
        if is_printable(xor_result_as_bytes):
            print(f"Key: {key:02d}, Decrypted: {xor_result_as_bytes.decode('utf-8', 'ignore')}")


# Show original encoded message
print(f"Encoded Message: {encoded_message}")

# Apply the transformations
# Step 1: Base32 decoding
byte_values = base64.b32decode(encoded_message).decode("utf-8", errors="ignore")
print(f"Base32 Byte Values: {byte_values}")

# Step 2: Hexadecimal conversion (from the decoded result)
hex_values = [int(byte_values[i : i + 2], 16) for i in range(0, len(byte_values), 2)]
print(f"Hexadecimal Values: {hex_values}")

# Step 3: Decimal conversion
# Ensure the hex values length is even
if len(hex_values) % 2 != 0:
    raise ValueError("Hexadecimal message length must be even")
# Convert each value to a character and join them to form a string
decimal_values = ''.join(chr(value) for value in hex_values)
print(f"Decimal Values: {decimal_values}")

# Decimal conversion into a text message
text_message = ''.join(chr(int(value)) for value in decimal_values.split())
print(f"From Decimal to Text: {text_message}")

# Step 4: Brute Force XOR to determine the encoded message
brute_force_xor(text_message)
