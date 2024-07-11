#! /bin/sh

containerName=mysql1

shutdownDatabase() {
    if [ -n "$dbstarted" ]
    then
	echo "stopping DB"
	docker stop $containerName
    fi
}

# set a trap to shutdown the DB if we're aborted
trap "shutdownDatabase; exit 1" INT

# start the db
if ! docker ps | grep -q $containerName
then
    echo "starting DB..."
    docker start $containerName
    dbstarted=true
    sleep 10
fi

# create backup file
user=aar1069
outfile=mysqlbackup-$(date '+%Y%m%d-%H%M%S')
tmpout=/tmp/$outfile.sql
tmpgpgfile=$tmpout.asc
finalout=~/mysql-backup

echo "creating backup file"
if docker exec -it $containerName mysqldump -u $user -p$(pass Database/MySQL/local/$user) --all-databases --host $(hostname)  > $tmpout 
then
    gpg -er dr_saaron@yahoo.com -su drsaaron@gmail.com -a -o - $tmpout > $tmpgpgfile
    [ -d $finalout ] || mkdir $finalout
    mv $tmpgpgfile $finalout

    # commit
    if [ -n "$(uname -n | grep Pavilion)"  ]
    then
	echo "committing changes for production backup"
	cd $finalout
	versionUpdate.sh -m "adding backup for $(date '+%Y-%m-%d')"
    else
	echo "not on production so no commit to github"
    fi
else
    echo "error creating file" 1>&2
    exit 1
fi

# shutdown DB, if we started it.
shutdownDatabase
