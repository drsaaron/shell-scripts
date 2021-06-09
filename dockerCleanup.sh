#! /bin/sh

tmpFile=/tmp/docker-dangling

rm -f $tmpFile
docker images -qf "dangling=true" > $tmpFile

if [ -s $tmpFile ]
then
    docker rmi -f $(cat $tmpFile)
else
    echo "no images to purge." 1>&2
fi

