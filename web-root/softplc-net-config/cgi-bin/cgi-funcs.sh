
# See: http://www.team2053.org/docs/bashcgi/postdata.html

# This code for getting code from post data is from http://oinkzwurgl.org/bash_cgi and
# was written by Phillippe Kehi &lt;phkehi@gmx.net&gt; and flipflip industries
# then fixed by Dick Hollenbeck to run on busybox ash.


# (internal) routine to store POST data into QUERY_STRING_POST var
cgi_get_POST_vars()
{
    # check content type
    # FIXME: not sure if we could handle uploads with this..
    # [ "${CONTENT_TYPE}" != "application/x-www-form-urlencoded" ] && \
    # echo "Warning: you should probably use MIME type "\
    #     "application/x-www-form-urlencoded instead of \"${CONTENT_TYPE}\" !" 1>&2

    # save POST variables (only first time this is called)
    [ -z "$QUERY_STRING_POST" \
	    -a "$REQUEST_METHOD" = "POST" -a ! -z "$CONTENT_LENGTH" ] && \
	read -n $CONTENT_LENGTH QUERY_STRING_POST
    return
}

# (internal) routine to decode urlencoded strings
cgi_decodevar()
{
    [ $# -ne 1 ] && return
    local v=""
    local h=""

    # replace all + with whitespace and append %%
    local t="${1//+/ }%%"

    #echo "cgi_decodevar t=${t}"  1>&2

    while [ ${#t} -gt 0 -a "${t}" != "%" ]; do
	v="${v}${t%%\%*}" # digest up to the first %
	t="${t#*%}"       # remove digested part

	# echo "    while cgi_decodevar v=$v t=$t" 1>&2

	# decode if there is anything to decode and if not at end of string
	if [ ${#t} -gt 0 -a "${t}" != "%" ]; then
	    h=${t:0:2} # save first two chars
	    t="${t:2}" # remove these
	    v="${v}"`echo -e \\\\x${h}` # convert hex to special char
	fi
    done

    # return decoded string
    #echo "cgi_decodevar v=$v" 1>&2
    echo "${v}"
    return
}

# routine to get variables from http requests
# usage: cgi_getvars method varname1 [.. varnameN]
# method is either GET or POST or BOTH
# the magic variable name ALL gets everything
cgi_getvars()
{
    [ $# -lt 2 ] && return
    local q=""
    local p=""
    local k=""
    local v=""
    local s=""

    # get query
    case $1 in
    GET)
	[ ! -z "${QUERY_STRING}" ] && q="${QUERY_STRING}&"
	;;
    POST)
	cgi_get_POST_vars
	[ ! -z "${QUERY_STRING_POST}" ] && q="${QUERY_STRING_POST}&"
	;;
    BOTH)
	[ ! -z "${QUERY_STRING}" ] && q="${QUERY_STRING}&"
	cgi_get_POST_vars
	[ ! -z "${QUERY_STRING_POST}" ] && q="${q}${QUERY_STRING_POST}&"
	;;
    esac

    #echo "QUERY_STRING=${QUERY_STRING}" 1>&2
    #echo "QUERY_STRING_POST=${QUERY_STRING_POST}" 1>&2

    shift
    s=" $* "

    # parse the query data
    while [ ! -z "$q" ]; do
	p="${q%%&*}"  # get first part of query string
	k="${p%%=*}"  # get the key (variable name) from it
	v="${p#*=}"   # get the value from it
	q="${q#$p&*}" # strip first part from query string

	# decode and evaluate var if requested
	if [ "$1" = "ALL" -o "${s/ $k /}" != "$s" ]; then
	    eval "$k=\"`cgi_decodevar \"$v\"`\""
	    #echo "$k=\"`cgi_decodevar \"$v\"`\""  1>&2
	fi

    done
    return
}

# Calculate number of bits in a netmask
#
mask2cidr() {
	local nbits=0
	IFS=.
	for dec in $1 ; do
		case $dec in
		255) let nbits+=8;;
		254) let nbits+=7;;
		252) let nbits+=6;;
		248) let nbits+=5;;
		240) let nbits+=4;;
		224) let nbits+=3;;
		192) let nbits+=2;;
		128) let nbits+=1;;
		0);;
		*) echo "Error: $dec is not recognised"; exit 1
		esac
	done
	echo "$nbits"
}

