#! /bin/sh

ps -ef |grep xfce4-[s]ession | awk '{ print }' | xargs kill
