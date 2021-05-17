#! /bin/sh

#***************************************************************************
#
# Given a process ID, find all child processes and list them in
# hierarchically.
#
#***************************************************************************

psFile=/tmp/psFile-$$

# function to nicely format output.  see https://unix.stackexchange.com/questions/561577/awk-print-from-nth-column-to-last
# for the explanation of part of the awk.
formatOutput() {
    # print the userID, process ID, parent proces ID, and process detail.  That's all there is, but
    # this will reduce the whitespace.  Plus it's an interesting use of awk.
    awk -v n=4 '{ printf "%s %s %s%s", $1, $2, $3, OFS; for (i=n; i<=NF;i++) printf "%s%s", $i, (i<NF ? OFS : ORS) }'
}

# Function to determine the children of a given process
findChildrenPIDs() {
    parentPID=$1
    awk '$3 == "'$parentPID'" { print $2 }' $psFile
}

# For an array of processes, print the process and it's children.
printChildren() {
    parentPID=$1 || return

    # Exclude this process since it will cause an infinite loop.
    # The code below implements the indenting by spawning a 
    # subshell, whose parent is this process.  So this process
    # would have a child and the loop would repeat, ad infinitum.
    # We probably don't want to see this process anyway.
    [ $parentPID = $$ ] && return  

    # show the parent
    echo "$indent\c"
    awk '$2 == "'$parentPID'" { print }' $psFile | formatOutput
    
    # iterate over the children.
    for childPID in `findChildrenPIDs $parentPID`
    do
	# recursion!
	( 
	    indent="$indent  "
	    printChildren $childPID
	)
    done
}

indent=""
# get the base PID.
if [ $# != 1 ]
then
    echo "usage:  `basename $0` base_PID" 1>&2
    exit 1
fi
basePID=$1

# dump all processes to a temp file
ps -e -o user,pid,ppid,command > $psFile

# do it.
printChildren $basePID

# clean up
rm -f $psFile
