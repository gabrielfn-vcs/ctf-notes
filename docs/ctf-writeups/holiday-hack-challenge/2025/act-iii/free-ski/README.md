# Free Ski

## Table of Contents
- [Free Ski](#free-ski)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Introduction](#introduction)
  - [Items](#items)
  - [Hints](#hints)
    - [Hint 1: Extraction](#hint-1-extraction)
    - [Hint 2: Decompilation!](#hint-2-decompilation)
  - [Set Up the Environment](#set-up-the-environment)
  - [Install PyInstaller Extractor](#install-pyinstaller-extractor)
  - [Install Decompyle++](#install-decompyle)
    - [Build](#build)
      - [Install CMake](#install-cmake)
      - [Generate the `pycdc` Build Files](#generate-the-pycdc-build-files)
      - [Build the Targets](#build-the-targets)
  - [Analysis](#analysis)
    - [Extract Files from `FreeSki.exe`](#extract-files-from-freeskiexe)
    - [Decompile `FreeSki.pyc`](#decompile-freeskipyc)
    - [Disassemble `FreeSki.pyc`](#disassemble-freeskipyc)
    - [Bytecode Analysis](#bytecode-analysis)
      - [`SetFlag` Function](#setflag-function)
    - [The origin of `encoded_flag`](#the-origin-of-encoded_flag)
    - [The content of `treasure_list`](#the-content-of-treasure_list)
    - [Treasure Locations](#treasure-locations)
    - [Alternate Source Code Recovery](#alternate-source-code-recovery)
  - [Solution](#solution)
    - [Answer](#answer)
  - [Outro](#outro)
  - [Files](#files)
  - [References](#references)
  - [Navigation](#navigation)

---

## Overview

Go to the retro store and help Goose Olivia ski down the mountain and collect all five treasure chests to reveal the hidden flag in this classic SkiFree-inspired challenge.

## Introduction

**Olivia**

HONK! Well hello there! Fancy meeting you here in the Dosis Neighborhood.

You know, it's the strangest thing... I used to just waddle around the Geese Islands going 'BONK' all day long. Random noises, no thoughts, just vibes. But then something changed, and now here I am—speaking, thinking, wondering how I even got here!

HONK! You know what happens to geese in a permanent winter? We can't migrate! And trust me, being stuck in one place forever isn't natural—even for someone who just discovered they can think and talk. Frosty needs to chill out... wait, that's exactly the problem!

This game looks simple enough, doesn't it? Almost too simple. But between you and me... it seems nearly impossible to win fair and square.

My advice? If you ain't cheatin', you ain't tryin'. wink

Now get out there and show that mountain who's boss!

## Items

Olivia provides the [`FreeSki.exe`](./FreeSki.exe) binary executable to analyze.

## Hints

### Hint 1: Extraction
Have you ever used PyInstaller Extractor (https://github.com/extremecoders-re/pyinstxtractor)?

### Hint 2: Decompilation!
Many Python decompilers don't understand Python 3.13, but Decompyle++ (https://github.com/zrax/pycdc) does!

---

## Set Up the Environment

## Install PyInstaller Extractor

PyInstaller Extractor is a Python script to extract the contents of a PyInstaller generated executable file.

The specific `pyinstxtractor.py` Python script can be downloaded from `https://github.com/extremecoders-re/pyinstxtractor`.

## Install Decompyle++

Decompyle++ aims to translate compiled Python byte-code back into valid and human-readable Python source code.

The C++ source code can be downloaded from `https://github.com/zrax/pycdc`.
```bash
git clone https://github.com/zrax/pycdc.git
```
```
Cloning into 'pycdc'...
remote: Enumerating objects: 3023, done.
remote: Total 3023 (delta 0), reused 0 (delta 0), pack-reused 3023 (from 1)
Receiving objects: 100% (3023/3023), 944.25 KiB | 1.44 MiB/s, done.
Resolving deltas: 100% (1903/1903), done.
```

### Build
Need to generate a project or makefile with [CMake](http://www.cmake.org/).

#### Install CMake
```
brew install cmake
```

#### Generate the `pycdc` Build Files
```bash
cmake -B build
```
```
-- The C compiler identification is AppleClang 17.0.0.17000404
-- The CXX compiler identification is AppleClang 17.0.0.17000404
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Found Python3: /path/to/python3.14 (found suitable version "3.14.2", minimum required is "3.6") found components: Interpreter
-- Configuring done (5.2s)
-- Generating done (1.2s)
-- Build files have been written to: /path/to/pycdc/build
```

#### Build the Targets
```bash
cmake --build build
```
```
[  2%] Building CXX object CMakeFiles/pycxx.dir/bytecode.cpp.o
[  4%] Building CXX object CMakeFiles/pycxx.dir/data.cpp.o
[  6%] Building CXX object CMakeFiles/pycxx.dir/pyc_code.cpp.o
[  9%] Building CXX object CMakeFiles/pycxx.dir/pyc_module.cpp.o
[ 11%] Building CXX object CMakeFiles/pycxx.dir/pyc_numeric.cpp.o
[ 13%] Building CXX object CMakeFiles/pycxx.dir/pyc_object.cpp.o
[ 16%] Building CXX object CMakeFiles/pycxx.dir/pyc_sequence.cpp.o
[ 18%] Building CXX object CMakeFiles/pycxx.dir/pyc_string.cpp.o
[ 20%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_1_0.cpp.o
[ 23%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_1_1.cpp.o
[ 25%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_1_3.cpp.o
[ 27%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_1_4.cpp.o
[ 30%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_1_5.cpp.o
[ 32%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_1_6.cpp.o
[ 34%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_0.cpp.o
[ 37%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_1.cpp.o
[ 39%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_2.cpp.o
[ 41%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_3.cpp.o
[ 44%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_4.cpp.o
[ 46%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_5.cpp.o
[ 48%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_6.cpp.o
[ 51%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_2_7.cpp.o
[ 53%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_0.cpp.o
[ 55%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_1.cpp.o
[ 58%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_2.cpp.o
[ 60%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_3.cpp.o
[ 62%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_4.cpp.o
[ 65%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_5.cpp.o
[ 67%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_6.cpp.o
[ 69%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_7.cpp.o
[ 72%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_8.cpp.o
[ 74%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_9.cpp.o
[ 76%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_10.cpp.o
[ 79%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_11.cpp.o
[ 81%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_12.cpp.o
[ 83%] Building CXX object CMakeFiles/pycxx.dir/bytes/python_3_13.cpp.o
[ 86%] Linking CXX static library libpycxx.a
[ 86%] Built target pycxx
[ 88%] Building CXX object CMakeFiles/pycdas.dir/pycdas.cpp.o
[ 90%] Linking CXX executable pycdas
[ 90%] Built target pycdas
[ 93%] Building CXX object CMakeFiles/pycdc.dir/pycdc.cpp.o
[ 95%] Building CXX object CMakeFiles/pycdc.dir/ASTree.cpp.o
[ 97%] Building CXX object CMakeFiles/pycdc.dir/ASTNode.cpp.o
[100%] Linking CXX executable pycdc
[100%] Built target pycdc
```

---

## Analysis

### Extract Files from `FreeSki.exe`
Let's extract the files using the default Python 3 installation:
```bash
python3 pyinstxtractor.py FreeSki.exe
```
```
[+] Processing FreeSki.exe
[+] Pyinstaller version: 2.1+
[+] Python version: 3.13
[+] Length of package: 16806404 bytes
[+] Found 98 files in CArchive
[+] Beginning extraction...please standby
[+] Possible entry point: pyiboot01_bootstrap.pyc
[+] Possible entry point: pyi_rth_inspect.pyc
[+] Possible entry point: pyi_rth_pkgres.pyc
[+] Possible entry point: pyi_rth_setuptools.pyc
[+] Possible entry point: pyi_rth_multiprocessing.pyc
[+] Possible entry point: pyi_rth_pkgutil.pyc
[+] Possible entry point: FreeSki.pyc
[!] Warning: This script is running in a different Python version than the one used to build the executable.
[!] Please run this script in Python 3.13 to prevent extraction errors during unmarshalling
[!] Skipping pyz extraction
[+] Successfully extracted pyinstaller archive: FreeSki.exe

You can now use a python decompiler on the pyc files within the extracted directory
```

Because I did not use the exact Python version used to build the executable (i.e., Python 3.13), it skipped the PYZ extraction.

PyInstaller bundles most real code inside PYZ. What was decompiled is mostly:

  - Loader stubs.
  - Resource initialization.
  - Minimal top-level code.

Let's run it again with the `python3.13` binary.
```bash
python3.13 pyinstxtractor.py FreeSki.exe
```
```
[+] Processing FreeSki.exe
[+] Pyinstaller version: 2.1+
[+] Python version: 3.13
[+] Length of package: 16806404 bytes
[+] Found 98 files in CArchive
[+] Beginning extraction...please standby
[+] Possible entry point: pyiboot01_bootstrap.pyc
[+] Possible entry point: pyi_rth_inspect.pyc
[+] Possible entry point: pyi_rth_pkgres.pyc
[+] Possible entry point: pyi_rth_setuptools.pyc
[+] Possible entry point: pyi_rth_multiprocessing.pyc
[+] Possible entry point: pyi_rth_pkgutil.pyc
[+] Possible entry point: FreeSki.pyc
[+] Found 471 files in PYZ archive
[!] Error: Failed to decompress PYZ.pyz_extracted/jaraco.pyc, probably encrypted. Extracting as is.
[!] Error: Failed to decompress PYZ.pyz_extracted/setuptools/_distutils/compilers.pyc, probably encrypted. Extracting as is.
[!] Error: Failed to decompress PYZ.pyz_extracted/setuptools/_distutils/compilers/C.pyc, probably encrypted. Extracting as is.
[!] Error: Failed to decompress PYZ.pyz_extracted/setuptools/_vendor.pyc, probably encrypted. Extracting as is.
[!] Error: Failed to decompress PYZ.pyz_extracted/setuptools/_vendor/jaraco.pyc, probably encrypted. Extracting as is.
[+] Successfully extracted pyinstaller archive: FreeSki.exe

You can now use a python decompiler on the pyc files within the extracted directory
```

This time the Python version matched (3.13) and the PYZ archive extracted (471 files). There are a few encrypted files, which is normal.

We can see that the `FreeSki.pyc` file exists outside the PYZ. Most likely the game logic is not inside PYZ, but in this file.

### Decompile `FreeSki.pyc`
```bash
.../pycdc/build/pycdc FreeSki.exe_extracted/FreeSki.pyc
```
```bash
# Source Generated with Decompyle++
# File: FreeSki.pyc (Python 3.13)

Unsupported opcode: MAKE_FUNCTION (122)
import pygame
import enum
import random
import binascii
None()
pygame.font.init()
screen_width = 800
screen_height = 600
framerate_fps = 60
object_horizonal_hitbox = 1.5
object_vertical_hitbox = 0.5
max_speed = 0.4
accelerate_increment = 0.02
decelerate_increment = 0.05
scale_factor = 0.1
pixels_per_meter = 30
skier_vertical_pixel_location = 100
mountain_width = 1000
obstacle_draw_distance = 23
skier_start = 5
grace_period = 10
screen = pygame.display.set_mode((screen_width, screen_height))
clock = pygame.time.Clock()
dt = 0
pygame.key.set_repeat(500, 100)
pygame.display.set_caption('FreeSki v0.0')
skierimage = pygame.transform.scale_by(pygame.image.load('img/skier.png'), scale_factor)
skier_leftimage = pygame.transform.scale_by(pygame.image.load('img/skier_left.png'), scale_factor)
skier_rightimage = pygame.transform.scale_by(pygame.image.load('img/skier_right.png'), scale_factor)
skier_crashimage = pygame.transform.scale_by(pygame.image.load('img/skier_crash.png'), scale_factor)
skier_pizzaimage = pygame.transform.scale_by(pygame.image.load('img/skier_pizza.png'), scale_factor)
treeimage = pygame.transform.scale_by(pygame.image.load('img/tree.png'), scale_factor)
yetiimage = pygame.transform.scale_by(pygame.image.load('img/yeti.png'), scale_factor)
treasureimage = pygame.transform.scale_by(pygame.image.load('img/treasure.png'), scale_factor)
boulderimage = pygame.transform.scale_by(pygame.image.load('img/boulder.png'), scale_factor)
victoryimage = pygame.transform.scale_by(pygame.image.load('img/victory.png'), 0.7)
gamefont = pygame.font.Font('fonts/VT323-Regular.ttf', 24)
text_surface1 = 'Use arrow keys to ski and find the 5 treasures!'(False, pygame.Color, None('blue'))
text_surface2 = "          find all the lost bears. don't drill into a rock. Win game."(False, pygame.Color, None('yellow'))
flagfont = pygame.font.Font('fonts/VT323-Regular.ttf', 32)
flag_text_surface = 'replace me'(False, pygame.Color, None('saddle brown'))
flag_message_text_surface1 = 'You win! Drill Baby is reunited with'(False, pygame.Color, None('yellow'))
flag_message_text_surface2 = 'all its bears. Welcome to Flare-On 12.'(False, pygame.Color, None('yellow'))
# WARNING: Decompyle incomplete
```

Unfortunately, the decompilation fails and there is no clean decompilation path:

- Python 3.13 changed bytecode structure.
- Function bodies use `MAKE_FUNCTION`, `CALL_INTRINSIC_*`, and new stack semantics.
- As of this date, there is no public decompiler able to reconstruct them yet.

### Disassemble `FreeSki.pyc`
This looks like a bytecode-level challenge.

Let's disassemble `FreeSki.pyc` and analyze the bytecode instead of the source code.
```bash
.../pycdc/build/pycdas FreeSki.exe_extracted/FreeSki.pyc > FreeSki.pyasm
```

### Bytecode Analysis
Let's examine the [`FreeSki.pyasm`](./FreeSki.pyasm) file and see what we can discover.

#### `SetFlag` Function
We can see a `SetFlag` function in the `[Names]` section. This is almost certainly where the flag is generated.
```
    [Code]
        File Name: FreeSki.py
        Object Name: SetFlag
        Qualified Name: SetFlag
        Arg Count: 2
        Pos Only Arg Count: 0
        KW Only Arg Count: 0
        Stack Size: 7
        Flags: 0x00000003 (CO_OPTIMIZED | CO_NEWLOCALS)
        [Names]
            'random'
            'seed'
            'range'
            'len'
            'encoded_flag'
            'randint'
            'append'
            'chr'
            'join'
            'print'
            'flagfont'
            'render'
            'pygame'
            'Color'
            'flag_text_surface'
        [Locals+Names]
            'mountain'
            'treasure_list'
            'product'
            'treasure_val'
            'decoded'
            'i'
            'r'
            'flag_text'
        [Constants]
            None
            0
            8
            255
            'Flag: %s'
            ''
            False
            'saddle brown'
        [Disassembly]
            0       RESUME                          0
            2       LOAD_CONST                      1: 0
            4       STORE_FAST                      2: product
            6       LOAD_FAST                       1: treasure_list
            8       GET_ITER                        
            10      FOR_ITER                        11 (to 34)
            14      STORE_FAST                      3: treasure_val
            16      LOAD_FAST                       2: product
            18      LOAD_CONST                      2: 8
            20      BINARY_OP                       3 (<<)
            24      LOAD_FAST                       3: treasure_val
            26      BINARY_OP                       12 (^)
            30      STORE_FAST                      2: product
            32      JUMP_BACKWARD                   13 (to 8)
            36      END_FOR                         
            38      POP_TOP                         
            40      LOAD_GLOBAL                     0: random
            50      LOAD_ATTR                       2: seed
            70      PUSH_NULL                       
            72      LOAD_FAST                       2: product
            74      CALL                            1
            82      POP_TOP                         
            84      BUILD_LIST                      0
            86      STORE_FAST                      4: decoded
            88      LOAD_GLOBAL                     5: NULL + range
            98      LOAD_CONST                      1: 0
            100     LOAD_GLOBAL                     7: NULL + len
            110     LOAD_FAST                       0: mountain
            112     LOAD_ATTR                       8: encoded_flag
            132     CALL                            1
            140     CALL                            2
            148     GET_ITER                        
            150     FOR_ITER                        68 (to 288)
            154     STORE_FAST                      5: i
            156     LOAD_GLOBAL                     0: random
            166     LOAD_ATTR                       10: randint
            186     PUSH_NULL                       
            188     LOAD_CONST                      1: 0
            190     LOAD_CONST                      3: 255
            192     CALL                            2
            200     STORE_FAST                      6: r
            202     LOAD_FAST                       4: decoded
            204     LOAD_ATTR                       13: append
            224     LOAD_GLOBAL                     15: NULL + chr
            234     LOAD_FAST                       0: mountain
            236     LOAD_ATTR                       8: encoded_flag
            256     LOAD_FAST                       5: i
            258     BINARY_SUBSCR                   
            262     LOAD_FAST                       6: r
            264     BINARY_OP                       12 (^)
            268     CALL                            1
            276     CALL                            1
            284     POP_TOP                         
            286     JUMP_BACKWARD                   70 (to 148)
            290     END_FOR                         
            292     POP_TOP                         
            294     LOAD_CONST                      4: 'Flag: %s'
            296     LOAD_CONST                      5: ''
            298     LOAD_ATTR                       17: join
            318     LOAD_FAST                       4: decoded
            320     CALL                            1
            328     BINARY_OP                       6 (%)
            332     STORE_FAST                      7: flag_text
            334     LOAD_GLOBAL                     19: NULL + print
            344     LOAD_FAST                       7: flag_text
            346     CALL                            1
            354     POP_TOP                         
            356     LOAD_GLOBAL                     20: flagfont
            366     LOAD_ATTR                       23: render
            386     LOAD_FAST                       7: flag_text
            388     LOAD_CONST                      6: False
            390     LOAD_GLOBAL                     24: pygame
            400     LOAD_ATTR                       26: Color
            420     PUSH_NULL                       
            422     LOAD_CONST                      7: 'saddle brown'
            424     CALL                            1
            432     CALL                            3
            440     STORE_GLOBAL                    14: flag_text_surface
            442     RETURN_CONST                    0: None
        [Exception Table]
```

Here is a readable Python reconstruction of that function:
```python
def SetFlag(mountain, treasure_list):
    product = 0

    # Build seed from treasures
    for treasure_val in treasure_list:
        product = (product << 8) ^ treasure_val

    # Seed RNG
    import random
    random.seed(product)

    decoded = []

    # Decode the flag
    for i in range(len(mountain.encoded_flag)):
        random_stream = random.randint(0, 255)
        decoded.append(
            chr(mountain.encoded_flag[i] ^ random_stream)
        )

    # Build final string
    flag_text = "Flag: %s" % "".join(decoded)

    print(flag_text)

    # Render to screen (not important for solving)
    global flag_text_surface
    flag_text_surface = flagfont.render(
        flag_text,
        False,
        pygame.Color("saddle brown")
    )
```

It looks like the flag is determined based on a given list of collected treasures.

The core logic is `mountain.encoded_flag XOR random_stream`, where `random_stream` is generated from `random.seed(product)`.

The `product` value is generated with:
```python
product = 0
for treasure_val in treasure_list:
    product = (product << 8) ^ treasure_val
```

This is basically:

- Shifting left 8 bits (like building a number byte-by-byte).
- XORing each treasure value.

The order and values of the given `treasure_list` fully determine the flag to solve the game.

### The origin of `encoded_flag`
From the `Mountain.__init__` disassembly:
```
    [Code]
        File Name: FreeSki.py
        Object Name: __init__
        Qualified Name: Mountain.__init__
        Arg Count: 6
[...]
        [Names]
            'name'
            'height'
            'treeline'
            'yetiline'
            'encoded_flag'
            'GetTreasureLocations'
            'treasures'
        [Locals+Names]
            'self'
            'name'
            'height'
            'treeline'
            'yetiline'
            'encoded_flag'
```
and the following local initialization logic:
```
    [Disassembly]
        0       RESUME                          0
        2       LOAD_FAST_LOAD_FAST             16: name, self
        4       STORE_ATTR                      0: name
        14      LOAD_FAST_LOAD_FAST             32: height, self
        16      STORE_ATTR                      1: height
        26      LOAD_FAST_LOAD_FAST             48: treeline, self
        28      STORE_ATTR                      2: treeline
        38      LOAD_FAST_LOAD_FAST             64: yetiline, self
        40      STORE_ATTR                      3: yetiline
        50      LOAD_FAST_LOAD_FAST             80: encoded_flag, self
        52      STORE_ATTR                      4: encoded_flag
        62      LOAD_FAST                       0: self
        64      LOAD_ATTR                       11: GetTreasureLocations
        84      CALL                            0
        92      LOAD_FAST                       0: self
        94      STORE_ATTR                      6: treasures
        104     RETURN_CONST                    0: None
```
we can infer this constructor signature:
```
Mountain(name, height, treeline, yetiline, encoded_flag)
```

Only `treasures` is not passed. It is initialized internally from the `GetTreasureLocations` function.

There are 7 mountains, each with its own encoded_flag.
```
    2456    LOAD_CONST                      51: <CODE> Mountain
    2458    MAKE_FUNCTION                   
    2460    LOAD_CONST                      52: 'Mountain'
    2462    CALL                            2
    2470    STORE_NAME                      75: Mountain
    2472    LOAD_NAME                       75: Mountain
    2474    PUSH_NULL                       
    2476    LOAD_CONST                      53: 'Mount Snow'
    2478    LOAD_CONST                      54: 3586
    2480    LOAD_CONST                      55: 3400
    2482    LOAD_CONST                      56: 2400
    2484    LOAD_CONST                      57: b'\x90\x00\x1d\xbc\x17b\xed6S"\xb0<Y\xd6\xce\x169\xae\xe9|\xe2Gs\xb7\xfdy\xcf5\x98'
    2486    CALL                            5
    2494    LOAD_NAME                       75: Mountain
    2496    PUSH_NULL                       
    2498    LOAD_CONST                      58: 'Aspen'
    2500    LOAD_CONST                      59: 11211
    2502    LOAD_CONST                      60: 11000
    2504    LOAD_CONST                      61: 10000
    2506    LOAD_CONST                      62: b'U\xd7%x\xbfvj!\xfe\x9d\xb9\xc2\xd1k\x02y\x17\x9dK\x98\xf1\x92\x0f!\xf1\\\xa0\x1b\x0f'
    2508    CALL                            5
    2516    LOAD_NAME                       75: Mountain
    2518    PUSH_NULL                       
    2520    LOAD_CONST                      63: 'Whistler'
    2522    LOAD_CONST                      64: 7156
    2524    LOAD_CONST                      65: 6000
    2526    LOAD_CONST                      66: 6500
    2528    LOAD_CONST                      67: b'\x1cN\x13\x1a\x97\xd4\xb2!\xf9\xf6\xd4#\xee\xebh\xecs.\x08M!hr9?\xde\x0c\x86\x02'
    2530    CALL                            5
    2538    LOAD_NAME                       75: Mountain
    2540    PUSH_NULL                       
    2542    LOAD_CONST                      68: 'Mount Baker'
    2544    LOAD_CONST                      69: 10781
    2546    LOAD_CONST                      70: 9000
    2548    LOAD_CONST                      65: 6000
    2550    LOAD_CONST                      71: b'\xac\xf9#\xf4T\xf1%h\xbe3FI+h\r\x01V\xee\xc2C\x13\xf3\x97ef\xac\xe3z\x96'
    2552    CALL                            5
    2560    LOAD_NAME                       75: Mountain
    2562    PUSH_NULL                       
    2564    LOAD_CONST                      72: 'Mount Norquay'
    2566    LOAD_CONST                      73: 6998
    2568    LOAD_CONST                      74: 6300
    2570    LOAD_CONST                      75: 3000
    2572    LOAD_CONST                      76: b'\x0c\x1c\xad!\xc6,\xec0\x0b+"\x9f@.\xc8\x13\xadb\x86\xea{\xfeS\xe0S\x85\x90\x03q'
    2574    CALL                            5
    2582    LOAD_NAME                       75: Mountain
    2584    PUSH_NULL                       
    2586    LOAD_CONST                      77: 'Mount Erciyes'
    2588    LOAD_CONST                      78: 12848
    2590    LOAD_CONST                      61: 10000
    2592    LOAD_CONST                      79: 12000
    2594    LOAD_CONST                      80: b'n\xad\xb4l^I\xdb\xe1\xd0\x7f\x92\x92\x96\x1bq\xca`PvWg\x85\xb21^\x93F\x1a\xee'
    2596    CALL                            5
    2604    LOAD_NAME                       75: Mountain
    2606    PUSH_NULL                       
    2608    LOAD_CONST                      81: 'Dragonmount'
    2610    LOAD_CONST                      82: 16282
    2612    LOAD_CONST                      83: 15500
    2614    LOAD_CONST                      84: 16000
    2616    LOAD_CONST                      85: b'Z\xf9\xdf\x7f_\x02\xd8\x89\x12\xd2\x11p\xb6\x96\x19\x05x))v\xc3\xecv\xf4\xe2\\\x9a\xbe\xb5'
    2618    CALL                            5
    2626    BUILD_LIST                      7
    2628    STORE_GLOBAL                    76: Mountains
```

We can see that the `encoded_flag` bytes are passed into the `Mountain` constructor as a bytes constant.

Let's put all the `Mountain` constructors together:
```python
Mountains = [
    Mountain('Mount Snow', 3586, 3400, 2400, b'\x90\x00\x1d\xbc\x17b\xed6S"\xb0<Y\xd6\xce\x169\xae\xe9|\xe2Gs\xb7\xfdy\xcf5\x98'),
    Mountain('Aspen', 11211, 11000, 10000, b'U\xd7%x\xbfvj!\xfe\x9d\xb9\xc2\xd1k\x02y\x17\x9dK\x98\xf1\x92\x0f!\xf1\\\xa0\x1b\x0f'),
    Mountain('Whistler', 7156, 6000, 6500, b'\x1cN\x13\x1a\x97\xd4\xb2!\xf9\xf6\xd4#\xee\xebh\xecs.\x08M!hr9?\xde\x0c\x86\x02'),
    Mountain('Mount Baker', 10781, 9000, 6000, b'\xac\xf9#\xf4T\xf1%h\xbe3FI+h\r\x01V\xee\xc2C\x13\xf3\x97ef\xac\xe3z\x96'),
    Mountain('Mount Norquay', 6998, 6300, 3000, b'\x0c\x1c\xad!\xc6,\xec0\x0b+"\x9f@.\xc8\x13\xadb\x86\xea{\xfeS\xe0S\x85\x90\x03q'),
    Mountain('Mount Erciyes', 12848, 10000, 12000, b'n\xad\xb4l^I\xdb\xe1\xd0\x7f\x92\x92\x96\x1bq\xca`PvWg\x85\xb31^\x93F\x1a\xee'),
    Mountain('Dragonmount', 16282, 15500, 16000, b'Z\xf9\xdf\x7f_\x02\xd8\x89\x12\xd2\x11p\xb6\x96\x19\x05x))v\xc3\xecv\xf4\xe2\\\x9a\xbe\xb5')
]
```

Here is how each argument is used, based on bytecode access patterns:

| Position | Parameter | Meaning | Usage |
| --- | --- | --- | --- |
| 1 | `name` | Display name of the mountain | Shows the name of the mountain |
| 2 | `height` | Summit height (feet) | Used to determine win condition (ski to bottom) |
| 3 | `treeline` | Elevation above which trees stop spawning | Controls tree obstacle spawning |
| 4 | `yetiline` | Elevation above which yetis spawn | Controls yeti enemy spawning |
| 5 | `encoded_flag` | XOR-obfuscated flag bytes | Only used when all treasures are collected |

Each mountain gives a different encoded flag, but the flag is decoded with the same algorithm regardless. Thus, only one mountain likely produces a valid readable flag, and the others are decoys or wrong paths.

The game is won when all treasures are collected and the `SetFlag` function is called. Hence, only the winning mountain's `encoded_flag` value matters.

### The content of `treasure_list`
After analyzing the logic in the `main()` function, we find the section that checks the skier movements and calls the `SetFlag` function when all treasures are collected:
```
    1734    POP_TOP                         
    1736    LOAD_FAST                       5: skier
    1738    LOAD_ATTR                       93: isMoving
    1758    CALL                            0
    1766    TO_BOOL                         
    1774    POP_JUMP_IF_FALSE               132 (to 2040)
    1778    LOAD_FAST                       7: obstacles
    1780    LOAD_ATTR                       95: CollisionDetect
    1800    LOAD_FAST                       5: skier
    1802    CALL                            1
    1810    STORE_FAST                      11: collided_data
    1812    LOAD_FAST                       11: collided_data
    1814    LOAD_CONST                      0: None
    1816    COMPARE_OP                      119 (!=)
    1820    POP_JUMP_IF_FALSE               109 (to 2040)
    1824    LOAD_FAST                       11: collided_data
    1826    UNPACK_SEQUENCE                 3
    1830    STORE_FAST_STORE_FAST           205: collided_object, collided_row
    1832    STORE_FAST                      14: collided_row_offset
    1834    LOAD_FAST                       12: collided_object
    1836    LOAD_GLOBAL                     96: Obstacles
    1846    LOAD_ATTR                       98: TREASURE
    1866    COMPARE_OP                      88 (==)
    1870    POP_JUMP_IF_FALSE               68 (to 2008)
    1874    LOAD_CONST                      0: None
    1876    LOAD_FAST                       13: collided_row
    1878    LOAD_CONST                      7: 1
    1880    BINARY_SUBSCR                   
    1884    LOAD_FAST                       14: collided_row_offset
    1886    STORE_SUBSCR                    
    1890    LOAD_FAST_CHECK                 4: treasures_collected
    1892    LOAD_ATTR                       101: append
    1912    LOAD_FAST                       13: collided_row
    1914    LOAD_CONST                      8: 0
    1916    BINARY_SUBSCR                   
    1920    LOAD_GLOBAL                     102: mountain_width
    1930    BINARY_OP                       5 (*)
    1934    LOAD_FAST                       14: collided_row_offset
    1936    BINARY_OP                       0 (+)
    1940    CALL                            1
    1948    POP_TOP                         
    1950    LOAD_GLOBAL                     105: NULL + len
    1960    LOAD_FAST                       4: treasures_collected
    1962    CALL                            1
    1970    LOAD_CONST                      9: 5
    1972    COMPARE_OP                      88 (==)
    1976    POP_JUMP_IF_FALSE               14 (to 2006)
    1980    LOAD_GLOBAL                     107: NULL + SetFlag
    1990    LOAD_FAST_CHECK                 6: mnt
    1992    LOAD_FAST                       4: treasures_collected
    1994    CALL                            2
    2002    POP_TOP                         
    2004    LOAD_CONST                      2: True
    2006    STORE_FAST                      0: victory_mode
    2008    JUMP_FORWARD                    16 (to 2042)
    2010    LOAD_FAST                       5: skier
    2012    LOAD_ATTR                       109: Crash
    2032    CALL                            0
```

This is the reconstructed Python code:
```python
if skier.isMoving():
    collided_data = obstacles.CollisionDetect(skier)

    if collided_data is not None:
        collided_object, collided_row, collided_row_offset = collided_data

        if collided_object == Obstacles.TREASURE:
            # Remove the treasure from the map
            collided_row[1][collided_row_offset] = None

            # Convert 2D position → 1D value
            treasure_val = (
                collided_row[0] * mountain_width
                + collided_row_offset
            )

            treasures_collected.append(treasure_val)

            # Check win condition
            if len(treasures_collected) == 5:
                SetFlag(mnt, treasures_collected)
                victory_mode = True
        else:
            skier.Crash()
```

A critical part of this logic is the way the collected treasure is given a unique identifier by linearizing the 2D coordinate into a 1D value:
```
treasure_val = collided_row[0] * mountain_width + collided_row_offset
```

The `treasure_list` has the following characteristics:

- The list contains exactly 5 treasures.
- Each entry is a value with linearized coordinates.
- The order of collection matters.
- There are no extra transformations.

### Treasure Locations
Here is the `GetTreasureLocations` disassembly:
```
    [Code]
        File Name: FreeSki.py
        Object Name: GetTreasureLocations
        Qualified Name: Mountain.GetTreasureLocations
        Arg Count: 1
        Pos Only Arg Count: 0
        KW Only Arg Count: 0
        Stack Size: 8
        Flags: 0x00000003 (CO_OPTIMIZED | CO_NEWLOCALS)
        [Names]
            'random'
            'seed'
            'binascii'
            'crc32'
            'name'
            'encode'
            'height'
            'range'
            'randint'
            'int'
        [Locals+Names]
            'self'
            'locations'
            'prev_height'
            'prev_horiz'
            'i'
            'e_delta'
            'h_delta'
        [Constants]
            None
            'utf-8'
            0
            5
            200
            800
            4
        [Disassembly]
            0       RESUME                          0
            2       BUILD_MAP                       0
            4       STORE_FAST                      1: locations
            6       LOAD_GLOBAL                     0: random
            16      LOAD_ATTR                       2: seed
            36      PUSH_NULL                       
            38      LOAD_GLOBAL                     4: binascii
            48      LOAD_ATTR                       6: crc32
            68      PUSH_NULL                       
            70      LOAD_FAST                       0: self
            72      LOAD_ATTR                       8: name
            92      LOAD_ATTR                       11: encode
            112     LOAD_CONST                      1: 'utf-8'
            114     CALL                            1
            122     CALL                            1
            130     CALL                            1
            138     POP_TOP                         
            140     LOAD_FAST                       0: self
            142     LOAD_ATTR                       12: height
            162     STORE_FAST                      2: prev_height
            164     LOAD_CONST                      2: 0
            166     STORE_FAST                      3: prev_horiz
            168     LOAD_GLOBAL                     15: NULL + range
            178     LOAD_CONST                      2: 0
            180     LOAD_CONST                      3: 5
            182     CALL                            2
            190     GET_ITER                        
            192     FOR_ITER                        93 (to 380)
            196     STORE_FAST                      4: i
            198     LOAD_GLOBAL                     0: random
            208     LOAD_ATTR                       16: randint
            228     PUSH_NULL                       
            230     LOAD_CONST                      4: 200
            232     LOAD_CONST                      5: 800
            234     CALL                            2
            242     STORE_FAST                      5: e_delta
            244     LOAD_GLOBAL                     0: random
            254     LOAD_ATTR                       16: randint
            274     PUSH_NULL                       
            276     LOAD_GLOBAL                     19: NULL + int
            286     LOAD_CONST                      2: 0
            288     LOAD_FAST                       5: e_delta
            290     LOAD_CONST                      6: 4
            292     BINARY_OP                       11 (/)
            296     BINARY_OP                       10 (-)
            300     CALL                            1
            308     LOAD_GLOBAL                     19: NULL + int
            318     LOAD_FAST                       5: e_delta
            320     LOAD_CONST                      6: 4
            322     BINARY_OP                       11 (/)
            326     CALL                            1
            334     CALL                            2
            342     STORE_FAST                      6: h_delta
            344     LOAD_FAST_LOAD_FAST             54: prev_horiz, h_delta
            346     BINARY_OP                       0 (+)
            350     LOAD_FAST_LOAD_FAST             18: locations, prev_height
            352     LOAD_FAST                       5: e_delta
            354     BINARY_OP                       10 (-)
            358     STORE_SUBSCR                    
            362     LOAD_FAST_LOAD_FAST             37: prev_height, e_delta
            364     BINARY_OP                       10 (-)
            368     STORE_FAST                      2: prev_height
            370     LOAD_FAST_LOAD_FAST             54: prev_horiz, h_delta
            372     BINARY_OP                       0 (+)
            376     STORE_FAST                      3: prev_horiz
            378     JUMP_BACKWARD                   95 (to 190)
            382     END_FOR                         
            384     POP_TOP                         
            386     LOAD_FAST                       1: locations
            388     RETURN_VALUE                    
        [Exception Table]
    (
        'encoded_flag'
        'height'
        'name'
        'treasures'
        'treeline'
        'yetiline'
    )
    None
```

We can reconstruct this Python code from it:
```python
def GetTreasureLocations(self):
    import random, binascii

    locations = {}

    # Seed RNG using CRC32 of mountain name
    random.seed(binascii.crc32(self.name.encode("utf-8")))

    prev_height = self.height
    prev_horiz = 0

    for i in range(5):
        e_delta = random.randint(200, 800)

        h_delta = random.randint(
            int(0 - e_delta / 4),
            int(e_delta / 4)
        )

        locations[prev_height - e_delta] = prev_horiz + h_delta

        prev_height = prev_height - e_delta
        prev_horiz = prev_horiz + h_delta

    return locations
```

The treasure list is NOT random at runtime. For each mountain, all treasure positions are 100% deterministic and their placement depends only on:

- Mountain name.
- Mountain height.
- Python's random value with a fixed seed: `random.seed(crc32(mountain.name))`.

No player input, no runtime state, or gameplay randomness is needed to recover them.

From the code, we can infer that:

- Each mountain has exactly 5 treasures.
- Their elevations and horizontal offsets are reproducible.
- You can compute them offline.

Each treasure is placed at `(elevation, horizontal_position)`, where:

- `elevation` is an absolute mountain elevation.
- `horizontal_position` is a signed horizontal offset.

From before, we know that this location is converted into a linear treasure identifier:
```
treasure_id = elevation * mountain_width + horizontal_position
```

The linear `treasure_id` derived from its location is what feeds into the flag encoding logic.

### Alternate Source Code Recovery
With the help from an AI-powered tool with the DeepSeek model, I was able to convert the [`FreeSki.pyasm`](./FreeSki.pyasm) file into a [`FreeSki-deepseek.py`](./FreeSki-deepseek.py) Python script.

With this file, we can confirm that the bytecode analysis above is accurate.

---

## Solution

Here is a summary of the reverse engineering findings:

1. Each mountain contains an `encoded_flag` (byte string).

2. The flag is decoded by XORing each byte with a PRNG stream:
   ```python
   decoded[i] = encoded_flag[i] ^ random.randint(0, 255)
   ```

3. The PRNG is seeded with a value (`product`) derived from collected treasures:
   ```python
   product = (product << 8) ^ treasure_value
   ```

4. Treasure values are NOT random at runtime. They are deterministically generated:
   - RNG seeded with CRC32(`mountain_name`)
   - 5 treasure positions generated via pseudo-random deltas

5. Each treasure is represented as a 2D coordinate:
   ```
   (elevation, horizontal_position)
   ```

6. The game converts this into a 1D integer:
   ```
   treasure_id = elevation * 1000 + horizontal_position
   ```

7. The ordered list of these 5 treasure IDs forms the key used to decode the flag.

The [`get_flag.py`](./get_flag.py) Python script reconstructs the flag generation logic from the FreeSki challenge and replicates the entire pipeline for all seven (7) mountains identified:
```
mountain → treasure locations → treasure IDs → product → RNG → decoded flag
```

Here is the output:
```
============================================================
Mount Snow (Height: 3586)
Treasure locations:
------------------------------------------------------------
  Treasure 1:
    Elevation:  2966
    Horizontal:  113
    ID:      2966113
  Treasure 2:
    Elevation:  2420
    Horizontal:   85
    ID:      2420085
  Treasure 3:
    Elevation:  1718
    Horizontal:  188
    ID:      1718188
  Treasure 4:
    Elevation:  1094
    Horizontal:  142
    ID:      1094142
  Treasure 5:
    Elevation:   466
    Horizontal:   85
    ID:       466085

Decoded Flag:
frosty_yet_predictably_random

============================================================
Aspen (Height: 11211)
Treasure locations:
------------------------------------------------------------
  Treasure 1:
    Elevation: 10865
    Horizontal:  -43
    ID:     10864957
  Treasure 2:
    Elevation: 10529
    Horizontal: -122
    ID:     10528878
  Treasure 3:
    Elevation:  9903
    Horizontal: -102
    ID:      9902898
  Treasure 4:
    Elevation:  9183
    Horizontal:  -61
    ID:      9182939
  Treasure 5:
    Elevation:  8621
    Horizontal:  -15
    ID:      8620985

Decoded Flag:
jÆÀ0î'Zsv4&Ùo9`\	ÿg´

============================================================
Whistler (Height: 7156)
Treasure locations:
------------------------------------------------------------
  Treasure 1:
    Elevation:  6373
    Horizontal: -141
    ID:      6372859
  Treasure 2:
    Elevation:  6127
    Horizontal: -150
    ID:      6126850
  Treasure 3:
    Elevation:  5897
    Horizontal: -119
    ID:      5896881
  Treasure 4:
    Elevation:  5610
    Horizontal: -145
    ID:      5609855
  Treasure 5:
    Elevation:  5124
    Horizontal: -184
    ID:      5123816

Decoded Flag:
HáOA
ÎblÚV<lÝOÒ¸.ÿp±

============================================================
Mount Baker (Height: 10781)
Treasure locations:
------------------------------------------------------------
  Treasure 1:
    Elevation:  9997
    Horizontal:  -31
    ID:      9996969
  Treasure 2:
    Elevation:  9525
    Horizontal:  -69
    ID:      9524931
  Treasure 3:
    Elevation:  9112
    Horizontal:   -3
    ID:      9111997
  Treasure 4:
    Elevation:  8523
    Horizontal:  106
    ID:      8523106
  Treasure 5:
    Elevation:  7856
    Horizontal:  -45
    ID:      7855955

Decoded Flag:
çj=#ú%m²xæÙC3¸¬ÜÇ

============================================================
Mount Norquay (Height: 6998)
Treasure locations:
------------------------------------------------------------
  Treasure 1:
    Elevation:  6642
    Horizontal:  -67
    ID:      6641933
  Treasure 2:
    Elevation:  5901
    Horizontal:  -13
    ID:      5900987
  Treasure 3:
    Elevation:  5692
    Horizontal:   -8
    ID:      5691992
  Treasure 4:
    Elevation:  5486
    Horizontal:  -57
    ID:      5485943
  Treasure 5:
    Elevation:  5115
    Horizontal: -146
    ID:      5114854

Decoded Flag:
ðJ ©yÍ¯ZSë6éÃò&3;«°Ä§Öµ

============================================================
Mount Erciyes (Height: 12848)
Treasure locations:
------------------------------------------------------------
  Treasure 1:
    Elevation: 12235
    Horizontal:   10
    ID:     12235010
  Treasure 2:
    Elevation: 11950
    Horizontal:  -38
    ID:     11949962
  Treasure 3:
    Elevation: 11660
    Horizontal:  -22
    ID:     11659978
  Treasure 4:
    Elevation: 11412
    Horizontal:  -16
    ID:     11411984
  Treasure 5:
    Elevation: 10701
    Horizontal:  -47
    ID:     10700953

Decoded Flag:
§-ë/# îÒl_rªß@*¶ðJùæÖ¸¿ø

============================================================
Dragonmount (Height: 16282)
Treasure locations:
------------------------------------------------------------
  Treasure 1:
    Elevation: 15590
    Horizontal: -111
    ID:     15589889
  Treasure 2:
    Elevation: 14939
    Horizontal: -184
    ID:     14938816
  Treasure 3:
    Elevation: 14634
    Horizontal: -193
    ID:     14633807
  Treasure 4:
    Elevation: 14339
    Horizontal: -247
    ID:     14338753
  Treasure 5:
    Elevation: 13706
    Horizontal: -280
    ID:     13705720

Decoded Flag:

çnf¿üãß8¦âù].ûÐ ¿Ù]éb
```

### Answer
The flag is:
```
frosty_yet_predictably_random
```

Found on Mount Snow, which is the only mountain whose decoded output is readable ASCII.

---

## Outro

**Olivia**

Looks like you found your own way down that mountain... and maybe took a few shortcuts along the way. No judgment here—sometimes the clever path IS the right path. Now I'm one step closer to figuring out my own mystery. Thanks for the company, friend!

---

## Files

| File | Description |
|---|---|
| [`FreeSki.exe`](./FreeSki.exe) | Python application binary to reverse engineer |
| [`pyinstxtractor.py`](./pyinstxtractor.py) | Python script to extract the contents of a PyInstaller generated executable file |
| [`FreeSki.pyasm`](./FreeSki.pyasm) | Bytecode disassembly extracted from the application binary |
| [`FreeSki-deepseek.py`](./FreeSki-deepseek.py) | Python code reverse engineered from the bytecode using an AI-powered tool |
| [`get_flag.py`](./get_flag.py) | Python script that replicates the flag decoding game logic to recover the value needed to complete the challenge |

---

## References

- [`ctf-techniques/reverse/`](../../../../../ctf-techniques/reverse/README.md) — PyInstaller unpacking, bytecode disassembly with pycdc/pycdas, AI-assisted source reconstruction
- [`ctf-techniques/crypto/`](../../../../../ctf-techniques/crypto/README.md) — XOR decryption with PRNG-seeded keystream

---

## Navigation

| |
|:---|
| ← [On the Wire](../on-the-wire/README.md) |
