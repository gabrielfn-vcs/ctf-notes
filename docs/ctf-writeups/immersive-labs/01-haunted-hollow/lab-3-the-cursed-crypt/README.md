# Lab 3 - The Cursed Crypt

## Table of Contents
- [Lab 3 - The Cursed Crypt](#lab-3---the-cursed-crypt)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [The First Riddle](#the-first-riddle)
    - [1st Riddle: Encoded Message](#1st-riddle-encoded-message)
    - [1st Riddle: Clues](#1st-riddle-clues)
    - [1st Riddle: Analysis](#1st-riddle-analysis)
    - [1st Riddle: Answer](#1st-riddle-answer)
  - [The Second Riddle](#the-second-riddle)
    - [2nd Riddle: Encoded Message](#2nd-riddle-encoded-message)
    - [2nd Riddle: Clues](#2nd-riddle-clues)
    - [2nd Riddle: Analysis](#2nd-riddle-analysis)
    - [2nd Riddle: Answer](#2nd-riddle-answer)
  - [The Third Riddle](#the-third-riddle)
    - [3rd Riddle: Encoded Message](#3rd-riddle-encoded-message)
    - [3rd Riddle: Clues](#3rd-riddle-clues)
    - [3rd Riddle: Analysis](#3rd-riddle-analysis)
    - [3rd Riddle: Answer](#3rd-riddle-answer)
  - [The Fourth Riddle](#the-fourth-riddle)
    - [4th Riddle: Encoded Message](#4th-riddle-encoded-message)
    - [4th Riddle: Clues](#4th-riddle-clues)
    - [4th Riddle: Analysis](#4th-riddle-analysis)
    - [4th Riddle: Answer](#4th-riddle-answer)
  - [Navigation](#navigation)

---

## Overview

The purpose of this lab is to resolve riddles using different encoding and encryption methods.

---

## The First Riddle

### 1st Riddle: Encoded Message
`H4sIACDaJ2UA/12P/bGDMAzDV9EIkDg2jNNysP8ISHZa3utd/gg/FH2MgA/4odMWuMEv+CnYijREg68IT7ggujSRr0oT+yQtHpn3+ZAXf2eKpZgR26NRHAk/V5Hx9y+78U5nWpEfCpJD8T05ZUNB0rPG+RshcfKZzkrUZ0l1o2f/N6Gsvs5aYZ8hNZadi5eVob/ELWAb7MLoWtHOG8fDXR1bAQAA`

### 1st Riddle: Clues
"On this eerie Halloween night, a cryptic clue takes flight. I'm not a witch, nor a black cat's hiss, but a trio of tools in the cryptographer's abyss.

First, I'm a code of six and four, used in data lore.
Next, I'm a compressor's release, where file sizes cease.
Lastly, I'm a system of sixteen, in the coder's routine.

Unravel me if you can, for I am the cryptographer's plan."

### 1st Riddle: Analysis
1. The first clue indicates that the given message is using Base64 encoding.
2. The second clue indicates that the result of decoding the message is a Zlib compressed message.
3. The third clue indicates that the result of decompressing the message is a series of Hexadecimal values.
4. The result of removing spaces, converting hex values to bytes and decoding to a string provides the answer.

### 1st Riddle: Answer
Running the [`first_riddle.py`](./first_riddle.py) Python script, we get the following answer:
```
Well done, brave soul, you've cracked the code! The ghostly whisper in the wind reveals your spectral secret: GHOST.
```

---

## The Second Riddle

### 2nd Riddle: Encoded Message
`..... -----:-.... ..---:-.... .----:--... ....-:-.... .....:-.... .:-.... --...:-.... ---..:--... ----.:-.... .:-.... --...:--... -....:-.... ..---:-.... .----:-.... -....:..--- -.-.:..--- -----:--... ...--:--... ..---:-.... .:-.... .....:--... ----.:--... ..---:-.... -....:-.... -....:..--- -----:--... -----:-.... .....:-.... -.-.:-.... ...--:-.... --...:-.... ..---:--... ....-:-.... .....:-.... .:-.... ...--:--... .....:--... ..---:-.... .....:..--- .----:..--- -----:....- --...:--... .....:--... ..---:..--- -----:-.... -....:-.... ...--:--... -....:-.... .....:--... -....:-.... --...:-.... -....:..--- -----:--... .....:-.... .:-.... ----.:--... ..---:..--- -----:-.... -....:-.... ...--:-.... ..---:--... ---..:--... ..---:-.... .----:..--- -.-.:..--- -----:-.... .:-.... .----:--... .----:..--- -----:-.... -.-.:-.... ..---:-.... ---..:-.... .....:..--- -----:-.... ---..:-.... .----:--... ..---:-.... .:-.... .....:-.... --...:--... .....:--... ----.:-.... -.-.:..--- -----:-.... .....:--... ..---:-.... ----.:--... ..---:--... ----.:-.... .:-.... --...:--... -....:-.... ..---:-.... .----:..--- -----:--... ..---:--... .-:--... ..---:-.... .....:--... ....-:--... ..---:-.... -....:..--- -----:--... ...--:-.... .....:-.... ..---:--... .-:..--- -----:-.... --...:--... .....:--... ..---:..--- -----:-.... -....:--... .....:-.... .:--... .----:-.... ..---:-.... .-:-.... -....:...-- .-:..--- -----:....- -....:....- ...--:..... ..---:..... -----:....- --...:..... ..---:....- .....:..--- .`

### 2nd Riddle: Clues
"In the shadowy depths of this All Hallows' Eve, a cryptic puzzle we weave. Not a specter, nor a ghoul's mischieve, but a trio of steps for you to achieve.

First, a system of dots and dashes, used in telegraphic flashes.
Next, a transformation to code, where characters are bestowed.
Finally, a cipher of thirteen's rotation, a simple form of obfuscation.

Unravel this riddle if you dare, in this cryptographer's haunted lair."

### 2nd Riddle: Analysis
1. The first clue indicates that the given message is using Morse code.
2. The second clue indicates that the result of decoding the message is a series of Hexadecimal values with a scrambled message.
3. The third clue indicates that the scrmabled message is using a ROT13 ("rotate by 13 places") substitution cipher.
4. Applying ROT13 to the scrambled text provides the answer.

### 2nd Riddle: Answer
Running the [`second_riddle.py`](./second_riddle.py) Python script, we get the following answer:
```
Congratulations, fearless cryptographer! The spirits have spoken, and your unearthly revelation emerges from the shadows: SPECTER.
```

---

## The Third Riddle

### 3rd Riddle: Encoded Message
`107 40 171 143 155 147 152 40 166 164 40 157 142 172 152 166 47 153 40 165 170 154 153 40 154 150 40 145 166 151 40 170 150 170 40 172 143 144 157 157 165 165 40 154 141 157 172 40 163 146 142 155 164 157 41 40 114 141 107 40 152 157 155 145 152 171 143 146 40 165 141 151 160 144 170 171 40 150 142 166 40 153 153 143 163 163 145 171 40 146 143 155 153 40 150 154 153 141 155 151 157 167 146 172 40 150 171 163 157 72 40 120 117 101 121 132 130 131 111 106 127 120 56`

### 3rd Riddle: Clues
"In the eerie silence of this Halloween night, a cryptic clue takes flight. I'm not a specter, nor a pumpkin's glow, but a duo of tools in the cryptographer's show.

First, a system of eight, a numerical state.
Next, I'm a cipher with a spectral key, a Frenchman's name for this cipher's fame.

Decipher me if you dare, for I am the cryptographer's affair."

### 3rd Riddle: Analysis
1. The first clue indicates that the given message is octal text.
2. The second clue indicates that the result of decoding the message into ASCII is a message encrypted with the Vigenère cipher, where the key is a "spectral" value from a previous riddle:  `GHOST`.
3. The result of decrypting the message provides the answer.

### 3rd Riddle: Answer
Running the [`third_riddle.py`](./third_riddle.py) Python script, we get the following answer:
```
A round of witch's brew to you for solving this enigma! ThA cauldron bubbles and reveals your bewitching brew: WITCHESBREW.
```

---

## The Fourth Riddle

### 4th Riddle: Encoded Message
`GM3DGNZSGAZTCMZSGM2TEMBTGEZTAMZYGIYDGMJTGAZTGMRQGMYTGMRTGMZDAMZUGMYDEMBTGEZTEMZUGIYDGMJTGAZTGMRQGM2DGMBSGAZTCMZRGMZTEMBTGEZTAMZTGIYDGMJTGIZTKMRQGMZTGNRSGAZTIMZQGIYDGMJTGAZTOMRQGMYTGMRTGIZDAMZRGMYTGMZSGAZTCMZSGMYDEMBTGEZTEMZUGIYDGOJTG4ZDAMZRGMYDGNZSGAZTIMZQGIYDGMJTGAZTSMRQGMYTGMJTGIZDAMZRGMZDGMBSGAZTCMZQGMYDEMBTGEZTAMZTGIYDGMJTGIZTEMRQGMYTGMBTHEZDAMZRGMZDGMRSGAZTIMZQGIYDGOJTGIZDAMZZGM3DEMBTGEZTAMZZGIYDGNBTGAZDAMZRGMYDGNZSGAZTCMZQGM2TEMBTGEZTAMZSGIYDGMJTGAZTQMRQGMYTGMBTGAZDAMZRGMYDGOJSGAZTCMZSGMZTEMBTGQZTAMRQGMYTGMJTGEZDAMZRGMYDGMBSGAZTCMZQGMZTEMBTGEZTEMZXGIYDGNBTGAZDAMZZGM3TEMBTGEZTAMZQGIYDGMJTGAZTAMRQGMYTGMRTGUZDAMZRGMYDGMJSGAZTSMZXGIYDGMJTGAZTEMRQGMYTGMBTGUZDAMZRGMZDGNBSGAZTCMZQGM4TEMBTGEZTEMZTGIYDGNBTGAZDAMZRGMYTGMZSGAZTCMZQGMZTEMBTGEZTEMZVGIYDGMJTGIZTEMRQGM2DGMBSGAZTCMZQGMYDEMBTGEZTAMZVGIYDGMJTGAZTEMRQGMYTGMRTGQZDAMZRGMYDGOJSGAZTCMZSGMZDEMBTGEZTAMZSGIYDGNBTG4ZDAMZRGMZDGMZSGAZTIMZQGIYDGMJTGAZTAMRQGMYTGMBTGMZDAMZRGMZDGMRSGAZTCMZQGM4TEMBTGUZTAMRQGM2DGMBSGAZTQMZYGIYDGOJTGMZDAMZWGM4TEMBTHAZTQMRQGM3DGNZSGAZTMMZVGIYDGNZTGAZDAMZTGM4A====`

### 4th Riddle: Clues
"In the chilling darkness of this Halloween night, a cryptic clue takes flight. Not a specter, nor a witch's delight, but a quartet of tools in the cryptographer's sight.

First, I transform to a base of thirty-two, a more complex view.
Next, I'm a conversion to a system of sixteen in the coder's routine.
Then, I'm a conversion to a base of ten, a system known to many.
Lastly, I'm an operation of exclusive disjunction, a bitwise function.

Decode me if you dare, for I am the cryptographer's scare."

### 4th Riddle: Analysis
1. The first clue indicates that the given message is using Base32 encoding.
2. The second clue indicates that the result of decoding the message is a series of Hexadecimal values.
3. The third clue indicates that Hexadecimal values need to be converted into Decimal values as characters in a string.
4. The fourth clue indicates that we need a Brute Force XOR applied to the Decimal text message to get the answer.

### 4th Riddle: Answer
Running the [`fourth_riddle.py`](./fourth_riddle.py) Python script, we get the following answer: 
`Kudos to you, cryptic explorer The candles glow illuminates your lantern's lore: PUMPKIN.`

---

## Navigation

| | |
|:---|---:|
| ← [Python Pit](../lab-2-python-pit/README.md) | [Escape from jAWS!](../lab-4-escape-from-jaws/README.md) → |
