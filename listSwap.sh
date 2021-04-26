#! /bin/sh

for file in /proc/*/status
do
    awk '/VmSwap|Name/ { printf $2 " " $3 } END { print "" }' $file
done | sort -k2 -n -r
