import itertools
import base64
import sys

def decrypt_message(encrypted_hex, key):
    # Convert key to its hex representation
    key_bytes = [ord(k) for k in key]
    key_size = len(key_bytes)
    
    # Convert the encrypted data from hex to bytes
    ciphertext = bytes.fromhex(encrypted_hex)
    
    # XOR the key with the encrypted bytes to decrypt the content
    decrypted = []
    for i, byte in enumerate(ciphertext):
        decrypted_byte = byte ^ key_bytes[i % key_size]
        decrypted.append(decrypted_byte)
    
    # Decode as Base64 and return
    return bytes(decrypted).decode('utf-8', errors='replace')

# Another way of doing the same
def decrypt_file(file_content, key):
    # Convert key to its hex representation
    key_hex = key.encode('utf-8').hex()
    key_bytes = [key_hex[i:i+2] for i in range(0, len(key_hex), 2)]
    key_size = len(key_bytes)
    
    # Convert the file content from hex to bytes
    data_bytes = [file_content[i:i+2] for i in range(0, len(file_content), 2)]

    decrypted = bytearray()
    for i, byte in enumerate(data_bytes):
        xored = int(byte, 16) ^ int(key_bytes[i % key_size], 16)
        decrypted.append(xored)
    
    # Decode as Base64 and return
    return bytes(decrypted).decode('utf-8', errors='replace')


# Generate all case permutations of the given word
def generate_case_permutations(word):
    return map(''.join, itertools.product(*([c.lower(), c.upper()] for c in word)))


if __name__ == '__main__':
    # Read the encrypted content from the file
    encrypted_file_path = sys.argv[1]
    with open(encrypted_file_path, 'r') as file:
        encrypted_file_content = file.read().strip()

    # Get a key from the command line or create a few to test
    try:
        key = sys.argv[2]
        print(decrypt_message(encrypted_file_content, key))
    except Exception:
        keys = generate_case_permutations("parellus")
        for key in keys:
            print(f"Trying key: {key}")
            print(f"{encrypted_file_path}: {decrypt_message(encrypted_file_content, key)}")
            print("-" * 50)

