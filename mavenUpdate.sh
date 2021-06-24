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

if [ -n "$updateVersion" ]
then
    newVersion=$(getPomAttribute.sh version | sed -E -e 's/^([0-9\.]+)\.([0-9]+)-([A-Z]+)$/\1 \2 \3/' | awk '{printf "%s.%s-%s", $1, $2+1, $3}')
    echo "updating to version $newVersion"
    mvn versions:set -DnewVersion=$newVersion
fi

rm -f pom.xml.versionsBackup
