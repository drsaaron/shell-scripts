#! /bin/sh

docker pull $(dockerImageName.sh ):$(getPomAttribute.sh version| sed 's/-RELEASE//')
docker pull $(dockerImageName.sh):latest
