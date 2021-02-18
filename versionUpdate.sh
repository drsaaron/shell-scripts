#! /bin/sh

git add .
git commit -m 'update versions'

if [ -f pom.xml ]
then
    pomVersion=$(getPomAttribute.sh version)
elif [ -f package.json ]
then
    pomVersion=$(perl -MJSON -ne 'BEGIN {$/=undef}; my $json = from_json($_); print $json->{version} . "\n";' package.json)
else
    echo "no version found, so no tagging..." 1>&2
fi

[ "$pomVersion" != "" ] && git tag $pomVersion

git push origin master --tags

    
