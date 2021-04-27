#! /bin/sh

docker rmi -f $(docker images -qf "dangling=true")
