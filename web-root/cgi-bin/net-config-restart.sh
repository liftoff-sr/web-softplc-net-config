#!/bin/sh
# must be bash not dash

WEBROOT=/web-root
LOGFILE=/tmp/restart.log

source $WEBROOT/cgi-bin/cgi-funcs.sh

cgi_getvars GET my_ip

#env > /tmp/debug.log


# Redirect user to [new] "$my_ip" index.html after a 3 second delay
echo "\
Content-type: text/html; charset=UTF-8
Connection: close

<html><head>
<meta http-equiv=\"refresh\" content=\"3; url=http://$my_ip/\" />
</head><body></body></html>
"


sync

# Now that HTTP reply has been issued on a prior IP ADDR, we can change the
# gateway's ip address and restart the runtime using new NETWORKS.LST file.
(trap '' HUP INT
	systemctl stop softplc
	systemctl stop networking
	systemctl start networking
	systemctl start softplc
	systemctl restart http-busybox
) </dev/null 1>$LOGFILE 2>&1 &
