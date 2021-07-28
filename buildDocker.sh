#! /bin/sh

while getopts :f OPTION
do
    case $OPTION in
	f)
	    forceBuild=1
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

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

imageName=drsaaron/$(dockerImageName.sh)

# does the image already exist?
if docker images $imageName | grep -q $version
then
    if [ -z "$forceBuild" ]
    then
	echo "$imageName:$version already exists, use -f to force a rebuild" 1>&2
	exit 1
    else
	echo "$imageName:$version already exists, but -f specified so overwriting"
    fi
fi

echo "building $imageName:$version"
docker build -t $imageName .
docker tag $imageName $imageName:$version
