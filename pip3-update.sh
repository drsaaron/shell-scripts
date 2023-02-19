#! /bin/sh

pip3 list --outdated |
    sed -e '1,2d' |
    grep -v '^\-e' |
    awk '{print $1}' |
    xargs -I % sh -c "echo \"updating %\"; pip3 install -U %"
