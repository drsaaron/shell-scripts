#! /bin/sh 

while getopts :ai: OPTION
do
    case $OPTION in
	i)
	    imageName=$OPTARG
	    ;;
	a)
	    doAll=1
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

if [ -n "$doAll" ]
then
    docker images | sed 1d | awk '{ print $1 }' | sort | uniq | xargs -n1 $0 -i
    exit $?
fi

[ -z "$imageName" ] && imageName=$(dockerImageName.sh)
echo "cleaning up $imageName"

# keep the current and 4 previous versions.  This would be 7 lines in the
# docker images command: header, 5 versions, and the latest version.
docker images $imageName | sed '1,7d' | awk '{ print $2 }' |
    xargs -I % -n 1 sh -c "echo \"purging version %\"; docker rmi $imageName:%"


    
