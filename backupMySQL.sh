#! /bin/sh

shutdownDatabase() {
    echo "stopping DB"
    cd ~/local-mysql-docker
    ./stopContainer.sh    
}

# set a trap to shutdown the DB if we're aborted
trap "shutdownDatabase; exit 1" INT

# start the db
if ! docker ps | grep -q mysql1
then
    echo "starting DB..."
    docker start mysql1
    sleep 10
    dbstarted=true
fi

# create backup file
user=aar1069
outfile=mysqlbackup-$(date '+%Y%m%d-%H%M%S')
tmpout=/tmp/$outfile.sql
tmpgpgfile=$tmpout.asc
finalout=~/mysql-backup

echo "creating backup file"
if mysqldump -u $user -p$(pass Database/MySQL/local/$user) --all-databases --host $(hostname)  > $tmpout 
then
    gpg -er dr_saaron@yahoo.com -su drsaaron@gmail.com -a -o - $tmpout > $tmpgpgfile
    [ -d $finalout ] || mkdir $finalout
    mv $tmpgpgfile $finalout

    # commit
    cd $finalout
    versionUpdate.sh -m "adding backup for $(date '+%Y-%m-%d')"
else
    echo "error creating file" 1>&2
    exit 1
fi

# shutdown DB, if we started it.
[ "$dbstarted" = "true" ] && shutdownDatabase
