#!/usr/bin/env bash

# https://gist.github.com/avindra/dd2c6f14ec6e03b05261d370ef60c9d8

# alternative way is to use PID of Alacritty from environment variable $ALACRITTY_LOG

focus_pid="$(xdotool getactivewindow getwindowpid)"

tty=$(ps o tty= --ppid $focus_pid)

if [ -z "$tty" ]; then exit 1; fi

clear > "/dev/$tty"
#echo -e "\ec" > /dev/$tty
#printf "\e[2J\e[3J\e[H\n" > /dev/$tty
