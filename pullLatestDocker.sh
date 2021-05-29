#! /bin/sh

if [ ! -f Dockerfile ]
then
    echo "Dockerfile not found." 1>&2
    exit 1
fi

image=$(grep -i '^from' Dockerfile | awk '{ print $2 }')
echo "pulling latest $image"
docker pull $image
