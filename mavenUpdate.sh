#! /bin/sh

while getopts :v OPTION
do
    case $OPTION in
	v)
	    updateVersion=1
	    ;;
	*)
	    echo "unrecognized option $OPTARG" 1>&2
	    exit 1
    esac
done

mvn versions:update-parent
mvn versions:use-next-versions

# update version, but only if something has changed
if [ -n "$updateVersion" ]
then
    if gitFileChanged.sh -f pom.xml
    then
	newVersion=$(getPomAttribute.sh version | sed -E -e 's/^([0-9\.]+)\.([0-9]+)-([A-Z]+)$/\1 \2 \3/' | awk '{printf "%s.%s-%s", $1, $2+1, $3}')
	echo "updating to version $newVersion"
	mvn versions:set -DnewVersion=$newVersion
    else
	echo "no changes to pom, so no update to version"
    fi
fi

rm -f pom.xml.versionsBackup
