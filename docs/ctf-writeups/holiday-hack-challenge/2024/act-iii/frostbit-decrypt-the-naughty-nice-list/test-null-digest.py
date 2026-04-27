from FrostBiteHashlib import Frostbyte128

# Predictble target digest with malicious input
target_digest = "00000000000000000000000000000000"

# Known values
status_id = "X4idel4PySg"
nonce = "87387891bf7e2f3e"

# Get the nonce bytes
nonce_bytes = bytes.fromhex(nonce)

# Generate malicious filename_bytes to cancel out the XOR
# Repeat nonce to reach desired length of 16 bytes
filename_bytes = nonce_bytes * 2

# Compute the hash
# The file_bytes should be irrelevant
hasher = Frostbyte128(file_bytes=status_id.encode(), filename_bytes=filename_bytes, nonce_bytes=nonce_bytes)
computed_digest = hasher.hexdigest()

# Computed digest should always be zeroes regardless of file content
print(f"Target Digest  : {target_digest}")
print(f"Computed Digest: {computed_digest}")
assert computed_digest == target_digest, "Digest mismatch!"
