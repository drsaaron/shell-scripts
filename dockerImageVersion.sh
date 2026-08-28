#! /bin/sh

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

echo $version
