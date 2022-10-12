#! /bin/sh 

# a simple shell script to convert a semi-colon delimited list, e.g. $PATH, into a list
# of unique elements from that list.  

echo "$1" | sed -ne 's/:/\n/gp' | sort | uniq | tr '\n' ':'

