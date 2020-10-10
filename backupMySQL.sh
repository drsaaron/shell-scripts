#! /bin/ksh

# start the db
dbps=$(docker ps | grep mysql1)
if [ "$dbps" = "" ]
then
    echo "starting DB..."
    docker start mysql1
    sleep 10
    dbstarted=true
fi

# create backup file
user=aar1069
outfile=mysqlbackup-$(date '+%Y%m%d-%H%M%S')
tmpout=/tmp/$outfile
finalout=$BOXDIR/mysqlbackup

echo "creating backup file"
mysqldump -u $user -p$(pass Database/MySQL/local/$user) --all-databases --host $(hostname)  > $tmpout
status=$?
if [ "$status" = "0" ]
then
    gzip -c $tmpout | gpg -er dr_saaron@yahoo.com -su drsaaron@gmail.com -a > $tmpout.asc
    [ -d $finalout ] || mkdir $finalout
   # mv $tmpout.asc $finalout
else
    echo "error creating file" 1>&2
    exit 1
fi

# shutdown DB, if we started it.
if [ "$dbstarted" = "true" ]
then
    echo "stopping DB"
    cd ~/local-mysql-docker
    ./stopContainer.sh
fi
