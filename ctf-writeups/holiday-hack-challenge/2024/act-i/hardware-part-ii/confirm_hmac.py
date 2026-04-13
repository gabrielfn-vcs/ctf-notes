import hmac
import hashlib

'''
From the DB:
> PRAGMA table_info('access_cards');
0|id|INTEGER|0||1
1|uuid|TEXT|0||0
2|access|INTEGER|0||0
3|sig|TEXT|0||0

> PRAGMA table_info('config');
0|id|INTEGER|0||1
1|config_key|TEXT|0||0
2|config_value|TEXT|0||0

> SELECT * FROM access_cards WHERE id = 42;
42|c06018b6-5e80-4395-ab71-ae5124560189|0|ecb9de15a057305e5887502d46d434c9394f5ed7ef1a51d2930ad786b02f6ffd

> SELECT * FROM config;
1|hmac_secret|9ed1515819dec61fd361d5fdabb57f41ecce1a5fe1fe263b98c0d6943b9b232e
2|hmac_message_format|{access}{uuid}
3|admin_password|3a40ae3f3fd57b2a4513cca783609589dbe51ce5e69739a33141c5717c20c9c1
4|app_version|1.0

Input String:
Based on the hmac_message_format, the input is: {access}{uuid}
For ID 42, access is 0 and uuid is c06018b6-5e80-4395-ab71-ae5124560189.
The input becomes: 0c06018b6-5e80-4395-ab71-ae5124560189
'''

#secret = bytes.fromhex("9ed1515819dec61fd361d5fdabb57f41ecce1a5fe1fe263b98c0d6943b9b232e")
secret = "9ed1515819dec61fd361d5fdabb57f41ecce1a5fe1fe263b98c0d6943b9b232e".encode("utf-8")


def generate_hmac(access, uuid):
    message = f"{access}{uuid}".encode()
    print(f"Using input: {message}")

    new_hmac = hmac.new(secret, message, hashlib.sha256).hexdigest()
    return new_hmac

access = 0
uuid = "c06018b6-5e80-4395-ab71-ae5124560189"
current_hmac = generate_hmac(access, uuid)
print("Generated HMAC:\t", current_hmac)

expected_hmac='ecb9de15a057305e5887502d46d434c9394f5ed7ef1a51d2930ad786b02f6ffd'
print("Expected HMAC:\t", expected_hmac)

if current_hmac == expected_hmac:
    print("Values are the same!")
else:
    print("Values are NOT the same!")

access = 1
uuid = "c06018b6-5e80-4395-ab71-ae5124560189"
updated_hmac = generate_hmac(access, uuid)
print("Updated HMAC:\t", updated_hmac)

