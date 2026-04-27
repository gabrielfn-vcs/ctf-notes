# Holiday Hack Challenge 2025

## Table of Contents
- [Holiday Hack Challenge 2025](#holiday-hack-challenge-2025)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Acts](#acts)
  - [All Challenges](#all-challenges)
  - [Story Arc](#story-arc)
  - [References](#references)

---

## Overview

**SANS Holiday Hack Challenge 2025** — *Gnomes Gone Rogue*

Way back in 2015, the mysterious Atnas Corporation almost ruined the entire holiday season through their nefarious Gnome In Your Home plot. Their villainy centered upon convincing parents to purchase little Gnome dolls that played joyful holiday songs to their children. With Gnome sales topping two million units, a blitz of Atnas Corp advertisements encouraged parents to move their Gnomes around the house daily so that their children could hunt for them in a fun little game. Little did parents know that these Gnomes were snooping IoT devices with a camera and wireless internet access, furtively sending photos to burglars who would rob their houses of their treasures en masse on Christmas Eve, 2015. The incredible efforts of SANS Holiday Hack investigators around the world foiled the foul plot, exposing the criminal mastermind behind Atnas Corp: Cindy Lou Who, age 62.

But those old Gnomes didn't disappear. They lay discarded, gathering dust on shelves, in attics, and among other forgotten places throughout the world. Until now. There must have been some magic in those Gnomes, because, due to some unseen spark, some haunting hocus pocus, the Gnomes have quickened and are now walking among us! We now return with the Counter Hack Crew to the Duke Dosis neighborhood as the Holiday Season 2025 unfolds.

> **Note:** This writeup focuses on the challenges found most interesting and from which the most was learned. Not every challenge across all acts is covered.

---

## Acts

| Act | Theme | Challenges |
|---|---|---|
| `act-i/` | The Invasion — Orientation and introduction to tools and techniques | Ten introductory objectives (difficulty 1/5) — not covered in this writeup |
| [`act-ii/`](./act-ii/README.md) | The Mystery — The gnomes start stealing refrigerator parts. Are they building something? | Seven objectives (difficulty 2/5): Retro Recovery, Rogue Gnome Identity Provider, Quantgnome Leap covered; others not included (Mail Detective, IDOrable Bistro, Dosis Network Down, Going in Reverse) |
| [`act-iii/`](./act-iii/README.md) | The Revelation — Frosty the Snowman's plan to freeze the neighborhood into permanent winter is exposed | Seven objectives (difficulty 3-5/5): Gnome Tea, Hack-a-Gnome, Schrödinger's Scope, On the Wire, Free Ski covered; others not included (Snowcat RCE & Priv Esc, Find and Shutdown Frosty's Snowglobe Machine) |
| `the-final-showdown/` | The Final Showdown — Exploit a chatbot to stop Frosty from freezing everything | One final objective: Snoblind Ambush — not covered in this writeup |

---

## All Challenges

| Challenge | Act | Category |
|---|---|---|
| [`act-ii/retro-recovery/`](./act-ii/retro-recovery/README.md) | II | Forensics / Disk Image |
| [`act-ii/rogue-gnome-identity-provider/`](./act-ii/rogue-gnome-identity-provider/README.md) | II | Web / JWT / Auth |
| [`act-ii/quantgnome-leap/`](./act-ii/quantgnome-leap/README.md) | II | Crypto / Post-Quantum |
| [`act-iii/gnome-tea/`](./act-iii/gnome-tea/README.md) | III | Web / Firebase / OSINT |
| [`act-iii/hack-a-gnome/`](./act-iii/hack-a-gnome/README.md) | III | Web / Injection / Reverse Engineering |
| [`act-iii/schroedingers-scope/`](./act-iii/schroedingers-scope/README.md) | III | Web / Pentest Methodology |
| [`act-iii/on-the-wire/`](./act-iii/on-the-wire/README.md) | III | Hardware / Protocols |
| [`act-iii/free-ski/`](./act-iii/free-ski/README.md) | III | Reverse Engineering |

---

## Story Arc

```
Act I — Holiday preparations have gone sideways. Thanks to some mysterious magical nonsense,
the Gnomes in Your Home are scurrying around the Neighborhood causing absolute chaos.
  └─ Introductory orientation challenges

Act II — Things get stranger. The gnomes start stealing refrigerator parts — not the whole
fridge, just specific components. Are they building something? The plot thickens.
  └─ Retro Recovery: mount a floppy disk image and recover a BASIC program
  └─ Rogue Gnome Identity Provider: exploit a rogue OIDC provider via JWT manipulation
  └─ Quantgnome Leap: break post-quantum cryptography to uncover the gnomes' scheme

Act III — Plot twist! Frosty the Snowman is behind the master plan to freeze the entire
neighborhood into a permanent winter wasteland.
  └─ Gnome Tea: infiltrate the GnomeTea social network; discover passphrase GigGigglesGiggler
  └─ Hack-a-Gnome: blind SQLi → root shell → CAN bus fix → factory shutdown
  └─ Schrödinger's Scope: responsible pentest across six vulnerability classes
  └─ On the Wire: decode 1-Wire → SPI → I2C signal chain to recover temperature 32.84
  └─ Free Ski: reverse PyInstaller binary → recover flag frosty_yet_predictably_random

The Final Showdown — Santa's compassionate offer to Frosty melts more than just snow; it
melts hearts, saving the Neighborhood and proving that kindness conquers all.
  └─ Exploit a chatbot to stop Frosty's freeze
```

---

## References

- [SANS Holiday Hack Challenge](https://www.sans.org/mlp/holiday-hack-challenge/) — official event page
- [`ctf-techniques/`](../../../ctf-techniques/README.md) — technique reference repo
