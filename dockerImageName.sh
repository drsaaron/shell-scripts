#! /bin/sh

prefix=drsaaron

if [ -f pom.xml ]
then
    imageName=$prefix/$(getPomAttribute.sh artifactId | tr '[:upper:]' '[:lower:]')
elif [ -f package.json ]
then
    imageName=$prefix/$(getPackageJsonAttribute.sh name | tr '[:upper:]' '[:lower:]')
elif [ -f buildImage.sh ]
then
    imageName=$(grep ^imageName= buildImage.sh | awk -F = '{ print $2 }')
else
    echo "unable to determine image name" 1>&2
    exit 1
fi

echo $imageName
