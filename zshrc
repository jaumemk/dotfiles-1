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

cd $(cat /tmp/wmdirectory)

stty stop undef

source /usr/share/zsh/plugins/pantheon-terminal-notify-zsh-plugin/pantheon-terminal-notify.plugin.zsh

function pantheon_terminal_notify_formatted {
	# $1=exit_status, $2=command, $3=elapsed_time
	[ $1 -eq 0  ] && title="Befehl ausgeführt." || title="Befehl fehlgeschlagen."
	pantheon_terminal_notify "$title" "$2";

}

export EDITOR=vim

alias t='todo.sh'

alias pi='ssh pi@192.168.0.14'

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
