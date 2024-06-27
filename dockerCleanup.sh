#! /bin/sh

tmpFile=/tmp/docker-dangling

while getopts :p OPTION
do
    case $OPTION in
	p)
	    doPrune=1
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

rm -f $tmpFile
docker images -qf "dangling=true" > $tmpFile

if [ -s $tmpFile ]
then
    docker rmi -f $(cat $tmpFile)
else
    echo "no images to purge." 1>&2
fi

if [ -n "$doPrune" ]
then
    echo "pruning as requested"
    docker system prune -f
fi
