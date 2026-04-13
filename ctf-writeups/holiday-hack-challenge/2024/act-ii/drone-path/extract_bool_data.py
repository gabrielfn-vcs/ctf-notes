import csv

def extract_booleans_and_convert_to_binary_string(input_file, output_binary_file):
    with open(input_file, 'r') as infile:
        csv_reader = csv.reader(infile)

        # Extract and process all rows
        binary_data = []
        for row in csv_reader:
            # Convert TRUE to 1 and FALSE to 0, then append to the list
            binary_data.extend([1 if value == 'TRUE' else 0 for value in row if value in ('TRUE', 'FALSE')])

    # Join the list of 1s and 0s into a single string
    binary_string = ''.join(map(str, binary_data))

    # Write the binary string to the output file
    with open(output_binary_file, 'w') as outfile:
        outfile.write(binary_string)
    print(f"Binary string written to file {output_binary_file}.")

    return binary_string


def binary_to_ascii(binary_string, oputput_ascii_file):
    # Split the binary string into chunks of 8 bits
    #binary_values = [binary_string[i:i+8] for i in range(0, len(binary_string), 8)]

    # Convert each 8-bit chunk to a character
    #ascii_text = ''.join([chr(int(bv, 2)) for bv in binary_values if len(bv) == 8])

    # Convert every 8 bits to a character
    ascii_text = ''.join(chr(int(binary_string[i:i+8], 2)) for i in range(0, len(binary_string), 8))

    # Write the ASCII message to the output file
    with open(output_ascii_file, 'w') as outfile:
        outfile.write(ascii_text)
    print(f"Decoded ASCII message written to file {output_ascii_file}.")

    return ascii_text

# Input CSV file
input_csv = 'ELF-HAWK-dump.csv'
# Output bianry file
output_binary_file = 'output_binary.txt'
# Output ASCII file
output_ascii_file = 'output_ascii.txt'

# Get the binary string
binary_string = extract_booleans_and_convert_to_binary_string(input_csv, output_binary_file)

# Get the ASCII text
ascii_text = binary_to_ascii(binary_string, output_ascii_file)
print(f"Decoded ASCII message: {ascii_text}")


