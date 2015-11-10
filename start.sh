#!/bin/sh

PIDFILE="/var/run/samba/smbd.pid"

# Start up smbd in the background
/usr/sbin/smbd &

echo "Waiting for Samba to start..."
# Wait for Samba to start
while [ ! -f /var/run/samba/smbd.pid ]; do
	sleep 1
done

PID="$(cat /var/run/samba/smbd.pid)"
echo "Samba started with pid ${PID}"

# Print the main log to stdout
tail -F /var/log/samba/log.smbd &
TAIL_PID="$!"

# Wait for the smbd daemon to exit
waitForDaemon() {
	while kill -0 "${PID}" 2> /dev/null; do
		sleep 0.5
	done
}

# Handle SIGTERM
_term() {
	echo "Received SIGTERM"
	kill -TERM "${PID}"
	waitForDaemon
}

# Kill our only child and wait for it to exit
killChildren() {
	kill "${TAIL_PID}"
	wait "${TAIL_PID}"
}

# If we receive SIGTERM, forward that to the main Samba process and wait again.
trap _term TERM
trap killChildren EXIT

# Wait for smbd to exit
waitForDaemon
