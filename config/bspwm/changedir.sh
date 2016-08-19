#! /usr/bin/env bash

directory=$(cat /tmp/wmdirectory)

cd $directory

list="$(tree -ifd --noreport -L 4 . | sed -e 's/^..//' | rofi -dmenu -lines 25 -width 18% -location 7 -bw 0 -font 'Avenir Next 9' -yoffset -25 -xoffset 36 -p '' -i -separator-style 'none' -color-normal '#002b3032,#ffffff,#00000000,#6a94c0,#ffffff' -color-window '#cc2b3032, ##66000000' -padding 4 -scrollbar-width 4 $@)"; xdotool windowmap $wid; xdotool windowmap $traywid

echo "cd to $directory/$list"
cd "$directory/$list" || cd $(fasd -d "$list")
echo "cdd to $PWD"
if [ ! -z "$list" ]; then
	echo "$PWD" > /tmp/wmdirectory
fi
echo "$PWD"
