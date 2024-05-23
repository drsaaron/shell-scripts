#! /bin/sh

while getopts :fn:v:u:U:g:G: OPTION
do
    case $OPTION in
	f)
	    forceBuild=1
	    ;;
	n)
	    imageName=$OPTARG
	    ;;
	v)
	    version=$OPTARG
	    ;;
	u)
	    luid=$OPTARG
	    ;;
	U)
	    luname=$OPTARG
	    ;;
	g)
	    lgid=$OPTARG
	    ;;
	G)
	    lgname=$OPTARG
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

if [ -z "$version" ]
then
    if [ -f pom.xml ]
    then
	pomVersion=$(getPomAttribute.sh version)
	version=${pomVersion%-[A-Z]*}
    elif [ -f package.json ]
    then
	version=$(getPackageJsonAttribute.sh version)
    else
	echo "unable to determine version" 1>&2
	exit 1
    fi
fi

[ -z "$imageName" ] && imageName=$(dockerImageName.sh)

echo "building $imageName:$version"

# does the image already exist?
if docker images $imageName | grep -Fq $version
then
    if [ -z "$forceBuild" ]
    then
	echo "$imageName:$version already exists, use -f to force a rebuild" 1>&2
	exit 1
    else
	echo "$imageName:$version already exists, but -f specified so overwriting"
    fi
fi

# setup the local user, if defined
USER_ARGS=
[ -n "$luid" ] && USER_ARGS="$USER_ARGS --build-arg LOCAL_USER=$luid"
[ -n "$luname" ] && USER_ARGS="$USER_ARGS --build-arg LOCAL_USER_ID=$luname"
[ -n "$lgid" ] && USER_ARGS="$USER_ARGS --build-arg LOCAL_GROUP=$lgid"
[ -n "$lgname" ]  && USER_ARGS="$USER_ARGS --build-arg LOCAL_GROUP_ID=$lgname"

docker buildx build --network host $USER_ARGS -t $imageName .
docker tag $imageName $imageName:$version
