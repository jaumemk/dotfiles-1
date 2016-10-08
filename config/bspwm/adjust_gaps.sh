#!/bin/bash
function linear() {
  echo "($X + $@) - ($T - 1) * $@" | bc
}

function binary() {
  echo "($X * 2) / (2  *($T -1)) + 32" | bc
}

function pitch() {
  echo "$X * 0.25 / 0.282" | bc
}

function resolution() {
  echo "$X * 1024 / 1280" | bc
}

blur=false

bspc subscribe | while read line; do
  X=128
  P=230
  firstmon=true
  if [[ $(bspc query --monitors --desktop focused) != DP-0 ]]; then
    X=$(pitch)
    firstmon=false
  fi
  # echo "$W $firstmon $blur"
  # if [[ $W != 0 ]] && [[ $firstmon == true ]] && [[ $blur == false ]]; then
  #   echo "blur"
  #   feh --bg-tile "/home/thilo/Bilder/Wallpapers/neist-point-blur.jpg"
  #   blur=true
  # elif [[ $W == 0 ]] && [[ $firstmon == true ]]; then
  #   echo "keinblur"
  #   feh --bg-tile "/home/thilo/Bilder/Wallpapers/neist-point.jpg"
  #   blur=false
  # fi
  T=$(bspc query -T -d | jq '..|.state?' | grep 'tiled\|pseudo' | wc -l)
  if [ $T -eq 1 ]; then
    monitor=$(bspc query -M --monitor focused)
    if [ "$monitor" = "DP-0" ]; then
      bspc config --desktop focused right_padding $P
      bspc config --desktop focused left_padding $P
			bspc config --desktop focused window_gap 128
		else
			bspc config --desktop focused right_padding $((P / 2 ))
			bspc config --desktop focused left_padding $((P / 2 ))
			bspc config --desktop focused window_gap 80
    fi
  else
    bspc config --desktop focused right_padding 0
    bspc config --desktop focused left_padding 0
    G=$(binary) # alternatively G=$(linear 10)
    [[ $G -lt 1 ]] && G=80
    [[ $G -lt 80 ]] && G=80
    bspc config --desktop focused window_gap $G
  fi
done
