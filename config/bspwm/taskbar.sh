#!/bin/bash
itemLength=30
outerPadding="   "

panel_height=25

normalFg="FFFFFFFF"
activeBg="#992b3032"
activeFg="#FFFFFF"
inactiveBG="#662b3032"
inactiveFG="#99FFFFFF"

declare -A icons
icons=( ["Firefox"]="f269" ["Atom"]="f121" ["Gnome-terminal"]="f120" ["Discord"]="f0e6" ["Spotify"]="f1bc" ["Skype"]="f17e" ["Nemo"]="f07c" ["Gpicview"]="f03e" ["Steam"]="f1b6")

iconfor() {
  icon=${icons["$1"]}
  if [[ -n "$icon" ]]; then
    echo "%{T3}\u$icon%{T1}  "
  else
    echo "%{T3}\uf096%{T1}  "
  fi
}

# bspc control --subscribe | while read line; do
while true; do

  wininfo=$(bspc query -T)

  IFS=$'\n'

  space=0
  first=true
  empty=true

  monitor=1

  line=""

  pad=$(printf '%0.1s' " "{1..60})

  active=false
  monitoractive=false

  directory=$(cat /tmp/wmdirectory | sed 's/\/home\/thilo/~/')

  for i in $wininfo; do
    if [[ $i =~ wrapper-1.0 ]]; then
      continue
    fi
    # monitor handling
    if [[ $i =~ ^[HVD] ]]; then
      datetime=$(date '+%H:%M')
      line="${line}%{S$monitor}"
      if [[ $i =~ ^H ]]; then
        line="${line}%{r}%{B#00000000}%{T2}             $datetime$outerPadding  %{T1}%{B$inactiveBG}%{l}%{B#00000000}$outerPadding%{A:xfce4-popup-whiskermenu:}           %{A}%{B$inactiveBG}%{F#CCFFFFFF}%{A:~/.config/bspwm/changedir.sh:} $directory    \u203A %{A}%{F#$normalFg}  "
	else
		line="$line%{r}%{T2}$datetime$outerPadding%{T1}%{l}$outerPadding"
      fi
      ((monitor--))
      if [[ $i =~ $(printf "\*\s*$") ]]; then
        monitoractive=true
      fi
    fi
    # check for desktop
    if [[ $i =~ ^$(printf "\t")[0-9] ]]; then
      if [[ $empty == true ]] && [[ $active == true ]]; then
        line="${line}%{F${activeFg}}  $space  %{F-}"
        active=false
      fi
      if [[ $i =~ $(printf "\*\s*$") ]]; then
        active=true
      else
        active=false
      fi
      space=$(echo $i | awk '{print $1}')
      empty=true
      first=true
    fi
    # check for windows
    if [[ $i == *"	m "* ]] || [[ $i == *"	c "* ]] || [[ $i == *"	a "* ]]; then
      if [[ $first == true ]]; then
        if [[ $active == true ]]; then
          line="${line}%{F${activeFg}}"
      	else
      	  line="${line}%{F${inactiveFG}}"
        fi
        line="${line}  $space  "
        first=false
      	line="${line}%{F-}"
      fi
      # active window
      if [[ $active == true ]] && [[ $monitoractive == true ]]; then
        if [[ $i =~ $(printf "\*\s*$") ]]; then
          line="${line}%{T2}%{F${activeFg}}%{B${activeBg}}%{u}"
        fi
      fi
      # get window name
      while IFS=" " read -r id rest; do
        window="$(xtitle $id | awk -v len=$itemLength '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }')"
        winClass="$(xprop WM_CLASS -id $id | awk '{print $4}' | sed 's/\"//g')"
        paddingLength=$(echo "scale=0;($itemLength - ${#window}) * 0.9 / 1" | bc)
        padding=$(printf '%*.*s' 0 $paddingLength "$pad")
        line="${line}%{A:bspc window -f $id:}    $window$padding$padding     %{A}"
      done <<< "$(echo $i | grep -o '0x.* ')"
      # close active window
      if [[ $active == true ]] && [[ $monitoractive == true ]]; then
        if [[ $i =~ $(printf "\*\s*$") ]]; then
          line="${line}%{u-}%{F-}%{B-}%{T1}"
          active=false
          monitoractive=false
        fi
      fi
      empty=false
    fi
  done
  if [[ $first == true ]] && [[ $active == true ]]; then
    line="${line}%{F${activeBg}}"
    line="${line}  $space  "
    first=false
    line="${line}%{F-}"
  fi
  echo -e "$line"
  sleep 0.3
done | lemonbar -n "Taskbar" -b -f "Avenir Next:size=9" -f "Avenir Next DemiBold:size=9" -f "FontAwesome:size=11" -g x"$panel_height" -B "$inactiveBG" -F "#$normalFg" -U "$activeBg" -a "30" -u 2 | zsh
