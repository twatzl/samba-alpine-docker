#!/bin/sh

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 UID GID USERNAME" >&2
  exit 1
fi

varUID=$1
varGID=$2
USERNAME=$3

# create user in container
addgroup -g $varGID $USERNAME
adduser -u $varUID -D -H -G $USERNAME -s /bin/false $USERNAME

# create a samba user matching our user from above
smbpasswd -a $USERNAME
