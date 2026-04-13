import subprocess
import itertools
import time

# Option 1: Assume all five digits of the first code are used in the second code.
# Define the digits to use
# Generate all possible 5-digit combinations (with repetitions)
digits = ['7', '2', '6', '8', '2']
combinations = itertools.permutations(digits)

# Option 2: Assume all five digits of the first code are used in the second code.
# Define the digits to use
# Generate all possible 5-digit combinations (with repetitions)
# digits = ['7', '2', '6', '8']
# combinations = itertools.product(digits, repeat=5)

# Define the URL for the curl request
url = "https://hhc24-frostykeypad.holidayhackchallenge.com/submit"

# Loop through each combination and test it using curl
for combination in combinations:
    # Join the tuple into a string to form the 5-digit code
    code = ''.join(combination)
    
    # Create the curl command
    curl_command = [
        'curl', '-X', 'POST', url,
        '-H', 'Content-Type: application/json',
        '-d', f'{{"answer":"{code}"}}'
    ]
    
    # Run the curl command
    response = subprocess.run(curl_command, capture_output=True, text=True)

    # Check the response
    if response.returncode == 0 and "success" in response.stdout:
        print(f"\nSuccess: {code}")
        #break  # Exit the loop once a successful code is found
    elif "error" in response.stdout:
        #print(f"Failed: {code} - {response.stdout.strip()}")
        print(".", end="", flush="True")

    # The server response will be something like this:
    # 22222 400 {'error': "The data you've provided seems to have gone on a whimsical adventure, losing all sense of order and coherence!"}
    # 22227 400 {'error': "The data you've provided seems to have gone on a whimsical adventure, losing all sense of order and coherence!"}
    # 22226 429 {'error': 'Too many requests from this User-Agent. Limited to 1 requests per 1 seconds.'}
    # We can set the User-Agent header to something unique per request to avoid rate limiting, but for now, we'll just wait between requests.
    time.sleep(1)
