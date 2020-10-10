#! /bin/ksh

docker rmi -f $(docker images -qf "dangling=true")
