import base64
import sys


file = sys.argv[1]
key = sys.argv[2]

with open(file,'rb') as input:
    data = base64.b64encode(input.read())

key_hex = key.encode('utf-8').hex()
key_bytes = [key_hex[i:i+2] for i in range(0, len(key_hex), 2)]
key_size = 8

data_hex = base64.b64decode(data).hex()
data_bytes = [data_hex[i:i+2] for i in range(0, len(data_hex), 2)]

encrypted = ''
i = 0
for byte in data_bytes:
    i = i % key_size
    xored = bin(int(byte,16)^int(key_bytes[i],16))
    hex_str = '{:02x}'.format(int(xored, 2))
    encrypted = encrypted + hex_str
    i += 1

print(encrypted)

