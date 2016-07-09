#! /bin/bash

wid=$1
class=$2
instance=$3

# echo "$class" >> /tmp/notification_test.txt

if [[ ("$class" !=  "Xfce4-notifyd") ]]; then
	bspc window -t pseudo_tiled=off
fi

if [ "$class" = "rads_user_kernel.exe" ] ; then
	xdotool windowunmap "0x$(echo "obase=16; $wid" | bc)"
fi

if [[ ( ("$class" = "Gnome-terminal") || ("$class" = "Nemo") ) && ("$(bspc query -W -d focused | wc -l)" -lt 1) ]] ; then
	# bspc window "0x$(echo "obase=16; $wid" | bc)" -t pseudo_tiled=on
	echo "pseudo_tiled=on"
fi
