#! /bin/sh

# get the value of an attribute from the pom.  We will only look at the first
# instance of that attribute in the file.

while getopts :p: OPTION
do
    case $OPTION in
	p)
	    pomFile=$OPTARG
	    ;;
	*)
	    echo "invalid option $OPTARG" 1>&2
	    exit 1
	    ;;
    esac
done

shift $((OPTIND - 1))

tag=$1

if [ -z "$tag" ]
then
    echo "usage: $0 [-p pomFile] <tag>" 1>&2
    exit 1
fi

value=$(grep "^ *<$tag>" ${pomFile:-pom.xml} | head -1 | sed -E -e "s%</?$tag>%%g" -e 's/ //g')
echo $value
