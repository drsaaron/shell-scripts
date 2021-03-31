#! /bin/sh

# for the .* files, which are presumably shell init files, remove
# the version at home directory and replace with a link to here.
# ignore files like ., .., and .git
thisDir=`pwd`

echo .* | tr -s '[:blank:]' '[\n*]' | egrep -v '(\.|\.git)$' |
    while read file
    do
	if [ -f ~/$file ]
	then
	    echo rm ~/$file
	    echo ln -s $thisDir/$file ~/$file
	fi
    done
