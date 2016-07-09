#!/bin/bash

panel_fifo=/tmp/panel-fifo
bar_parser=~/dotfiles/config/bspwm/bar_parser.sh

# remove old panel fifo, creat new one
[ -e "$panel_fifo" ] && rm "$panel_fifo"
mkfifo "$panel_fifo"

# get bspwms status feed
bspc control --subscribe > "$panel_fifo" &


"$bar_parser" < "$panel_fifo" \
  | lemonbar \
	-a 20 \
	-b \
  -g x"56" \
  -F "#FFFFFF" \
  -B "#00000000" \
  -f "FontAwesome:size=8" \
  -f "FontAwesome:size=8" \
	| zsh &

wait
