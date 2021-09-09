#! /bin/sh

# get this host's IP address
ifconfig wlo1 | grep inet | awk '$1=="inet" {print $2}'
