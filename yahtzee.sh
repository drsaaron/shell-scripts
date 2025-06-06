#! /bin/sh

# simple script to start or stop yahtzee container depending on its current
# run state
container=yahtzee

docker ps | grep -q $container && action=stop || action=start
echo "$action-ing $container"
docker $action $container
docker $action mongodb
