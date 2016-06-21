# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh/

DISABLE_AUTO_UPDATE="true"
#COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-syntax-highlighting archlinux colored-man-pages)

alias sc='xrandr --output DVI-1 --auto --output DVI-0 --left-of DVI-1 --auto'
alias suspend_dpms='xset -dpms; xset s off; (sleep 2h; xset s on; xset +dpms) &'
alias wsteam='wine "C:\\Steam\\Steam.exe" -no-dwrite &!'
alias tea='termdown -f roman -b 2m'

fs() { sudo du -haxd3 -t500M $* | sort -h }

ffcut() { ffmpeg -i $1 -ss $2 -to $3 -vf "subtitles='$1'" $4 }
ffcut_nosub() { ffmpeg -i $1 -ss $2 -to $3 $4 }

mute_music() {
	music_playing=$(mpc | grep '^\[playing\]')
	[[ $music_playing ]] && mpc -q pause
	eval $*
	[[ $music_playing ]] && mpc -q play
}

work() { termdown -f roman $* && mute_music "(xdg-open http://matmartinez.net/nsfw/ &>/dev/null & termdown -b -f roman 0 -t 'good job')" }

rvm_init() {
	export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
}

source $ZSH/oh-my-zsh.sh

PROMPT=$'
%{\e[1;34m%}┌─[%{\e[0;36m%}%n%{\e[0;34m%}@%{\e[0;32m%}%m%{\e[1;34m%}]───[%{\e[0;33m%}%D{%Y/%m/%d}, %*%{\e[1;34m%}]───[%{\e[1;37m%}%~%{\e[1;34m%}]%{\e[0m%} 
%{\e[1;34m%}└─[%{\e[1;35m%}$%{\e[1;34m%}]%{\e[0m%} '

typeset -g -A key

bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line

unset LESS # thanks, but no thanks
