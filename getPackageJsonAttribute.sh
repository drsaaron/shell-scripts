#! /bin/sh

# get the value of an attribute from the package.json file.  We will only look at the first
# instance of that attribute in the file.  Counterpart to getPomAttribute.sh

while getopts :p: OPTION
do
    case $OPTION in
	p)
	    packageJsonFile=$OPTARG
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
    echo "usage: $0 [-p packageJsonFile] <tag>" 1>&2
    exit 1
fi

value=$(perl -MJSON -ne 'BEGIN {$/=undef}; my $json = from_json($_); print $json->{'$tag'} . "\n";' ${packageJsonFile:-package.json})
echo $value
