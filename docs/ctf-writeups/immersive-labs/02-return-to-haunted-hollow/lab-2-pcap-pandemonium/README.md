# Lab 2 - PCAP Pandemonium

## Table of Contents
- [Lab 2 - PCAP Pandemonium](#lab-2---pcap-pandemonium)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
  - [Running the Application](#running-the-application)
  - [First Monster](#first-monster)
  - [Second Monster](#second-monster)
  - [Third Monster](#third-monster)
  - [Fourth Monster](#fourth-monster)
    - [Hats](#hats)
      - [Hats File](#hats-file)
      - [Hats Clue](#hats-clue)
      - [Hats Message](#hats-message)
    - [Scarves](#scarves)
      - [Scarves File](#scarves-file)
      - [Scarves Clue](#scarves-clue)
      - [Scarves Message](#scarves-message)
    - [Jackets](#jackets)
      - [Jackets File](#jackets-file)
      - [Jackets Clue](#jackets-clue)
      - [Jackets Message](#jackets-message)
    - [Gloves](#gloves)
      - [Gloves File](#gloves-file)
      - [Gloves Clue](#gloves-clue)
      - [Gloves Message](#gloves-message)
    - [Bag 1](#bag-1)
      - [Bag 1 File](#bag-1-file)
      - [Bag 1 Clue](#bag-1-clue)
      - [Bag 1 Message](#bag-1-message)
    - [Bag 2](#bag-2)
      - [Bag 2 File](#bag-2-file)
      - [Bag 2 Clue](#bag-2-clue)
      - [Bag 2 Message](#bag-2-message)
    - [Bag 3](#bag-3)
      - [Bag 3 File](#bag-3-file)
      - [Bag 3 Clue](#bag-3-clue)
      - [Bag 3 Message](#bag-3-message)
  - [Solution](#solution)
  - [Navigation](#navigation)

---

## Overview

This lab provides a terminal that drives the flow of execution.

---

## Analysis

We will use Wireshark to open the packet capture (PCAP) files and do a search for:
```
Display filter: frame matches "[a-zA-Z]:[a-zA-Z]"
```

---

## Running the Application

```bash
$ sudo /opt/ZIPPY
```

Hello there! Welcome to the Haunted Hollow Robot Petting Zoo!

My name is ZIPPY and I'm the zookeeper here. This was the first ever zoo where both the staff and the animals were robots! Our latest exhibition showed visitors what we thought different monsters would look like. 
Unfortunately when the AI turned evil, the robot monsters all escaped and hid in the Records Room. I'd go in to get them, but if I leave this room the AI will notice I'm still here and come after me!

I can give you the code you need, but only if you help me get my monsters back under control.

Will you help me? (yes/yes)
yes

In each file in the Record Room there is a single monster hiding in the records. Your task is to find the robot in each file and return it to me.

Each answer will be formatted as `'monster name':'food item'`, and must be exactly the same as found.

Lets get started!

---

## First Monster

The first monster ran and hid in the recycling bin - you'll need to sort through the junk in there to find them...

Have you found the monster?

**Token:** `Yeti:Carrots`

You found them!

---

## Second Monster

The second monster fell into the receipt records, which is quite a messy box! You'll need to ignore the rubbish and check through the receipts to find the monster.

Have you found the monster?

**Token:** `Zombie:Cranberries`

You found them!

---

## Third Monster

The third monster left a trail of breadcrumbs inside the file cabinet in case one of the other monsters tried to find them. You can find the first clue at the beginning of the file.

Have you found the monster?

Congratulations - you have completed the quiz! Your flag is: `Witch:Cabbages`

**Token:** `Witch:Cabbages`

You found them!

---

## Fourth Monster

The fourth monster was last seen amongst the **hats** in the lost and found box. All the items in there are tagged, but the text has become scrambled! You are going to have to decrypt each tag in order to find the monster...

Have you found the monster?

### Hats

#### Hats File
```
5553455220757365720d0a
-> USER user

504153532031323334350d0a
-> PASS 12345
```
```
5245545220686174732e7478740d0a
-> RETR hats.txt
56325673593239745a5345675247566a6232526c49475668593267675a6d6c735a5342706269423064584a754948567a6157356e4948526f5a53426a6248566c4948427962335a705a47566b4f79423061475567626d5634644342776247466a5a5342306279426a6147566a6179427063794270626942306147556763324e68636e5a6c63793467553239745a5342765a694230614756744947787662327367633238676232786b4948526f5a586b676258567a6443426f59585a6c49474a6c5a5734676447686c636d556763326c75593255676447686c49464a76625746754947567463476c795a53453d3d
```

#### Hats Clue
Hex -> Base64

#### Hats Message
Welcome! Decode each file in turn using the clue provided; the next place to check is in the **scarves**. Some of them look so old they must have been there since the Roman empire!

### Scarves

#### Scarves File

```
5245545220736361727665732e7478740d0a
-> RETR scarves.txt
4f776464207667667721204c7a616b206b75736a78276b206c7379206f736b207766756a71686c7776206f616c7a2073204a67657366207561687a776a2c20746d6c206c7a7720676f66776a206778206c7a616b2062737563776c20686a7778776a6b207320786a7766757a207561687a776a2e200d0a4c7a772063777120616b2077696a6c6b632e
```
#### Scarves Clue
Hex -> Caesar cipher (shift 8)

#### Scarves Message
Well done! This scarf's tag was encrypted with a Roman cipher, but the owner of this jacket prefers a french cipher. 

The key is `eqrtsk`.

### Jackets

#### Jackets File
```
52455452206a61636b6574732e7478740d0a
-> RETR jackets.txt
4765696b776d7821204a797820666f626a20746268726968207a6c20776669642064686a6f20716575786a78202d206d6a206e746b2073726c76676c6f68207965203139303121204d7a6f206f75702079676220787876207a64797a756a20626b206962726f746a2e
```
#### Jackets Clue
Hex -> Vigenère Decode (key `eqrtsk`)

#### Jackets Message
Correct! The next cipher is even more modern - it was invented in 1901! The key for the gloves is `yxbxar`.

### Gloves

#### Gloves File
```
5245545220676c6f7665732e7478740d0a
-> RETR gloves.txt
41747820626c732077766373776c206769206c73612064736f61726920616120767069206c65716920637963207a76696c6f20626c672120496b7220676974667120766520636c6167696f2066676c7866762071207574782c20796b632078756e626f20746e663f204478692063622075697874206463757220646c6c76636e632078622e2e2e0d0a516f6e20627470206d67203820777a6320796b6820676e636266732068672031362e
```

#### Gloves Clue
Hex -> Bifid Cipher Decode (key `yxbxar`)

#### Gloves Message
You are almost to the bottom of the lost and found box! The robot is hiding inside a bag, but which one? All of them have zigzags on...

The key is 8 and the offset is 16.

### Bag 1

#### Bag 1 File
```
5245545220626167312e7478740d0a
-> RETR bag1.txt
486e425049476f7341434f51534a466d7420444e52523a45206521454d53514b446f7265464c504c434e7372474b4f4d42202065484a4e416849
```
#### Bag 1 Clue
Hex -> Rail Fence Cipher Decode(key 8, offset 16)

#### Bag 1 Message
SRQPONMLK:JIHGFEDCBA No monsters here! ABCDEFGHIJKLMNOPQRS

### Bag 2

#### Bag 2 File
```
5245545220626167322e7478740d0a
-> RETR bag2.txt
4761424f4846626741434e50534945202020444d51524a44736921454c52514b43697379464b53504c42682074473a4f4d41546570484a4e206d49
```
#### Bag 2 Clue
Hex -> Rail Fence Cipher Decode(key 8, offset 16)

#### Bag 2 Message
SRQPONMLKJIHGFEDCBA This bag is empty! ABCDEFGHIJ:KLMNOPQRS

### Bag 3

#### Bag 3 File
```
5245545220626167332e7478740d0a
-> RETR bag3.txt
45213a694820522073206b6559544c455969566f734f2041546f20616f5544535375676d43204e544e7261703a4655204f206c69654f4d6672
```

#### Bag 3 Clue
Hex -> Rail Fence Cipher Decode(key 8, offset 16)

#### Bag 3 Message
YOU FOUND THE LAST MONSTER! Your flag is: `Vampire:Cookies`

**Token:** `Vampire:Cookies`

You found them!

---

## Solution

Thank you for your help! You've saved the zoo!

Here is a code you might need when you get further into the park: `Z1pPyTh3Zo0kE£peR!`

I also have a code that will let you out the employee gate - it's faster than walking around the zoo.

The code is `1d6cfd`

Good luck - you are going to need it!

---

## Navigation

| | |
|:---|---:|
| ← [Phishing for Treats](../lab-1-phishing-for-treats/README.md) | [Delving Deeper](../lab-3-delving-deeper/README.md) → |
