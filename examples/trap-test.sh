#!/bin/sh

count=0

trap 'echo "goodbye (now count=$count)"; exit 1' INT TERM HUP QUIT
trap "echo 'exited (initial count=$count)'" EXIT

while [ $count -lt 7 ]
do
    count=$((count+1))
    echo "count=$count"
    sleep 1
done
