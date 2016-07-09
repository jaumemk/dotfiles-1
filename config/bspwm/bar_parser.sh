#! /bin/bash

padding="   "

while read -r line ; do

      # bspwm internal state
      monitor_1="%{Sf}             "
      monitor_2="%{Sl}             "
      IFS=':'
      set -- ${line#?}
      while [ $# -gt 0 ] ; do
        item=$1
        name=${item#?}
        case $item in
          *HDMI-0)
            wm_var=monitor_1
            ;;
          *DVI-I-0)
            wm_var=monitor_2
            ;;
          O*)
            # focused occupied desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{T2}$padding\\uf111$padding%{A}"
            eval $wm_var=\$workspace_string
            ;;
          F*)
            # focused free desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{T2}$padding\\uf10c$padding%{A}"
            eval $wm_var=\$workspace_string
            ;;
          U*)
            # focused urgent desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{T2}$padding\\uf111$padding%{A}"
            eval $wm_var=\$workspace_string
            ;;
          o*)
            # occupied desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{F#99FFFFFF}%{T1}$padding\\uf111$padding%{F-}%{A}"
            eval $wm_var=\$workspace_string
            ;;
          f*)
            # free desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{F#99FFFFFF}%{T1}$padding\\uf10c$padding%{F-}%{A}"
            eval $wm_var=\$workspace_string
            ;;
          u*)
            # urgent desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{F#99FFFFFF}%{T1}$padding\\uf111$padding%{F-}%{A}"
            eval $wm_var=\$workspace_string
            ;;
        esac
        shift
      done

  echo -e "%{l}$monitor_1$monitor_2"

done
