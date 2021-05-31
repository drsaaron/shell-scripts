#! /bin/sh

pip3 list --outdated --format=freeze |
    grep -v '^\-e' |
    cut -d = -f 1 |
    xargs -I % sh -c "echo \"updating %\"; pip3 install -U %"
