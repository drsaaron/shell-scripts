#! /bin/sh

archiveStarted=false
startArchive() {
    if docker ps | grep -q blazararchive
    then
	echo "blazar archive already running...."
    else
	echo "starting blazar archive"
	docker start blazararchive
	archiveStarted=true
    fi
}

stopArchive() {
    if [ "$archiveStarted" = "true" ]
    then
	echo "stopping blazar archive"
	docker stop blazararchive
	archiveStarted=false
    fi
}

startArchive

# this script will update the pom for all quote of the day related repos

NBDIR=~/NetBeansProjects

trackFile=/tmp/bulkUpdate-updates
rm -f $trackFile

# update the projects
for project in $*
do
    cd $NBDIR/$project

    # update the pom
    mavenUpdate.sh -v

    # if we updated, do a build
    if ! git diff-index --quiet HEAD pom.xml
    then
	# track that we updated
	echo $project >> $trackFile
	
	# build
	echo "building $project"
	if mvn clean install deploy
	then
	    # push to git
	    versionUpdate.sh
	
	    # if there's a dockerfile, build and push
	    if [ -f Dockerfile ]
	    then
		pullLatestDocker.sh
		buildDocker.sh
		pushDocker.sh
	    fi
	else
	    echo "error building $project" 1>&2
	    exit 1
	fi
    fi
done

# show the projects that were updated
printf "\nResults summary\n"
if [ -s $trackFile ]
then
    echo "projects updated:"
    cat $trackFile
else
    echo "no projects updated"
fi

stopArchive

