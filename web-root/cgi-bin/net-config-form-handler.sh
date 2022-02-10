#!/bin/bash

WEBROOT=/web-root


# assume PWD uses cgi-bin from this:
#echo "pwd: "`pwd`

CFG="$WEBROOT/softplc-net-config/config"

# establish some initial values, the http POST will overwrite them later.
# but if this is executed as a repeat get, then there will be no query data
# and we need it to formulate the <table> at the bottom.
my_ip="192.168.1.100"
subnet_mask="255.255.255.0"
gateway_ip="192.168.1.1"


source $WEBROOT/cgi-bin/cgi-funcs.sh

# register all GET and POST variables
cgi_getvars BOTH ALL

# save the SIEMENS.LST file
echo "
my_ip=\"$my_ip\"
subnet_mask=\"$subnet_mask\"
gateway_ip=\"$gateway_ip\"
" > $CFG/LAST-NETWORKS.LST


# Use the baseline templates in $CFG and replace fields to generate the
# final in use configuration files, writing each in its different destination.

cidr=$my_ip/$(mask2cidr $subnet_mask)
sed -E \
    -e "s@[ \t]+address[ \t]+MY_CIDR@\taddress $cidr@" \
    -e "s@[ \t]+gateway[ \t]+GATEWAY_CIDR@\tgateway $gateway_ip@" \
    $CFG/NETWORKS.LST > /etc/NETWORKS.LST


echo "echo \"" > /tmp/temp.out
# escape the double quotes
sed -r -e 's@[\"]@\\"@g' ../softplc-net-config/saved.html >> /tmp/temp.out

echo "\"" >> /tmp/temp.out

# do variable substitution
output=$(source /tmp/temp.out)

# hose it to the webserver for return to the client
echo "$output"
