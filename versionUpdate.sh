#! /bin/sh

while getopts :m:t: OPTION
do
    case $OPTION in
        m)
            commitMessage=$OPTARG
            ;;
	t)
	    tag=$OPTARG
	    ;;
        *)
            echo "invalid option $OPTION" 1>&2
            exit 1;
    esac
done

git add .
git commit -m "${commitMessage:-version update}"

# figure out if the main branch is main or master
git branch | grep -q main && mainBranch=main || mainBranch=master
echo "main branch: $mainBranch"

# get the current branch
currentBranch=$(git branch --show-current)

# if we're on the main branch, try to tag
if [ "$currentBranch" = "$mainBranch" ]
then
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
    if [ -n "$pomVersion" ]
    then
	git tag $pomVersion
	tagFlag="--tags"
    fi
else
    echo "currently on branch $currentBranch so not tagging"
fi

# apply the requested tag, if there is one
if [ -n "$tag" ]
then
    echo "tagging with $tag as requested"
    git tag $tag
    [ -z "$tagFlag" ] && tagFlag="--tags"
fi

# push
echo "pushing to branch $currentBranch"
git push origin $currentBranch $tagFlag
    
