#!/bin/sh

SAMBA_CONF_DIR="/config/etc/samba"
SUPERV_CONF_DIR="/config/supervisord"

echo "Creating default config for samba"
echo "=================================\n"

echo "creating directory $SAMBA_CONF_DIR"
mkdir -p $SAMBA_CONF_DIR
echo "creating directory $SUPERV_CONF_DIR"
mkdir -p $SUPERV_CONF_DIR

echo "copying default config files"
cp /default_config/supervisord.conf /config/supervisord/
cp /default_config/smb.conf /config/etc/samba/

echo "default config created"

