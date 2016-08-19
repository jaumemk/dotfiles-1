#! /bin/bash

wid=$(xdotool search --name Taskbar|head -1)
traywid=$(xdotool search --name stalonetray|head -1)
xdotool windowunmap $wid &
xdotool windowunmap $traywid
while [[ -n "$(xdotool search --onlyvisible --class dunst)" ]]; do
  sleep 0.2
done
xdotool windowmap $wid
xdotool windowmap $traywid
