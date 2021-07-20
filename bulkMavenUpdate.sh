#! /bin/sh

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
	mvn clean install
	
	# push to git
	versionUpdate.sh
	
	# if there's a dockerfile, build and push
	if [ -f Dockerfile ]
	then
	    pullLatestDocker.sh
	    buildDocker.sh
	    pushDocker.sh
	fi
    fi
done

# show the projects that were updated
if [ -s $trackFile ]
then
    echo "projects updated:"
    cat $trackFile
else
    echo "no projects updated"
fi

	    
