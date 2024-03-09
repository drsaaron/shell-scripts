#! /bin/sh

# see https://askubuntu.com/questions/69556/how-do-i-check-the-batterys-status-via-the-terminal
upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"
