# Retro Recovery

## Table of Contents
- [Retro Recovery](#retro-recovery)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Introduction](#introduction)
  - [Items](#items)
  - [Hints](#hints)
    - [Hint 1: Mounting Disk Images](#hint-1-mounting-disk-images)
    - [Hint 2: File Recovery Tools](#hint-2-file-recovery-tools)
  - [Analysis](#analysis)
    - [The File Image](#the-file-image)
    - [Looking for Deleted Content](#looking-for-deleted-content)
  - [Solution](#solution)
  - [Outro](#outro)
  - [Files](#files)
  - [References](#references)
  - [Navigation](#navigation)

---

## Overview
Join Mark in the retro shop. Analyze his disk image for a blast from the retro past and recover some classic treasures.

## Introduction

**Mark DeVito**

I am an avid collector of things of the past. I love old technology. I love how it connects us to the past. Some remind me of my dad, who was an engineer on the Apollo 11 mission and helped develop the rendezvous and altimeter radar on the space craft.

If you ever get into collecting things like vintage computers, here is a tip. Never forget to remove the RIFA capacitors from vintage computer power supplies when restoring a system. If not they can pop and fill the room with nasty smoke.

I love vintage computing, it’s the very core of where and when it all began. I still enjoy writing programs in BASIC and have started re-learning Apple II assembly language. I started writing code in 1982 on a Commodore CBM.

Sometimes it is the people no one can imagine anything of who do the things no one can imagine. - Alan Turing

You never forget your first 8-bit system.

There's something in the works. Come see me later and we'll talk.

While Kevin and I were cleaning up the Retro Store, we found this FAT12 floppy disk image, must have been under this arcade machine for years. These disks were the heart of machines like the Commodore 64. I am so glad you can still mount them on a modern PC.

When I was a kid we shared warez by hiding things as deleted files.

I remember writing programs in BASIC. So much fun! My favorite was Star Trek.

The beauty of file systems is that 'deleted' doesn't always mean gone forever.

Ready to dive into some digital archaeology and see what secrets this old disk is hiding?

Go to Items in your badge, download the floppy disk image, and see what you can find!

## Items

There is now a [floppy.img](./floppy.img) in the Items section of the badge with the message:
```
You got yourself a floppy disk image from an old IBM PC! Retro!
```

## Hints

### Hint 1: Mounting Disk Images
I miss old school games. I wonder if there is anything on this disk? I remember, when kids would accidentally delete things, it wasn't too hard to recover files. I wonder if you can still mount these disks?

### Hint 2: File Recovery Tools
I know there are still tools available that can help you find deleted files. Maybe that might help. Ya know, one of my favorite games was a Quick Basic game called Star Trek.

---

## Analysis

### The File Image

The image can be mounted on macOS and it shows the following content.
```bash
drwx------  1    - ctfuser  1 Jan  1980  /Volumes/'NO NAME'/
drwx------  1    - ctfuser  2 Mar 16:50 ├──  .fseventsd/
.rwx------  1   36 ctfuser  2 Mar 16:50 │   └── 󰡯 fseventsd-uuid*
drwx------  1    - ctfuser  2 Mar 16:40 └──  qb45/
.rwx------  1  97k ctfuser 18 Mar  2025     ├──  BC.EXE*
.rwx------  1  77k ctfuser 18 Mar  2025     ├──  BRUN45.EXE*
.rwx------  1  36k ctfuser 18 Mar  2025     ├──  LIB.EXE*
.rwx------  1  69k ctfuser 18 Mar  2025     ├──  LINK.EXE*
.rwx------  1  15k ctfuser 18 Mar  2025     ├──  MOUSE.COM*
.rwx------  1 9.5k ctfuser 18 Mar  2025     ├──  PACKING.LST.txt*
.rwx------  1 279k ctfuser 18 Mar  2025     ├──  QB.EXE*
.rwx------  1   69 ctfuser 18 Mar  2025     └── 󱁻 QB.INI*
```

The files are the Quick Basic runtime environment. However, there is nothing that points to the Star Trek game mentioned in the hints.

### Looking for Deleted Content

The hint mentions something about deleting files.

Let's look at the content of the image using the `strings` command.

It starts with some boilerplate floppy header information:
````
mkfs.fat
NO NAME    FAT12   
This is not a bootable disk.  Please insert a bootable floppy and
press any key to try again ... 
````

Followed by some gibberish and then the beginning of what looks like Quick Basic code.
```basic
[...]
all_i-want_for_christmas.bas
1 REM original file superstartrek.bas dated 2/13/2009 from bcg.tar.gz
2 REM QBasic conversion by WTN...
3 REM 2/16/2021 - uncrunched, changed B9=2 to B9=0, added RANDOMIZE and SLEEP
4 REM incorporated instructions from superstartrekins.bas
5 REM 2/19/2021 - changed the code after DO YOU NEED INSTRUCTIONS?
10 REM SUPER STARTREK - MAY 16,1978 - REQUIRES 24K MEMORY
30 REM
40 REM ****        **** STAR TREK ****        ****
50 REM **** SIMULATION OF A MISSION OF THE STARSHIP ENTERPRISE,
60 REM **** AS SEEN ON THE STAR TREK TV SHOW.
70 REM **** ORIGIONAL PROGRAM BY MIKE MAYFIELD, MODIFIED VERSION
80 REM **** PUBLISHED IN DEC'S "101 BASIC GAMES", BY DAVE AHL.
90 REM **** MODIFICATIONS TO THE LATTER (PLUS DEBUGGING) BY BOB
100 REM *** LEEDOM - APRIL & DECEMBER 1974,
110 REM *** WITH A LITTLE HELP FROM HIS FRIENDS . . .
120 REM *** COMMENTS, EPITHETS, AND SUGGESTIONS SOLICITED --
130 REM *** SEND TO:  R. C. LEEDOM
140 REM ***           WESTINGHOUSE DEFENSE & ELECTRONICS SYSTEMS CNTR.
150 REM ***           BOX 746, M.S. 338
160 REM ***           BALTIMORE, MD  21203
170 REM ***
180 REM *** CONVERTED TO MICROSOFT 8 K BASIC 3/16/78 BY JOHN GORDERS
190 REM *** LINE NUMBERS FROM VERSION STREK7 OF 1/12/75 PRESERVED AS
200 REM *** MUCH AS POSSIBLE WHILE USING MULTIPLE STATEMENTS PER LINE
205 REM *** SOME LINES ARE LONGER THAN 72 CHARACTERS; THIS WAS DONE
210 REM *** BY USING "?" INSTEAD OF "PRINT" WHEN ENTERING LINES
211 REM bWVycnkgY2hyaXN0bWFzIHRvIGFsbCBhbmQgdG8gYWxsIGEgZ29vZCBuaWdodAo=
215 REM ***
[...]
```

The whole file is extracted under [all_i-want_for_christmas.bas](./all_i-want_for_christmas.bas).

---

## Solution

At the end of the comment block, there is a Base64 encoded text:
```
bWVycnkgY2hyaXN0bWFzIHRvIGFsbCBhbmQgdG8gYWxsIGEgZ29vZCBuaWdodAo=
```

After decoding it, the following message appears:
```
merry christmas to all and to all a good night
```

This is the answer to the challenge.

---

## Outro

**Mark Devito**

Excellent work! You've successfully recovered that deleted file and decoded the hidden message.

Sometimes the old ways are the best ways. Vintage file systems never truly forget what they've seen. Play some Star Trek... it actually works.

Excellent! You've recovered every secret with vintage precision - you never forget your first challenge victory, just like your first 8-bit system!

---

## Files

| File | Description |
|---|---|
| `floppy.img` | FAT12 floppy disk image containing the Quick Basic environment and a deleted Star Trek BASIC program |
| `all_i-want_for_christmas.bas` | Deleted BASIC file recovered from the disk image containing the hidden Base64 message |

---

## References

- [`ctf-techniques/forensics/`](../../../../../ctf-techniques/forensics/README.md) — disk image mounting and file carving techniques
- [`ctf-techniques/crypto/`](../../../../../ctf-techniques/crypto/README.md) — Base64 decoding reference
- [FAT12 file system](https://en.wikipedia.org/wiki/File_Allocation_Table#FAT12) — file system used by the floppy disk image
- [strings man page](https://linux.die.net/man/1/strings) — used to extract readable content from the binary image
- [Super Star Trek — original BASIC program](http://www.vintage-basic.net/bcg/superstartrek.bas) — the source code of the game hidden on the disk
- [Star Trek (1971)](https://en.wikipedia.org/wiki/Star_Trek_(1971_video_game)) — information about the game hidden on the disk

---

## Navigation

| |
|---:|
| [Rogue Gnome Identity Provider](../rogue-gnome-identity-provider/README.md) → |
