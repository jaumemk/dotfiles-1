eval "$(fasd --init auto)"
stty stop undef


NOTIFY_COMMAND_COMPLETE_TIMEOUT=30

source /usr/share/zsh/plugins/zsh-notify/notify.plugin.zsh

export EDITOR=vim

alias feh='feh --scale-down --auto-zoom'
alias t='todo.sh'

alias pi='ssh pi@192.168.0.15'

alias ..='cd ..'

autoload -Uz promptinit
promptinit
prompt pure

# set an ad-hoc timer
timer() {
  local N=$1; shift

  (sleep $N && notify-send -u critical -i "/usr/share/icons/Paper/48x48/categories/preferences-system-time.svg" "Wecker" "$@" && beep -l 50 -r 4 ) &
  echo "alarm set for $N"
}

alarm() {
  local N=$1; shift

  (sleep $(( $(date --date="$N" +%s) - $(date +%s) )) && notify-send -u critical -i "/usr/share/icons/Paper/48x48/categories/preferences-system-time.svg" "Timer" "$@" && beep -l 50 -r 4 ) &
  echo "timer set for $N"
}

zo() {
  o "$(fasd -f "$@")"
}

za() {
  atom $(fasd -f "$@")
}

search() {
  find . -name "*$1*"
}

searchreplace () {
	find proj -name "$1" -type f -exec sed -i -e "s/$2/$3/g" -- {} +
}

export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=" -R "
source /usr/share/nvm/init-nvm.sh
