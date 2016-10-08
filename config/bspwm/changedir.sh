#! /usr/bin/env bash

directory=$(cat /tmp/wmdirectory)

cd $directory

list="$(tree -ifd --noreport -L 4 . | sed -e 's/^..//' | rofi -dmenu -lines 25 -width 15% -location 7 -bw 0 -font 'Roboto 9' -yoffset -32 -xoffset 36 -p '' -i -separator-style 'none' -color-normal '#005a94c1,#666666,#00000000,#5a94c1,#ffffff' -color-window '#ffffffff, ##66000000' -padding 4 -scrollbar-width 4 $@)"; # xdotool windowmap $wid; xdotool windowmap $traywid

echo "cd to $directory/$list"
cd "$directory/$list" || cd $(fasd -d "$list")
echo "cdd to $PWD"
if [ ! -z "$list" ]; then
	echo "$PWD" > /tmp/wmdirectory
fi
echo "$PWD"
