#function  z() {
	#eval "$(fasd --init auto)"
	#fasd_cd -d "$@"
#}

eval "$(fasd --init auto)"

#fasd_cache="$HOME/.fasd-init-zsh"
#if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
	#fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
#fi
#source "$fasd_cache"
#unset fasd_cache

stty stop undef

NOTIFY_COMMAND_COMPLETE_TIMEOUT=30

source /usr/share/zsh/plugins/zsh-notify/notify.plugin.zsh

export EDITOR=vim

alias t='todo.sh'

alias pi='ssh pi@raspberrypi'

alias ..='cd ..'

autoload -Uz promptinit
promptinit
prompt pure

# set an ad-hoc timer
timer() {
  local N=$1; shift

  (sleep $N && notify-send -u critical -i "/usr/share/icons/Arc/apps/32/preferences-system-time.png" "Wecker" "$@" && beep -l 50 -r 4 ) &
  echo "alarm set for $N"
}

alarm() {
  local N=$1; shift

  (sleep $(( $(date --date="$N" +%s) - $(date +%s) )) && notify-send -u critical -i "/usr/share/icons/Arc/apps/32/preferences-system-time.png" "Timer" "$@" && beep -l 50 -r 4 ) &
  echo "timer set for $N"
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
