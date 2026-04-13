import subprocess


def run_java_with_emojis(emojis: list[str]):
    # Prepare the Java command to run
    #java_command = ["java", "TCUP"]
    java_command = ["sudo", "/usr/bin/java", "-cp", "/opt", "TCUP"]

    # Start the Java process and provide the input
    process = subprocess.Popen(
        java_command,
        stdin=subprocess.PIPE,  # For sending input to the Java program
        stdout=subprocess.PIPE,  # For capturing the output from the Java program
        stderr=subprocess.PIPE,  # For capturing errors
        text=True,  # Enable text mode (no byte objects)
    )

    # Combine the emojis into a single string for input
    emoji_string = "".join(emojis) + "\n"
    print(f"Sending emoji string as input: {emoji_string}")

    # Send the emoji input to the Java program
    stdout, stderr = process.communicate(input=emoji_string)

    # Print the results
    print("Java Program Output:")
    print(stdout)
    if stderr:
        print("Errors:")
        print(stderr)


if __name__ == "__main__":
    # Define the specific list of emojis to send in Unicode
    emoji_input = [
        "\U0001f56f\U0000fe0f",  # Candle
        "\U0001f577\U0000fe0f",  # Spider
        "\U0001f9df",            # Zombie
        "\U0001f383",            # Jack-O-Lantern
        "\U0001f315",            # Full Moon
        "\U0001f480",            # Skull
        "\U0001f9db",            # Vampire
        "\U0001f578\U0000fe0f",  # Spider Web
        "\U0001f47b",            # Ghost
        "\U0001f56f\U0000fe0f",  # Candle
    ]

    # Run the Java program and pass the emojis as input
    run_java_with_emojis(emoji_input)
