#!/usr/bin/env bash

# echo "$(echo "$3" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | sed 's/-> //g')"

zenity --title="$(echo "$2" | awk '{print $1}') Updates verfügbar" --width=488 --height=640 --list --separator=" " --text="Folgende Updates werden installiert:" --ok-label="Syu!" --column="Paket" --column="installierte Version" --column="aktuelle Version" $(echo "$3" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | sed 's/-> //g') && gnome-terminal -e "sudo pacman -Syu"
