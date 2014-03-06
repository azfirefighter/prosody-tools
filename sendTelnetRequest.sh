#!/bin/bash
(
expect << EOF
set timeout 20
spawn telnet localhost 5582
send "$1\r"
expect "$2"
send "$'\cc'"
EOF
) | egrep -o "$3"
