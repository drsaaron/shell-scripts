#! /bin/sh

doVersionUpdate=

while getopts :d:v OPTION
do
    case $OPTION in
	d)
	    workDir=$OPTARG
	    ;;
	v)
	    doVersionUpdate=1
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

[ -n "$workDir" ] && cd $workDir

for dir in *
do
    if [ -d $dir ]
    then
	(
	    cd $dir
	    if [ -d .git ]
	    then
		message=$dir
		if [ -n "$(git status --porcelain)" ]
		then
		    message="$message uncommited change found"
		    [ -n "$doVersionUpdate" ] && versionUpdate.sh
		fi
		echo $message
	    fi
	)
    fi
done
