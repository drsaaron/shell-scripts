#! /bin/sh

while getopts :e:d: OPTION
do
    case $OPTION in
	e)
	    extension=$OPTARG
	    ;;
	d)
	    days=$OPTARG
	    ;;
	*)
	    echo "usage: $0 -e <extension> -d <days>" 1>&2
	    exit 1
    esac
done

if [ -z "$extension" -o -z "$days" ]
then
    echo "missing arguments" 1>&2
    exit 1
fi

find . -name '*.'$extension -mtime +$days -print -exec rm {} \;
