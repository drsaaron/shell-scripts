#! /bin/sh

EXT_JAVA_DIR=~/extJava

action=list

while getopts :a:t:v: OPTION
do
    case $OPTION in
	a)
	    action=$OPTARG
	    if [ "$action" != 'list' -a "$action" != "update" ]
	    then
		echo "invalid action $action.  Can only be list or update" 1>&2
		exit 1
	    fi

	    ;;
	t)
	    tool=$OPTARG
	    if [ "$tool" != 'maven' -a "$tool" != "gradle" ]
	    then
		echo "invalid tool $tool.  Can only be maven or gradle" 1>&2
		exit 1
	    fi

	    ;;

	v)
	    version=$OPTARG
	    ;;

	*)
	    echo "invalid option $OPTARG" 1>&2
	    exit 1
    esac
done

# sanity check
if [ -z "$tool" ]
then
    echo "a tool (-t) is required" 1>&2
    exit 1
fi

if [ "$action" = "update" -a -z "$version" ]
then
    echo "a version is required for update" 1>&2
    exit 1
fi

# do the needful
cd $EXT_JAVA_DIR
if [ "$action" = "list" ]
then
    cd $tool
    ls -tr | nl
fi
