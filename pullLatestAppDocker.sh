#! /bin/sh

imageName=$(dockerImageName.sh)
[ -f pom.xml ] && imageVersion=$(getPomAttribute.sh version | sed 's/-RELEASE//') || imageVersion=$(getPackageJsonAttribute.sh version)
docker pull $imageName:$imageVersion
docker pull $imageName:latest
