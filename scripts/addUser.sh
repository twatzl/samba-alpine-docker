#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 USERNAME" >&2
  exit 1
fi

USERNAME=$1

# create user in container
addgroup $USERNAME
adduser -D -H -G $USERNAME -s /bin/false $USERNAME

# create a samba user matching our user from above
smbpasswd -a $USERNAME
