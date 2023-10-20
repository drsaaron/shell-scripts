#! /bin/sh

cd ~/NetBeansProjects/BlazarJavaBase
updateImage.sh

dbstarted=false
mysql=mysql1
startDB() {
    if docker ps |grep -q $mysql
    then
	echo "$mysql is already running"
    else
	echo "starting $mysql"
	docker start $mysql
	dbstarted=true
    fi
}

stopDB() {
    if [ "$dbstarted" = "true" ]
    then
	echo "stopping $mysql"
	docker stop $mysql
    fi
}

# start mysql, which is needed to build BlazarUserManagement.  
startDB

# set a trap so that when this process exits, if the DB was started by it the DB will also be stopped
trap "stopDB; exit 0" INT EXIT

bulkMavenUpdate.sh BlazarCryptoFile BlazarUserManagement-tokenUtil BlazarUserManagement-serverUtil BlazarUserManagement BlazarFacebookClient BlazarJobManager BlazarMailer BlazarMailer-springImpl DateServices TelegramClient QuoteOfTheDay-data QuoteOfTheDay-data-jpaImpl QuoteOfTheDay-process QuoteOfTheDayServices QuoteOfTheDayJob
