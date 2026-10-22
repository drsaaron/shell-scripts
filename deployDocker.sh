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
    version=$(dockerImageVersion.sh)
    imageName=$(dockerImageName.sh):$version
fi

# sanity check that the image doesn't already exit
if ssh $(whoami)@$LAPTOP_IP podman images --format "'{{json .Tag}}'" $imageName | grep -q $(echo $imageName | awk -F: '{ print $2 }')
then
    echo "image $imageName already on $LAPTOP_IP"
    exit 1
fi

# go ahead and copy
echo "copying $imageName to $LAPTOP_IP"
podman save $imageName | gzip | ssh $(whoami)@$LAPTOP_IP "gunzip | podman load"


