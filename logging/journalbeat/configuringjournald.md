Following https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs

# Configuring timezone

Check local time

```bash
$ timedatectl status 
```

If you need to

```bash
$ sudo timedatectl set-timezone Europe/London
$ sudo timedatectl status
```

# Using Journalctl

```bash
$ sudo journalctl -u docker.service
$ sudo journalctl CONTAINER_NAME=ucp-kubelet
```

# Configuring persistence

By defualt on ubuntu 1604 journald is not persitent. You can see this with

```bash
$ journalctl --list-boots
 0 f448c3f3702e4ad8b37120a114913d0a Sun 2019-06-02 16:34:02 BST—Sun 2019-06-02 17:04:20 BST
```

At the same time `/var/log/journal` is either empty of does not exist.

There are sane defaults:
- SystemMaxUse is 10% for peristant storage in /var/log/journal, or 15% for memory use in /run/log/journal
- SystemMaxFiles=100
- SystemMaxFileSize = SystemMaxUse/8

My configfile looks like:

```
$ sudo cat /etc/systemd/journald.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#
# Entries in this file show the compile time defaults.
# You can change settings by editing this file.
# Defaults can be restored by simply deleting this file.
#
# See journald.conf(5) for details.

[Journal]
Storage=auto
#Compress=yes
#Seal=yes
#SplitMode=uid
#SyncIntervalSec=5m
#RateLimitInterval=30s
#RateLimitBurst=1000
SystemMaxUse=
SystemKeepFree=
SystemMaxFileSize=
SystemMaxFiles=100
RuntimeMaxUse=
RuntimeKeepFree=
RuntimeMaxFileSize=
RuntimeMaxFiles=100
#MaxRetentionSec=
#MaxFileSec=1month
#ForwardToSyslog=yes
#ForwardToKMsg=no
#ForwardToConsole=no
#ForwardToWall=yes
#TTYPath=/dev/console
#MaxLevelStore=debug
#MaxLevelSyslog=debug
#MaxLevelKMsg=notice
#MaxLevelConsole=info
#MaxLevelWall=emerg
```

Restart journald with

```
$ sudo systemctl restart systemd-journald
```

And journald's logs can be found with:

```
$ sudo journalctl -u systemd-journald
```




