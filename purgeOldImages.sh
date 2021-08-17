#! /bin/sh

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

[ -z "$imageName" ] && imageName=drsaaron/$(dockerImageName.sh)
echo "cleaning up $imageName"

# keep the current and 4 previous versions.  This would be 7 lines in the
# docker images command: header, 5 versions, and the latest version.
docker images $imageName | sed '1,7d' | awk '{ print $2 }' |
    xargs -I % -n 1 sh -c "echo \"purging version %\"; docker rmi $imageName:%"


    
