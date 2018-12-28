#!/bin/sh

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 UID GID CONTAINER USERNAME" >&2
  exit 1
fi

varUID=$1
varGID=$2
CONTAINER=$3
USERNAME=$4

# create user in container
docker exec $CONTAINER addgroup -g $varGID $USERNAME
docker exec $CONTAINER adduser -u $varUID -D -H -G $USERNAME -s /bin/false $USERNAME

# create a samba user matching our user from above
docker exec -it $CONTAINER smbpasswd -a -c /config/smb.conf $USERNAME
