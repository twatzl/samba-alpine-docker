# samba-alpine
A simple and super lightweight Samba docker container, based on the latest Alpine Linux base image 🐧🐋💻.

By default, the share will be accessible read-only for everyone.
See smb.conf for details, or feel free to use your own config (see below).

Runs Samba's smbd and nmbd within the same container, using supervisord. Due to the fact that nmbd wants to broadcast
and become the "local master" on your subnet, you need to supply the "--network host" flag to make the server visible to the hosts subnet (likely your LAN).

Mapping the ports alone is likely not sufficient for proper discovery as the processes inside the container are only aware of the internal Docker network, and not the host network. Maybe there's a config switch somewhere to supply a target broadcast network?

## Quick Start

### Run

First copy the content of the **config** directory into the config directory you will use.

Quick start for the impatient (discovery on your network will work fine). With your own smb.conf and supervisord.conf configs:
```shell
docker create --network host -v /path/to/configs/:/config -v /path/to/share/:/shared --name samba twatzl/samba-alpine
docker start samba
```

Supplying port mappings only instead of --network=host might be subject to the limtations outlined above
```shell
docker run -d -p 137:137/udp -p 138:138/udp -p 139:139 -p 445:445 -v /path/to/configs/:/config -v /path/to/share/:/shared --name samba twatzl/samba-alpine
docker start samba
```

To have the container start when the host boots, add docker's restart policy:
```shell
docker create --restart=always -p 137:137/udp -p 138:138/udp -p 139:139 -p 445:445 -v /path/to/share/:/shared --name samba twatzl/samba-alpine
docker start samba
```

### Update Container

You have to manually update the container by dumping it and building it again. 
Note that you then have to add the users again using the scripts provided.

## Add new User

For adding a new user which has no user mapped on the host, you can use the `scripts/addUser.sh` script.

```
sh addUser.sh <CONTAINER> <USERNAME>
``` 

In order to add a user which also exists on the host use the `scripts/addIdUser.sh` script. This is basically the way to go.

First you create the host user (-M means no home directory)

```shell
adduser -M someuser
```

Then get the ids with the following commands:

```shell
id -u someuser
id -g someuser
```
and finally create the user in the container

```shell
sh addIdUser.sh <UID> <GID> <CONTAINER> <USERNAME> 
```
(Note: the order of the parameters is changed, so you do not accidentally call the wrong script)

## Change User PW

The password of a user can be changed using the script `scripts/changePW.sh`.

## Remove User

Not yet implemented

## Multiple Shares and Adding Shares

Multiple shares can be used as shown in the following command.

```shell
docker create --network host -v /path/to/configs/:/config -v /path/to/share/A/:/shares/shareA -v /path/to/share/B/:/shares/shareB --name samba twatzl/samba-alpine
docker start samba
```

In order to add shares, just dump the container with `docker container rm samba` and create it new with all the shares you need.
Note: After dumping the container the users have to be created again in the container.

## SELinux

SELinux might cause trouble with the permissions for volumes.
In order to fix this use the following parameters for volumes.

```shell
-v /path/to/my/share:/shared:Z
```

See also: https://stackoverflow.com/questions/24288616/permission-denied-on-accessing-host-directory-in-docker

## This docker container is not good because whatever

I know. It is not great. It's by no means a perfect solution, but it does the job. If you have a better solution for any of the topics or want to add additional functionality or report errors I would be very happy to discuss them. I could not find anything better on the net.
