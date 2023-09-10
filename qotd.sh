#! /bin/sh

# toggle qotd

# check the services container.  If running, assume they all are and stop them.
# else start them
if docker ps | grep -q quoteofthedayservices
then
    echo "services running so stopping"
    action=stop
else
    echo "services not running so starting"
    action=start
fi

# do it
docker $action mysql1 blazarusermanagement quoteofthedayservices quoteofthedayui
