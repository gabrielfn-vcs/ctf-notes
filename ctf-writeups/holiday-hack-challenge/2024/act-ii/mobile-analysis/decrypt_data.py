from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from base64 import b64decode
import re

# Initialization Vector
iv = b64decode("Q2hlY2tNYXRlcml4")
# Encrypted Key
ek = b64decode("rmDJ1wJ7ZtKy3lkLs6X9bZ2Jvpt6jL6YWiDsXtgjkXw=")

# Encrypted SQL query (Base64 Encoded)
encrypted_sql_query = "IVrt+9Zct4oUePZeQqFwyhBix8cSCIxtsa+lJZkMNpNFBgoHeJlwp73l2oyEh1Y6AfqnfH7gcU9Yfov6u70cUA2/OwcxVt7Ubdn0UD2kImNsclEQ9M8PpnevBX3mXlW2QnH8+Q+SC7JaMUc9CIvxB2HYQG2JujQf6skpVaPAKGxfLqDj+2UyTAVLoeUlQjc18swZVtTQO7Zwe6sTCYlrw7GpFXCAuI6Ex29gfeVIeB7pK7M4kZGy3OIaFxfTdevCoTMwkoPvJuRupA6ybp36vmLLMXaAWsrDHRUbKfE6UKvGoC9d5vqmKeIO9elASuagxjBJ"


# AES-GCM-NoPadding Decryption
def decrypt_data(b64_encrypted_data: str):
    decrypted_data = ""
    print(f"\n[!] Decrypting: {b64_encrypted_data}")
    try:
        decrypted_data = AESGCM(ek).decrypt(iv, b64decode(b64_encrypted_data), None).decode('utf-8')
        print(f"[+] Decrypted Data (UTF-8): {decrypted_data}")
    except Exception as e:
        print(f"[-] Decryption failed: {e}")
    return decrypted_data


def main():
    # Decrypt the SQL query
    decrypted_sql_query = decrypt_data(encrypted_sql_query)
    if not decrypted_sql_query:
        print("[-] Failed to decrypt SQL query")
        return

    # Extract the encrypted name from the SQL query (Base64 Encoded)
    match = re.search(r"Item\s*=\s*'([^']+)'", decrypted_sql_query)
    if not match:
        print("[-] Could not extract encrypted name")
        return
    encrypted_name = match.group(1)
    # encrypted_name = re.search(r"Item\s*=\s*'([^']+)'", decrypted_sql_query).group(1)

    # Decrypt the name
    decrypted_name = decrypt_data(encrypted_name)
    if not decrypted_name:
        print("[-] Failed to decrypt name")
        return

    print(f"\n[+]The answer is: {decrypted_name}")


if __name__ == "__main__":
    main()
