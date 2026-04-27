# Lab 7 - Teacup Trouble

## Table of Contents
- [Lab 7 - Teacup Trouble](#lab-7---teacup-trouble)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
    - [Reverse Engineering](#reverse-engineering)
    - [High-Level Overview](#high-level-overview)
    - [Key Components](#key-components)
      - [Emoji Alphabet (`a()`)](#emoji-alphabet-a)
      - [Validation Numbers (`b()`)](#validation-numbers-b)
      - [Input Handling (`c()`)](#input-handling-c)
      - [Emoji Parsing (`e()`)](#emoji-parsing-e)
      - [Array Rotation (`d()`)](#array-rotation-d)
      - [Key Validation (`f()`)](#key-validation-f)
      - [Protected File Access (`g()`)](#protected-file-access-g)
  - [Solution](#solution)
    - [Answer](#answer)
  - [Navigation](#navigation)

---

## Overview

This lab provides a Java compiled class [`TCUP.class`](./TCUP.class) that runs an application that expects a series of emojis in the right order as an input to solve the challenge.

---

## Analysis

### Reverse Engineering
The first step is to decompile the given [`TCUP.class`](./TCUP.class) file and extract a readable Java file [`TCUP.java`](./TCUP.java) to analyze the functionality.

> [!INFO]
> One way to do this is using the FernFlower decompiler in an IDE.

### High-Level Overview
This Java program is essentially an emoji-based password validator. If the user enters the correct sequence of emojis, the program grants access and prints the contents of two privileged files.

The overall flow is:

1. Display a list of Halloween-themed emojis.
2. Ask the user to input a key combination.
3. Validate the input against a hidden algorithm.
4. If the key is correct:
   - Read and print `/root/token.txt`
   - Read and print `/root/code.txt`

The `main()` program flow is:

1. Prints program version.
2. Prints instructions asking for a key combination.
3. Initializes:
   - `var1 = b()` → integer sequence used for validation
   - `var2 = a()` → emoji array
4. Prints the emoji list.
5. Reads user input.
6. Validates the input with `f()`.
7. If validation succeeds:
   - Prints Access Granted.
   - Calls `g()` to read protected files.

### Key Components

#### Emoji Alphabet (`a()`)

Returns an array of 15 emoji characters used as the symbol set with all the possible inputs for the password:
```
🎃 👺 🧟 🕷 🕸 🧛 👻 🤡 💀 ☠️ 🍬 🍭 ⚰️ 🌕 🕯
```
This array acts like a rotating lookup table.

Using the [`emojis_to_unicode.py`](./emojis_to_unicode.py) Python script, we can derive the Unicode points for each emoji in the list:
```
    🎃 (Jack-O-Lantern) - \U0001f383
    👺 (Goblin) - \U0001f47a
    🧟 (Zombie) - \U0001f9df
    🕷️ (Spider) - \U0001f577\U0000fe0f
    🕸️ (Spider Web) - \U0001f578\U0000fe0f
    🧛 (Vampire) - \U0001f9db
    👻 (Ghost) - \U0001f47b
    🤡 (Clown Face) - \U0001f921
    💀 (Skull) - \U0001f480
    ☠️ (Skull and Crossbones) - \U0001f480\U00002620
    🍬 (Candy) - \U0001f36c
    🍭 (Lollipop) - \U0001f36d
    ⚰️ (Coffin) - \U0001f36d\U0000fe0f
    🌕 (Full Moon) - \U0001f315
    🕯️ (Candle) - \U0001f56f\U0000fe0f
```

> [!NOTE]
> - Some emojis have more bytes to encode than others.
> - Need to make sure all the Unicode points are included for those emojis during the input.

#### Validation Numbers (`b()`)

Returns an array of 20 integers.

These numbers drive the validation algorithm and are used in pairs:
```
[index_value, rotation_value]
```

Since there are 20 numbers, the expected password length is:
```
20 / 2 = 10 emojis
```

#### Input Handling (`c()`)

Reads a single line from the console.

#### Emoji Parsing (`e()`)

Splits the input string into individual emoji tokens because emojis are multi-byte Unicode characters.

Example:
```
Input: ["🎃", "👻", "🍬", ...]
```

#### Array Rotation (`d()`)

Rotates the emoji array by a given amount.

Example:
```
Original: [A B C D]
Rotate 1 → [D A B C]
Rotate 2 → [C D A B]
```
This means the emoji lookup table changes after each validation step.

#### Key Validation (`f()`)

These are the steps of the core algorithm:

1. Split user input into emoji tokens.
2. Check that the user entered 10 emojis.
3. For each pair of numbers in the integer array:
   1. Compute the index:
      ```java
      index = numbers[i] % emojiArray.length
      ```
   2. Determine the expected emoji:
      ```java
      expectedEmoji = emojiArray[index]
      ```
   3. Detemine the user emoji:
      ```java
       userEmoji = input[i/2]
       ```
4. Compare:
   ```java
   expectedEmoji == userEmoji
   ```
5. If correct, rotate the emoji array right by:
   ```java
   numbers[i+1] % emojiArray.length
   ```
6. Continue until all checks pass.
7. If any mismatch occurs, then authentication fails.

So the password depends on:

- Modular indexing.
- Dynamic emoji table rotation.

#### Protected File Access (`g()`)

If the key is correct, the program reads:
```bash
/root/token.txt
/root/code.txt
```
and prints their contents.

These paths indicate the program likely expects `root` privileges.

---

## Solution

By running the algorithm, we can produce the list of expected emojis in the right order:

- **Emojis:** 🕯️🕷️🧟🎃🌕💀🧛🕸️👻🕯️
- **Unicode:** `\U0001f56f\U0000fe0f\U0001f577\U0000fe0f\U0001f9df\U0001f383\U0001f315\U0001f480\U0001f9db\U0001f578\U0000fe0f\U0001f47b\U0001f56f\U0000fe0f`

To guarantee the input is provided correctly to the Java class at runtime, we can use a wrapper Python script ([`run_java.py`](./run_java.py)) or a Shell script ([`run_java.sh`](./run_java.sh)).

### Answer
**Token:** `a576e7`

To use the rollercoaster in the final lab of this challenge, you'll need something to grab on to. Perhaps you could 'borrow' a handle from one of the teacups. What is the code provided after inputting the correct passcode? (Take a note of it! You'll also need it as a code in the final lab of the collection.)

**Code:** `iDontThinkYouCanHandleThis`

---

## Navigation

| | |
|:---|---:|
| ← [Rusty Rollercoaster](../lab-6-rusty-rollercoaster/README.md) | [Haywire Host](../lab-8-haywire-host/README.md) → |
