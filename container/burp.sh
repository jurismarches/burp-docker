#!/bin/bash

function Burp {
	if [ "$1" == "start" ]; then
		/usr/bin/bash -c '2>&1 1>>/var/log/burp.log burp -F -v -c /etc/burp/burp-server.conf &'
	elif [ "$1" == "stop" ]; then
		kill $(cat /run/burp-server.pid)
	else
		echo "unknown command $1"
	fi
}

case "$1" in

	burp)
	Burp $2
	exit 0;
	;;
	*)
	exit 0
	;;
esac
