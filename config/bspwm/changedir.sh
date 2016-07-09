#! /usr/bin/env bash

directory=$(cat /tmp/wmdirectory)

cd $directory

wid=$(xdotool search --name Taskbar|head -1)
traywid=$(xdotool search --name stalonetray|head -1)
xdotool windowunmap $wid &
xdotool windowunmap $traywid &
list="$(tree -ifd --noreport -L 4 . | sed -e 's/^..//' | dmenu -i -t -p '' -o 0.7 -b -nf '#ffffff' -sf '#ffffff' -nb '#2b3032' -sb '#6a94c0' -h 25 -fn 'Avenir Next-9' -s 0 -x 89 -w 1767 $@)"; sleep 0.3 && xdotool windowmap $wid; xdotool windowmap $traywid

echo "cd to $directory/$list"
cd "$directory/$list" || cd $(fasd -d "$list")
echo "cdd to $PWD"
if [ ! -z "$list" ]; then
	echo "$PWD" > /tmp/wmdirectory
fi
echo "$PWD"
