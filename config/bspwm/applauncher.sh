#! /usr/bin/env bash

wid=$(xdotool search --name Taskbar|head -1)
traywid=$(xdotool search --name stalonetray|head -1)
xdotool windowunmap $wid &
xdotool windowunmap $traywid &
j4-dmenu-desktop --dmenu="/home/thilo/Downloads/yeganesh-2.5-bin/yeganesh -- -i -t -p '' -o 0.7 -b -nf '#ffffff' -sf '#ffffff' -nb '#2b3032' -sb '#6a94c0' -h 25 -fn 'Avenir Next-9' -s 0 -x 89 -w 1767; sleep 0.3 && xdotool windowmap $wid; xdotool windowmap $traywid"

