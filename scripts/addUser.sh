#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 CONTAINER USERNAME" >&2
  exit 1
fi

CONTAINER=$1
USERNAME=$2

# create user in container
docker exec $CONTAINER addgroup $USERNAME
docker exec $CONTAINER adduser -D -H -G $USERNAME -s /bin/false $USERNAME

# create a samba user matching our user from above
docker exec -it $CONTAINER smbpasswd -a -c /config/smb.conf $USERNAME
