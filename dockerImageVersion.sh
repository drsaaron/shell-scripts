#! /bin/sh

if [ -f pom.xml ]
then
    imageVersion=$(getPomAttribute.sh version)
    version=${imageVersion%-*}
elif [ -f package.json ]
then
    version=$(getPackageJsonAttribute.sh version)
else
    echo "unable to determine version" 1>&2
    exit 1
fi

echo $version
