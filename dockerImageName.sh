#! /bin/sh

if [ -f pom.xml ]
then
    imageName=$(getPomAttribute.sh artifactId | tr '[:upper:]' '[:lower:]')
elif [ -f package.json ]
then
    imageName=$(getPackageJsonAttribute.sh name | tr '[:upper:]' '[:lower:]')
else
    echo "unable to determine image name" 1>&2
    exit 1
fi

echo drsaaron/$imageName
