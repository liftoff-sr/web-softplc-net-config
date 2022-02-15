#!/bin/bash

WEBROOT=/web-root/softplc-net-config


# assume PWD uses cgi-bin from this:
#echo "pwd: "`pwd`

CFG="$WEBROOT/config"

# establish some initial values, the http POST will overwrite them later.
# but if this is executed as a repeat get, then there will be no query data
# and we need it to formulate the <table> at the bottom.
my_ip="192.168.1.100"
subnet_mask="255.255.255.0"
gateway_ip="192.168.1.1"


source $WEBROOT/cgi-bin/cgi-funcs.sh

# register all GET and POST variables
cgi_getvars BOTH ALL

# Use the baseline template in $CFG and replace fields to generate the
# final in use configuration file.

sed -E \
    -e "s@[ \t]+address[ \t]+ADDRESS@\taddress $my_ip@" \
    -e "s@[ \t]+netmask[ \t]+NETMASK@\tnetmask $subnet_mask@" \
    -e "s@[ \t]+gateway[ \t]+GATEWAY@\tgateway $gateway_ip@" \
    $CFG/NETWORKS.LST > /etc/NETWORKS.LST


echo "echo \"" > /tmp/temp.out
# escape the double quotes
sed -r -e 's@[\"]@\\"@g' ../saved.html >> /tmp/temp.out

echo "\"" >> /tmp/temp.out

# do variable substitution
output=$(source /tmp/temp.out)

# hose it to the webserver for return to the client
echo "$output"
