#! /bin/sh

# copy a docker images from localhost to $LAPTOP_IP to bypass using
# the docker hub.
while getopts :i: OPTION
do
    case $OPTION in
	i)
	    imageName=$OPTARG
	    ;;
	*)
	    echo "invalid option $OPTARG" 1>&2
	    exit 1
    esac
done

if [ -z "$imageName" ]
then
    if [ -f pom.xml ]
    then
	version=$(getPomAttribute.sh version | sed -e 's/-[A-Z]*$//')
    elif [ -f package.json ]
    then
	version=$(getPackageJsonAttribute.sh version)
    else
	echo "unable to determine version" 1>&2
	exit 1
    fi

    imageName=$(dockerImageName.sh):$version
fi

echo "copying $imageName to $LAPTOP_IP"
docker save $imageName | gzip | ssh $(whoami)@$LAPTOP_IP "gunzip | docker load"
