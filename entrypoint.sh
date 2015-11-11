#!/bin/sh

if [ -f /etc/samba/smb.conf ]; then
	if [ -z "$SMB_HOST" ]; then
		SMB_HOST="$(hostname -s)"
	fi
	sed -i "s/SERVER/${SMB_HOST}/g" /etc/samba/smb.conf
fi

exec "$@"
