# Lab 8 - Haywire Host

## Table of Contents
- [Lab 8 - Haywire Host](#lab-8---haywire-host)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
  - [Challenge 1: Find environment variable](#challenge-1-find-environment-variable)
  - [Challenge 2: Find file under `/tmp`](#challenge-2-find-file-under-tmp)
  - [Challenge 3: Get strings from binary file in `/opt` and find one related to coconuts](#challenge-3-get-strings-from-binary-file-in-opt-and-find-one-related-to-coconuts)
  - [Challenge 4: Listen to server running on port 1337](#challenge-4-listen-to-server-running-on-port-1337)
  - [Challenge 5: Kill a process that changes name every second and get secret value from a file in `/tmp` after killing it](#challenge-5-kill-a-process-that-changes-name-every-second-and-get-secret-value-from-a-file-in-tmp-after-killing-it)
  - [Solution](#solution)

## Overview

This lab provides an environment that needs to be explored to find answers to the questions presented.

## Analysis

Can only use Python to run commands.

## Challenge 1: Find environment variable
- **Script:**
    ```python
    >>> import os
    >>> for name, value in os.environ.items():
    ...     print("{0}={1}".format(name, value))
    ```
- **Output:**
    ```bash
    SHELL=/bin/bash
    PWD=/home/iml-user
    LOGNAME=iml-user
    MOTD_SHOWN=pam
    HOME=/home/iml-user
    LANG=C.UTF-8
    SSH_CONNECTION=10.102.89.96 41484 10.102.124.208 22
    TERM=xterm-256color
    USER=iml-user
    SHLVL=1
    SSH_CLIENT=10.102.89.96 41484 22
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
    SSH_TTY=/dev/pts/1
    OH_HERE_IT_IS=f18a94
    _=/usr/bin/python3
    ```
- **Answer:**
    ```bash
    OH_HERE_IT_IS=f18a94
    ```

## Challenge 2: Find file under `/tmp`
- **Script:**
    ```python
    >>> import os
    >>> for root, dirs, files in os.walk('/tmp'):
    ...     for file in files:
    ...         print(os.path.join(root, file))
    ... 
    ```
- **Output:**
    ```bash
    /tmp/challenge-1/folder_3/folder_1/folder_4/ba9c1a
    ```
- **Answer:**
    ```bash
    ba9c1a
    ```

## Challenge 3: Get strings from binary file in `/opt` and find one related to coconuts
- **Script:**
    ```python
    >>> for root, dirs, files in os.walk('/opt'):
    ...     for file in files:
    ...         print(os.path.join(root, file))
    ... 
    ```
- **Output:**
    ```bash
    /opt/interact-host
    /opt/challenge-three
    ```
- **Answer:**
    ```bash
    /opt/challenge-three
    ```
- **Script:**
    ```python
    import sys, string

    fd = open('/opt/challenge-three', "rb")
    data = fd.read().decode("utf-8", "ignore")
    fd.close()

    printable = set(string.printable)

    found_str = ""
    for char in data:
        if char in printable:
            found_str += char
        elif len(found_str) >= 4:
            print(found_str)
            found_str = ""
        else:
            found_str = ""
    ```
- **Output:**
    ```
    /lib64/ld-linux-x86-64.so.2
    H?)ike$|
    libc.so.6
    puts
    __cxa_finalize
    __libc_start_main
    GLIBC_2.2.5
    _ITM_deregisterTMCloneTable
    __gmon_start__
    _ITM_registerTMCloneTable
    1I^HHPTL
    H=Q/
    H5J/
    H)HH?H
    u+UH=.
    Ht
    H=.
    UHH=
    AWL=;,
    AVIAUIATAUH-,,
    SL)H
    LLDA
    H9uH
    []A\A]A^A_ff.
    THROWINGCOCONUTSISTHEBEST
    Find the string!
    :*3$"
    GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0
    crtstuff.c
    deregister_tm_clones
    __do_global_dtors_aux
    completed.8061
    __do_global_dtors_aux_fini_array_entry
    frame_dummy
    __frame_dummy_init_array_entry
    challenge-three.c
    __FRAME_END__
    __init_array_end
    _DYNAMIC
    __init_array_start
    __GNU_EH_FRAME_HDR
    _GLOBAL_OFFSET_TABLE_
    __libc_csu_fini
    _ITM_deregisterTMCloneTable
    puts@@GLIBC_2.2.5
    _edata
    string
    __libc_start_main@@GLIBC_2.2.5
    __data_start
    __gmon_start__
    __dso_handle
    _IO_stdin_used
    __libc_csu_init
    __bss_start
    main
    __TMC_END__
    _ITM_registerTMCloneTable
    __cxa_finalize@@GLIBC_2.2.5
    .symtab
    .strtab
    .shstrtab
    .interp
    .note.gnu.property
    .note.gnu.build-id
    .note.ABI-tag
    .gnu.hash
    .dynsym
    .dynstr
    .gnu.version
    .gnu.version_r
    .rela.dyn
    .rela.plt
    .init
    .plt.got
    .plt.sec
    .text
    .fini
    .rodata
    .eh_frame_hdr
    .eh_frame
    .init_array
    .fini_array
    .dynamic
    .data
    .bss
    .comment
    ```
- **Answer:**
    ```
    THROWINGCOCONUTSISTHEBEST
    ```

## Challenge 4: Listen to server running on port 1337
- **Script:**
    ```python
    import socket
    from time import sleep

    packet = "ping"
    HOST, PORT = '127.0.0.1', 1337
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(10)
    sock.connect((HOST, PORT))

    while True:
        try:
            sock.send(packet.encode())
            sleep(1)
            reply = sock.recv(1024).decode()
            if not reply:
                break
            print("recvd: ", reply)
        except KeyboardInterrupt:
            print("bye")
            break

    sock.close()
    ```
- **Output:**
    ```
    recvd:  192c01
    ```
- **Answer:**
    ```
    192c01
    ```

## Challenge 5: Kill a process that changes name every second and get secret value from a file in `/tmp` after killing it
- **Script:**
    ```python
    >>> import psutil
    >>> psutil.pids()
    ```
- **Output:**
    ```
    [1, 46, 103, 111, 115, 116, 123, 127, 128, 133, 151, 158, 162]
    ```
- **Script:**
    ```python
    >>> for pid in psutil.pids():
    ...     p = psutil.Process(pid)
    ...     print(f'{pid}: {p.name()}')
    ... 
    ```
- **Output:**
    ```
    1: tini
    46: sshd
    103: tail
    111: sshd
    115: sshd
    116: bash
    123: sshd
    127: sshd
    128: bash
    133: python3
    151: python3
    158: FBJXwcRuSz
    162: python3
    ```
- **Answer:**
  ```
  158: FBJXwcRuSz
  ```
- **Script:**
    ```python
    >>> for pid in psutil.pids():
    ...     if pid == 158:
    ...         p = psutil.Process(pid)
    ...         print(f'killing {pid}: {p.name()}')
    ...         p.terminate()
    ...         p.wait()
    ...
    ```
- **Output:**
    ```
    killing 158: zHrQrACien
    ```
- **Script:**
    ```python
    >>> import os
    >>> for root, dirs, files in os.walk('/tmp'):
    ...     for file in files:
    ...         print(os.path.join(root, file))
    ... 
    ```
- **Output:**
    ```
    /tmp/challenge-five.txt
    /tmp/challenge-1/folder_3/folder_1/folder_4/ba9c1a
    ```
- **Command:**
    ```bash
    nano challenge-five.txt
    ```
- **Output:**
    ```
    99ab18
    ```

## Solution

```
[ShyBot]: I can't believe you actually did it! I'm so proud of you.
[ShyBot]: As a sign of respect, I'll stop throwing coconuts. For now.
[ShyBot]: I'm sure we'll meet again soon. Until then, goodbye!
[ShyBot]: Oh, I almost forgot. Here's your token: 16ec14

[ShyBot]: And a little something you might need if you ever want to get out of this place: br0k3nbrak3s
Press enter to continue...
```