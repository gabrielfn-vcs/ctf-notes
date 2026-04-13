'''
The second riddle
"In the shadowy depths of this All Hallows' Eve, a cryptic puzzle we weave. Not a specter, nor a ghoul's mischieve, but a trio of steps for you to achieve.

First, a system of dots and dashes, used in telegraphic flashes.
Next, a transformation to code, where characters are bestowed.
Finally, a cipher of thirteen's rotation, a simple form of obfuscation.

Unravel this riddle if you dare, in this cryptographer's haunted lair."

The answer:
"Congratulations, fearless cryptographer! The spirits have spoken, and your unearthly revelation emerges from the shadows: SPECTER."
'''
import codecs

# Define the Morse code dictionary.
MORSE_CODE_DICT = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.', 'H': '....',
    'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---', 'P': '.--.',
    'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..', '0': '-----', '1': '.----', '2': '..---', '3': '...--', '4': '....-',
    '5': '.....', '6': '-....', '7': '--...', '8': '---..', '9': '----.', '.': '.-.-.-', ',': '--..--',
    '?': '..--..', "'": '.----.', '!': '-.-.--', '/': '-..-.', '(': '-.--.', ')': '-.--.-', '&': '.-...',
    ':': '---...', ';': '-.-.-.', '=': '-...-', '+': '.-.-.', '-': '-....-', '_': '..--.-', '"': '.-..-.',
    '$': '...-..-', '@': '.--.-.', ' ': '/'
}

def from_morse_code(morse_text: str, sep: str=' '):
    '''Convert a Morse code sequence to a message.'''
    # Split the input by the given separator to handle the given format
    morse_chars = morse_text.split(sep)

    message = ''
    for code in morse_chars:
        print(f'Checking code {code}')
        for char, morse in MORSE_CODE_DICT.items():
            if morse == code:
                message += char

    return message

def main():
    ENCODED_TEXT = "..... -----:-.... ..---:-.... .----:--... ....-:-.... .....:-.... .:-.... --...:-.... ---..:--... ----.:-.... .:-.... --...:--... -....:-.... ..---:-.... .----:-.... -....:..--- -.-.:..--- -----:--... ...--:--... ..---:-.... .:-.... .....:--... ----.:--... ..---:-.... -....:-.... -....:..--- -----:--... -----:-.... .....:-.... -.-.:-.... ...--:-.... --...:-.... ..---:--... ....-:-.... .....:-.... .:-.... ...--:--... .....:--... ..---:-.... .....:..--- .----:..--- -----:....- --...:--... .....:--... ..---:..--- -----:-.... -....:-.... ...--:--... -....:-.... .....:--... -....:-.... --...:-.... -....:..--- -----:--... .....:-.... .:-.... ----.:--... ..---:..--- -----:-.... -....:-.... ...--:-.... ..---:--... ---..:--... ..---:-.... .----:..--- -.-.:..--- -----:-.... .:-.... .----:--... .----:..--- -----:-.... -.-.:-.... ..---:-.... ---..:-.... .....:..--- -----:-.... ---..:-.... .----:--... ..---:-.... .:-.... .....:-.... --...:--... .....:--... ----.:-.... -.-.:..--- -----:-.... .....:--... ..---:-.... ----.:--... ..---:--... ----.:-.... .:-.... --...:--... -....:-.... ..---:-.... .----:..--- -----:--... ..---:--... .-:--... ..---:-.... .....:--... ....-:--... ..---:-.... -....:..--- -----:--... ...--:-.... .....:-.... ..---:--... .-:..--- -----:-.... --...:--... .....:--... ..---:..--- -----:-.... -....:--... .....:-.... .:--... .----:-.... ..---:-.... .-:-.... -....:...-- .-:..--- -----:....- -....:....- ...--:..... ..---:..... -----:....- --...:..... ..---:....- .....:..--- ."

    # 1. Decode the text from Morse code
    morse_text = from_morse_code(ENCODED_TEXT.replace(':', ' '))
    print(f'Morse code sequence: {ENCODED_TEXT}\nMessage: {morse_text}')

    # 2. Convert hex to bytes and decode to string
    base64_message = bytes.fromhex(morse_text).decode('utf-8')
    print(f'Scrambled message:\n{base64_message}')

    # 3. Apply ROT13 to the scrmabled text
    rot13_base64 = codecs.encode(base64_message, 'rot_13')
    print(f'ROT13 applied to scrambled text:\n{rot13_base64}')

if __name__ == "__main__":
    main()    