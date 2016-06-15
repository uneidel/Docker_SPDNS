#!/bin/sh
ipfile=/tmp/external_ip.tmp
if [ -f $ipfile ]
then
external_ip=$(cat $ipfile)
else
external_ip=0
fi
 
#Use different Web services to check IP as one service could fail.
#If wget result is the IP in one line (with line-break) it's possible to call more URL's in one line
get_ip="$(wget -t 2 -T 5 -q -O- http://checkip.dyndns.org | grep IP | awk '{print $4}')
$(wget -t 2 -T 5 -q -O- "http://ipecho.net/plain")
$(wget -t 2 -T 5 -q -O- "http://icanhazip.com" "http://cfaj.freeshell.org/ipaddr.cgi")"
 
 
#See if we have duplicate results. Print out the IP with most duplicate results.
resulting_ip=$(echo "$get_ip" | uniq -c -d | sort | tail -1 | awk '{print $2}')
d=$(date +%y-%m-%d-%H:%M)
echo  "$d:$resulting_ip"
#Test if external IP is different from last one. If changed, then register new IP and send mail
if [ "$external_ip" != "$resulting_ip" ]
then
    echo $resulting_ip > $ipfile
    URL="https://$SPDNS_USERNAME:$SPDNS_PASSWORD@update.spdyn.de/nic/update?hostname=$SPDNS_HOSTNAME&myip=$resulting_ip"
    echo $URL
    w3m -o ssl_verify_server=false -dump $URL > /dev/null
fi
