#! /bin/sh

while getopts :m: OPTION
do
    case $OPTION in
        m)
            commitMessage=$OPTARG
            ;;
        *)
            echo "invalid option $OPTION" 1>&2
            exit 1;
    esac
done

git add .
git commit -m "${commitMessage:-version update}"

# find the version, from either pom or package.json
if [ -f pom.xml ]
then
    pomVersion=$(getPomAttribute.sh version)
elif [ -f package.json ]
then
    pomVersion=$(perl -MJSON -ne 'BEGIN {$/=undef}; my $json = from_json($_); print $json->{version} . "\n";' package.json)
else
    echo "no version found, so no tagging..." 1>&2
fi

# tag, if we found a version
[ "$pomVersion" != "" ] && git tag $pomVersion

# figure out if the main branch is main or master
[ "$(git branch | grep main)" = "" ] && mainBranch=master || mainBranch=main
echo "main branch: $mainBranch"

# push
git push origin $mainBranch --tags

    
