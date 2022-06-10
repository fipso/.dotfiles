#!/bin/bash
if pgrep -x "redshift" > /dev/null; then
	echo "Redshift is already running"
else
	echo "Start redshift..."
	redshift -l 52.5132364:13.3776222
fi
