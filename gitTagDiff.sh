#! /bin/sh 

while getopts :c:p: OPTION
do
    case $OPTION in
	c)
	    currentVersion=$OPTARG
	    ;;
	p)
	    previousVersion=$OPTARG
	    ;;
	*)
	    echo "unknown option $OPTART" 1>&2
	    exit 1
    esac
done

# sanity check that if one version is provided, so is the other.
if [ \( -z "$currentVersion" -a -n "$previousVersion" \) -o \( -n "$currentVersion" -a -z "$previousVersion" \) ]
then
    echo "cannot specify one version without the other" 1>&2
    exit 1
fi

# if nothing was provided, get from the build config.  We've already validated that both would
# be set, so we just need to check if one version is provided.
if [ -z "$currentVersion" ]
then
    if [ -f pom.xml ]
    then
	currentVersion=$(getPomAttribute.sh version)
	previousVersion=$(echo $currentVersion | awk -F'[.-]' '{ printf "%s.%s-%s", $1, $2-1, $3 }')
    elif [ -f package.json ]
    then
	currentVersion=$(getPackageJsonAttribute.sh version)
	previousVersion=$(echo $currentVersion | awk -F\. '{ printf "%s.%s.%s", $1, $2, $3-1 }')
    else
	echo "cannot determine current version" 1>&2
	exit 1
    fi
fi

echo "diffing tag $previousVersion and $currentVersion"
git diff $previousVersion $currentVersion
