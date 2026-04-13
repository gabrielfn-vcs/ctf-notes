# Lab 5 - Confusing Code

## Table of Contents
- [Lab 5 - Confusing Code](#lab-5---confusing-code)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
    - [What is the path to the binary you can run as the root user?](#what-is-the-path-to-the-binary-you-can-run-as-the-root-user)
    - [Ghidra Tool](#ghidra-tool)
  - [Solution](#solution)

## Overview

In this lab, you'll first need to identify which program you can run with root privileges. Use Ghidra to decompile the program and understand the confusing code. Using the information you discover, run the program and answer the questions correctly, revealing the location where the access code is hidden along the way.

## Analysis

### What is the path to the binary you can run as the root user?
```bash
$ sudo -l
```
```
Matching Defaults entries for kali on halloween-2024-confusing-code:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin,
    use_pty

User kali may run the following commands on halloween-2024-confusing-code:
    (root) NOPASSWD: /opt/b-code/a-iamconfused/confusing-code
```
**Answer:** `/opt/b-code/a-iamconfused/confusing-code`

### Ghidra Tool

Analyzing the file above in Ghidra provides details for the execution in the `main()` function.

Ghidra first disassembles the binary into machine instructions and provides the [confusing-code.asm](./confusing-code.asm) file. In this file, we can see the true representation of the program logic:
- Function entry points
- Registers
- Stack operations
- Jumps and branches
- Calls to other functions

Ghidra also includes a decomplier that reconstructs high-level C code from the assembly under the [confusing-code.c](./confusing-code.c) file.

1. The program continuously calls the `loop()` function inside `main()`.
2. Inside `loop()`, the program:
   * Reads a value from user input.
   * Depending on the value entered by the user (`local_14`), it calls a corresponding function (`zero()`, `one()`, etc.).
   * If no matching value is found, it clears the screen and displays an error message.
   * The program checks for stack corruption before returning from the function.
3. The valid ride identifiers are as follows:
   ```
   Input Number (Hexadecimal)	Input Number (Decimal)	Function Called
   0xffff                       65535	                ten()
   0x5d60                       23904	                nine()
   0x1931      	               449	                eight()
   0xcab                         3243	                six()
   0xc73	                      3187	                five()
   0x21f                      	   543	                four()
   0x126                          294	                three()
   0x7c                           124	                two()
   0x0                              0	                zero()
   0x1c                            28	                one()
   ```
4. Looking at the assembly code, the password is `pge2j` and it is saved in the `local_30` variable, which is the one used by all the functions to check for the password.
   ```
   b::000001ee 70 61 73        utf8       u8"password"
      00101642 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
      00101649 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
   ```
5. Looking at all the functions, they all do the same except for input `294` (`0x126`).
6. This input calls `three()`, which asks for the password and calls `seven(0)` on success.
7. This actually tries to read a file containing the access code and prints its content.

## Solution

Let's run the program using the information we just gathered.
```bash
$ sudo /opt/b-code/a-iamconfused/confusing-code
```
```
Welcome doomed investigator
Where is the AI's access code hidden?
 - In the remains of the Python Pit?
 - In the jaws of the sharks in their pool?
 - In the chaos of the carnival?
 - Under the Rusty Rollercoaster?
 - Somewhere in Mirror Mayhem?
 - In the Cursed Crypt?
Which route do you want to take? - enter the id of the ride (it will be between 0-65535)): 294
What is the passcode to the computer?: pge2j
You go to the correct ride and unlock the computer there with the correct password, it unlocks revealing the access code to you: 3280d4
```
**Answer:** `3280d4`
