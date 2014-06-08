#!/bin/sh
 
if [ -z $1 ] || [ -z "$2" ]; then
    echo "Use: $0 \"event\" prio \"message\""
    exit 1
fi
 
SEDSCRIPT=/tmp/root/urlencode.sed
 
EVENT=`echo $1 | sed -f $SEDSCRIPT`
MESSAGE=`echo $3 | sed -f $SEDSCRIPT`
APP=`echo "DD-WRT" | sed -f $SEDSCRIPT`
 
RECIPIENT=0123456789abcdef0123456789abcdef01234567
 
# Priority can be -2 .. 2 (-2 = lowest, 2 = highest)
PRIORITY=$2
 
HOST="my.server.com"
PORT="80"
URI="/path/to/prowlProxy.php?add"
 
POST_DATA="apikey=$RECIPIENT&priority=$PRIORITY&application=$APP&event=$EVENT&description=$MESSAGE"
 
POST_LEN=`echo "$POST_DATA" | wc -c`
 
HTTP_QUERY="POST $URI HTTP/1.1
Host: $HOST
Content-Length: $POST_LEN
Content-Type: application/x-www-form-urlencoded
 
$POST_DATA"
 
# echo "$HTTP_QUERY"
 
echo "$HTTP_QUERY" | nc -w 10 $HOST $PORT > /dev/null
 
if [ $? -eq "0" ]; then
    exit 0
else
    exit 2
fi
