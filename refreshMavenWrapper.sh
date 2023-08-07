#! /bin/sh 

while getopts :v: OPTION
do
    case $OPTION in
	v)
	    version=$OPTARG
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

# what's the current installed version, if not supplied
[ -z "$version" ] && version=$(mvn --version | grep '^Apache' | awk '{print $3}')

# find all wrappers under ~/NetBeansProjects
for wrapper in ~/NetBeansProjects/*/mvnw
do
    echo "looking at $wrapper"

    # what's the wrapper version
    wrapperVersion=$($wrapper --version | grep '^Apache' | awk '{print $3}')

    # if the wrapper version is older than current version, update.  To do this, echo both $version
    # and $wrapperVersion, and sort such that the newer version is first.
    if [ "$version" != "$wrapperVersion" ]
    then
	higherVersion=$(echo $version $wrapperVersion | tr ' ' '\n' | sort -r | head -1)
	if [ "$higherVersion" = "$version" ]
	then
	    echo "updating $wrapper to be $version (from $wrapperVersion)"
	    (cd $(dirname $wrapper); ./mvnw wrapper:wrapper -Dmaven=$version)
	else
	    echo "wrapper is past $version already"
	fi
    else
	echo "wrapper is at $version already"
    fi
done
