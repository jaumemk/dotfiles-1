#!/usr/bin/env bash

blacklist="Navigator Battle.net.exe Steam.exe Pamac"

clearBars() {
	# Kill old bars
	for proc in $(pgrep 'update-title.sh');do
		kill $proc
	done
	killall lemonbar
	killall bar
	for win in `bspc query -N -n .leaf.\!window`; do bspc node $win -k ; done;
}

bspc subscribe node_manage node_geometry node_swap node_unmanage desktop pointer_action | while read line; do
	monitor=$(echo $line | awk '{print $2}')
	if [[ $line == *"pointer_action"*"begin"* ]]; then
		clearBars
	elif [[ $line != *"pointer_action"*"end"* ]] && ! ps -p $lockpid > /dev/null; then
		#statements
		# Empty bar array

		echo $line

		unset ids
		unset geos
		unset bgws

		clearBars

		# Reset split ratios
		for node in `bspc query -N -d .focused`; do 
			sr=$(bspc query -T -n $node | jq '.' | grep splitRatio | awk 'NR==1{print $2}' | head -c 3 | tail -c 1)
			if [[ $sr < 2 ]] || [[ $sr > 7 ]]; then
				bspc node $node -r 0.62
			fi
		done
		sleep 0.1

		# Get window info
		windows=$(for desk in `bspc query -D -d .focused`; do bspc query -N -d $desk ; done)

		for window in $windows ; do
			# Check if window need titlebar
			winClass="$(xprop WM_CLASS -id $window 2>/dev/null | sed -e 's/^.*= "//g' -e 's/".*$//g')"
			winHints="$(xprop _MOTIF_WM_HINTS -id $window 2>/dev/null | sed 's/^.*= //g')"
			eval $(xwininfo -id $window 2>/dev/null | sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )
			geo="${w} ${h} ${x} ${y}"
			if [[ $winClass == "WM_CLASS" ]] || [[ $winHints == "0x2, 0x0, 0x0, 0x0, 0x0" ]] || [[ $blacklist == *"$winClass"* ]] || [[ -n $(bspc query -N -n $window.fullscreen) ]] || [[ $h -gt 1400 ]]; then
				echo $(xtitle $window) is on blacklist
				continue
			fi

			# Calculate titlebars
			if [[ -z $(bspc query -N -n $window.\!tiled) ]]; then
				bspc node $window -p north -o "0.00001" -i
				bspc node $window\#@parent -r +42
				geoBar=$(echo $geo| awk '{print $1"x42+"$3"+"$4}')
			else
				geoBar=$(echo $geo| awk '{print $1"x42+"$3"+"$4-42}')
			fi

			geos=("${geos[@]}" "$geoBar")
			ids=("${ids[@]}" "$window")
			bgw=$(($w - 116))
			bgws=("${bgws[@]}" "$bgw")
			if [[ ! -e "/tmp/bg_${bgw}.png"  ]]; then
				convert ~/.config/bspwm/bg_tile.png -scale ${bgw}x42\! /tmp/bg_${bgw}.png
			fi
		done

		# Create and rearrange titlebars
		for (( i = 0; i < ${#ids[@]}; i++ )); do
			echo -e "%{c}%{I:/tmp/bg_${bgws[i]}.png:}\u200d%{l}%{I:/home/thilo/.config/bspwm/corner.png:}%{r}%{I:/home/thilo/.config/bspwm/corner-r.png:}"  | bar -d -p -B "/home/thilo/.config/bspwm/trans.png" -F "#f5f5f5" -f "Terminus:size=1" -g ${geos[i]} &
			  sleep 0.05
			  ~/.config/bspwm/update-title.sh ${ids[i]}| lemonbar -d -g ${geos[i]} -f "Roboto:size=10" -f "Roboto:size=10" -p | bash &
		done
		sleep 0.1
		for (( i = 0; i < ${#ids[@]}; i++ )); do
			barinfos="$(xwininfo -tree -root | grep ${geos[i]})"
			bgid="$(echo "$barinfos" | tail -n 1 | awk '{print $1}')"
			xdo below -t "${ids[i]}" "$bgid"
			xdo above -t "$bgid" "$(echo "$barinfos" | head -n 1 | awk '{print $1}')"
		done

		sleep 0.1 &
		lockpid=$!
	fi
done
