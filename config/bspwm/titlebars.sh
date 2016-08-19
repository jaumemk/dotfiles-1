#!/bin/bash
# use lemonboys bar to display titlebars

# barPids=/tmp/titleBarPids
# touch $barPids

wininfo=$(bspc query -T)
windows=""

SAFEIFS=$IFS
IFS=$'\n'

for i in $wininfo; do
  if [[ $i =~ ^$(printf "\t")[0-9] ]] && [[ $i =~ '*' ]]; then
    windows="$windows $(bspc query -W -d $(echo $i | awk '{print $1}'))"
    windows="$windows M"
  fi
done

# if [[ "$windows" == "" ]];then
#     kill $(cat $barPids)
#     rm $barPids
#     exit
# fi

IFS=$SAFEIFS

OLDEST_PID=$(pgrep -o 'lemonbar')
test $OLDEST_PID && pgrep 'lemonbar' | grep -vw $OLDEST_PID | xargs -r kill

for proc in $(pgrep 'update-title.sh');do
  kill $proc
done

killall bar

# rm $barPids
#sleep 2
blankscreen=false
for id in $windows; do
  if [[ $id == "M" ]]; then
    blankscreen=false
    continue
  elif [[ $blankscreen == true ]]; then
    continue
  fi
  winClass="$(xprop WM_CLASS -id $id)"
  if [[ $winClass =~ Steam ]] || [[ $winClass =~ rads_user_kernel.exe ]] || [[ $winClass =~ Wrapper-1.0 ]] || [[ $winClass =~ xfce4-panel ]]; then
    continue
  fi
  eval $(xwininfo -id $id |
    sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
           -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
           -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
           -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" )
  geo="${w} ${h} ${x} ${y}"
  geoBar=$(echo $geo| awk '{print $1+4"x32+"$3"+"$4-32}')
  if [ "$h" -lt "1024" ]; then
    geos=("${geos[@]}" "$geoBar")
    ids=("${ids[@]}" "$id")
    bgw=$(($w - 116))
    bgws=("${bgws[@]}" "$bgw")
    if [[ ! -e "/tmp/bg_${bgw}.png" ]]; then
      convert ~/.config/bspwm/bg_tile.png -resize ${bgw}x32\! /tmp/bg_${bgw}.png
    fi
  else
    blankscreen=true
  fi
done



for (( i = 0; i < ${#ids[@]}; i++ )); do
  echo -e "%{c}%{I:/tmp/bg_${bgws[i]}.png:}\u200d%{l}%{I:/home/thilo/.config/bspwm/corner.png:}%{r}%{I:/home/thilo/.config/bspwm/corner-r.png:}"  | bar -d -p -B "/home/thilo/.config/bspwm/trans.png" -F "#4e585d" -f "Terminus:size=1" -g ${geos[i]} &
  sleep 0.05
  ~/.config/bspwm/update-title.sh ${ids[i]}| lemonbar -d -g ${geos[i]} -f "Avenir Next Medium:size=9" -f "Avenir Next DemiBold:size=9" -p | bash &
done
sleep 0.1
for (( i = 0; i < ${#ids[@]}; i++ )); do
  barinfos="$(xwininfo -tree -root | grep ${geos[i]})"
  bgid="$(echo "$barinfos" | tail -n 1 | awk '{print $1}')"
  xdo below -t "${ids[i]}" "$bgid"
  xdo above -t "$bgid" "$(echo "$barinfos" | head -n 1 | awk '{print $1}')"
done
