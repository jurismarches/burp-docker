#!/bin/bash

NOTIFY_EMAIL=${NOTIFY_EMAIL:-youremail@example.com}
SMTP_PORT=${SMTP_PORT:-25}

if [[ -z $(ls -A /etc/burp) ]]; then
	cd /etc/burp-source && make install-configs
	cp /etc/burp/burp-server.conf /etc/burp/burp-server.conf.template
fi

# start with clean config files
cp -f /etc/burp/burp-server.conf.template /etc/burp/burp-server.conf

# enable listen_status port in burp server
sed -i 's/^#listen_status = 127.0.0.1:4972/listen_status = 0.0.0.0:4972/' /etc/burp/burp-server.conf
sed -i 's/^#max_status_children = 5/max_status_children = 15/' /etc/burp/burp-server.conf

# set timer to 23h instead of 20h
sed -i 's/^timer_arg = 20h/timer_arg = 23h/' /etc/burp/burp-server.conf

# performance enhancement
echo "monitor_browse_cache = 1" >> /etc/burp/burp-server.conf

if [[ $NOTIFY_FAILURE == "true" ]]; then
	sed -i '/^#notify_failure/s/^#//g' /etc/burp/burp-server.conf
	sed -i "s/youremail@example.com/${NOTIFY_EMAIL}/g" /etc/burp/burp-server.conf
fi

if [[ $NOTIFY_SUCCESS == "true" ]]; then
	sed -i '/^#notify_success/s/^#//g' /etc/burp/burp-server.conf
	sed -i 's/^notify_success_warnings_only = 1/notify_success_warnings_only = 0/' /etc/burp/burp-server.conf
	sed -i 's/^notify_success_changes_only = 1/notify_success_changes_only = 0/' /etc/burp/burp-server.conf
	sed -i "s/youremail@example.com/${NOTIFY_EMAIL}/g" /etc/burp/burp-server.conf
fi

function StopProcesses {

	while [ $(/usr/bin/monit status | sed -n '/^Process/{n;p;}' | awk '{print $2}' | grep -c OK) != 0 ] ; do
		sleep 2
		/usr/bin/monit stop all
	done

	exit 0
}

# run StopProcesses function if docker stop is initiated
trap StopProcesses EXIT TERM

# start monit and all monitored processes
/usr/bin/monit && /usr/bin/monit start all

# just infinite loop
while true
do
	sleep 1d
done &

wait $!
