#! /bin/sh 

while getopts :a OPTION
do
    case $OPTION in
	a)
	    allFiles=true
	    ;;
	*)
	    echo "usage: $0 [-a]" 1>&2
	    exit 1
    esac
done

shift $((OPTIND - 1))

# a simple shell script to convert a semi-colon delimited list, e.g. $PATH, into a list
# of unique elements from that list.  The script currently assumes the list elements are
# directories, but the optional -a flag will remove that requirement.

list=$1
uniqueList=

# be sure to handle spaces in the element.  Do this by manipulating the input field separator IFS
origIFS=$IFS
IFS=:
for pathel in $(echo "$list")
do
    # this is in a subshell so set IFS back to the original so that subsequent commands work as expected
    IFS=$origIFS

    if [ -n "$allFiles" -o -d "$pathel" ] 
    then  # directory exists or we don't care
        [ "`echo $uniqueList | perl -ne \"m%:$pathel(?=:|\Z)% && print\"`" = "" ] && uniqueList=$uniqueList:$pathel
    fi
done

IFS=$origIFS
echo $uniqueList
