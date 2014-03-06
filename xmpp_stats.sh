#!/bin/bash

## Left column
connected=$(prosodyctl mod_listusers --connected | cut -d '/' -f1 | uniq | wc -l);
registered=$(prosodyctl mod_listusers | grep -c @kdex.de);
connected_p=$(echo "($connected/$registered)*100" | bc -l | xargs printf "%1.0f");
locations=$(for line in $(prosodyctl mod_listusers --connected); do echo $line | grep "@" | cut -d @ -f 1; done | sort | uniq --count  | egrep -o "[1-9]+" | awk '{sum = sum + $1} END {print sum}');

## Middle column
available=$(for line in $(prosodyctl mod_listusers --connected); do echo $line | egrep \([0-9]+\); done | grep -c "available");
away=$(for line in $(prosodyctl mod_listusers --connected); do echo $line | egrep \([0-9]+\); done | grep -c "away");
xa=$(for line in $(prosodyctl mod_listusers --connected); do echo $line | egrep \([0-9]+\); done | grep -c "xa");
dnd=$(for line in $(prosodyctl mod_listusers --connected); do echo $line | egrep \([0-9]+\); done | grep -c "dnd");
chat=$(for line in $(prosodyctl mod_listusers --connected); do echo $line | egrep \([0-9]+\); done | grep -c "chat");

## Right column
uptime=$(echo $(sh ./sendTelnetRequest.sh "server:uptime()" "minutes" "[0-9]+ .*") | egrep -o "[A-Za-z]{3} [0-9]+ [0-9:]+ [0-9]{4}");
version=$(echo v$(sh ./sendTelnetRequest.sh "server:version()" "OK" "[0-9]\.[0-9]\.[0-9]"));

## Just for checking
#echo "Connected:	$connected";
#echo "Connected (%):	$connected_p";
#echo "Registered:	$registered";
#echo "Locations:	$locations";
#echo "Available:	$available";
#echo "Away:		$away";
#echo "Xa:		$xa";
#echo "Dnd:		$dnd";
#echo "Chat:		$chat";
#echo "Uptime:		$uptime";
#echo "Version:	$version";

## MySQL options
usr="yourUser";
pwd="yourPassword";
db="prosody";
table="xmpp_stats";
host="10.10.10.15";

query="USE $db; UPDATE $table SET connected = $connected, connected_p = \"$connected_p\", registered = $registered, locations = $locations, available = $available, away = $away, xaway = $xa, dnd = $dnd, chat = $chat, version = \"$version\", uptime = \"$uptime\"";

## SQL query
mysql -u $usr -p$pwd -h $host -e "$query";
