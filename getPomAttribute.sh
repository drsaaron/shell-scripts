#! /bin/sh

# get the value of an attribute from the pom.  We will onlyh look at the first
# instance of that attribute in the file.

if [ $# != 1 ]
then
    echo "usage: $0 <tag>" 1>&2
    exit 1
fi

tag=$1
value=$(grep "^ *<$tag>" pom.xml | head -1 | sed -E -e "s%</?$tag>%%g" -e 's/ //g')
echo $value
