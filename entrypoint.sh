#!/bin/sh

if [ -f /etc/samba/smb.conf ]; then
	if [ -z "$HOSTNAME" ]; then
		HOSTNAME="$(hostname -s)"
	fi
	sed -i "s/SERVER/${HOSTNAME}/g" /etc/samba/smb.conf
fi

exec "$@"
