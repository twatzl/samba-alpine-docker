#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 USERNAME" >&2
  exit 1
fi

USERNAME=$1

# calling the same code as when creating a user allows to change its password
smbpasswd -a -c /etc/samba/smb.conf $USERNAME
