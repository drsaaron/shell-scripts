#! /bin/sh

if [ -f pom.xml ]
then
    currentVersion=$(getPomAttribute.sh version)
    previousVersion=$(echo $currentVersion | awk -F'[.-]' '{ printf "%s.%s.%s-%s", $1, $2, $3-1, $4 }')
elif [ -f package.json ]
then
    currentVersion=$(getPackageJsonAttribute.sh version)
    previousVersion=$(echo $currentVersion | awk -F\. '{ printf "%s.%s.%s", $1, $2, $3-1 }')
else
    echo "cannot determine current version" 1>&2
    exit 1
fi

echo "diffing tag $previousVersion and $currentVersion"
git diff $previousVersion $currentVersion
