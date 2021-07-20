#! /bin/sh

digest() {
    image=$1
    docker image inspect $image --format '{{json .RepoDigests}}'
}

while getopts :i: OPTION
do
    case $OPTION in
	i)
	    imageName=$OPTARG
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

if [ -z "$imageName" ]
then
    if [ -f Dockerfile ]
    then
	imageName=$(grep -i '^from' Dockerfile | awk '{ print $2 }')
    else
	echo "no image specified and Dockerfile not found." 1>&2
	exit 1
    fi
fi

echo "pulling latest $imageName"

currentDigest=$(digest $imageName)

docker pull $imageName

newDigest=$(digest $imageName)

if [ "$currentDigest" = "$newDigest" ]
then
    echo "image is already latest"
    exit 1
else
    echo "image updated"
    exit 0
fi
