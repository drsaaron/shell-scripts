#! /bin/sh 

# determine if a specific file has uncommitted changes from git.  To facilitate scripting
# if file is unchanged, then exit with a failure code, and if changed exit successfully.

while getopts :f: OPTION
do
    case $OPTION in
	f)
	    file=$OPTARG
	    ;;
	*)
	    echo "unknown option $OPTARG" 1>&2
	    exit 1
    esac
done

if [ -z "$file" ]
then
    echo "missing required file argument" 1>&2
    exit 1
fi

lineCount=$(git status --porcelain=v1 | grep $file | wc -l)

if [ "$lineCount" = 0 ]
then
    exit 1
else
    exit 0
fi

