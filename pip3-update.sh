#! /bin/sh

workFile=/tmp/pip3-update.txt

pip3 list --outdated |
    sed -e '1,2d' |
    grep -v '^\-e' |
    awk '{print $1}' > $workFile

if [ -s $workFile ]
then
    xargs -I % sh -c "echo \"updating %\"; pip3 install -U %" < $workFile

    echo "update complete, updated"
    cat $workFile
else
    echo "no packages to update"
fi

