#!/bin/bash
while true; do
  color="#aeb8c5"
  font="%{T1}"
  if [[ $1 -eq $(printf 0x%x $(xdotool getactivewindow)) ]]; then
    color="#aeb8c5"
    font="%{T2}"
  fi
  title=$(xtitle $1)
  echo -e "$font%{F$color}%{c}%{A2:bspc node $1 -c:}    $title    %{A}%{r}%{A:bspc node $1 -c:}                 %{A}"
  sleep 0.5
done
