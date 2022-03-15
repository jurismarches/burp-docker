#!/bin/bash

/usr/bin/pgrep burp >/dev/null

if [[ "$?" == "0" ]]; then
    burp_retval="0"
else
    burp_retval="1"
fi


if [[ "$burp_retval" == "1" ]]; then
	exit 1
fi
