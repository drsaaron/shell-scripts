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
    pomVersion=$(getPackageJsonAttribute.sh version)
else
    echo "no version found, so no tagging..." 1>&2
fi

# tag, if we found a version
[ "$pomVersion" != "" ] && git tag $pomVersion

# figure out if the main branch is main or master
git branch | grep -q main && mainBranch=main || mainBranch=master
echo "main branch: $mainBranch"

# sanity check that we are on the main branch.
currentBranch=$(git branch --show-current)
if [ "$currentBranch" = "$mainBranch" ]
then
    # push
    git push origin $mainBranch --tags
else
    echo "currently on branch $currentBranch, so no automated push" 1>&2
    exit 1
fi

    
