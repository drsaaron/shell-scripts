#! /bin/sh

# get the value of an attribute from the pom.  We will only look at the first
# instance of that attribute in the file.

while getopts :p: OPTION
do
    case $OPTION in
	p)
	    pomFile=$OPTARG
	    ;;
	*)
	    echo "invalid option $OPTARG" 1>&2
	    exit 1
	    ;;
    esac
done

shift $((OPTIND - 1))

tag=$1

if [ -z "$tag" ]
then
    echo "usage: $0 [-p pomFile] <tag>" 1>&2
    exit 1
fi 

# as this is a pom, root attribute is project.  If the caller has not specified that (older versions
# of this script just supplied the tag which was assumed at the level under project) prefix that path
# so the xpath expansion can work correctly.
if ! echo $tag | egrep -q '^/project'
then
    tag="/project/$tag"
fi

# convert the tag path to proper xpath with the pom peculiarities
xpath=/$(echo $tag | sed -E 's%/([^/]+)%/*[local-name()="\1"]%g')

# find it.
value=$(xmllint --xpath "$xpath/text()" ${pomFile:-pom.xml})
#value=$(grep "^ *<$tag>" ${pomFile:-pom.xml} | head -1 | sed -E -e "s%</?$tag>%%g" -e 's/ //g')
echo $value
