# oh-my-zsh configuration
ZSH=/usr/share/oh-my-zsh/
DISABLE_AUTO_UPDATE="true"
plugins=(git zsh-syntax-highlighting archlinux colored-man-pages)
source $ZSH/oh-my-zsh.sh

# Extending history size
SAVEHIST=100000
HISTSIZE=100000

# Custom aliases and commands
alias sc='xrandr --output DVI-D-1 --auto --output DVI-I-1 --left-of DVI-D-1 --auto'
alias suspend_dpms='xset -dpms; xset s off; (sleep 2h; xset s on; xset +dpms) &'
alias wsteam='wine "C:\\Steam\\Steam.exe" -no-dwrite &!'
alias tea='termdown -f roman -b 2m'
alias woops='mv ~/stuff/screenshots/20*.png .;mount stuff;mv 20*.png ~/stuff/screenshots/'

wp() { WINEPREFIX=~/games/wineprefixes/$1 ${@:2} }
_wp() {
	_arguments '1:wineprefix:{_files -W ~/games/wineprefixes/}' '*:r:->r'
	if [[ -n "$state" ]]; then shift 2 words; ((CURRENT--)); ((CURRENT--)); _normal; fi
}
compdef _wp wp

winetemp() { WINEPREFIX=$(mktemp -d /tmp/XXXXXXXXX.wine) wine $@ }

pw() {
	stty -echo
	python -c "import sys,scrypt; sys.stdout.buffer.write(scrypt.hash(sys.stdin.readline(),\"\",buflen=$1))" | base64 | tr -d "\n" | xclip
}

fs() { sudo du -haxd3 -t500M $* | sort -h }

ffcut() { ffmpeg -i $1 -ss $2 -to $3 -vf "subtitles='$1'" $4 }
ffcut_nosub() { ffmpeg -i $1 -ss $2 -to $3 $4 }

twitch_update() { curl -H "Accept: application/vnd.twitchtv.v3+json" -H "Authorization: OAuth $(<~/genesis/keys/twitch/.twitch_api_token)" -d "channel[status]=$2&channel[game]=$1" -X PUT https://api.twitch.tv/kraken/channels/narthorn }
twitch() {
	twitch_update $1 $2
	ffmpeg -f x11grab -framerate 30 -s 1920x1200 -i ":0.0+1680,0" -f pulse -i default -s 1200x800 -c:v libx264 -g 30 -keyint_min 15 -b:v 3000k -minrate 3000k -maxrate 3000k -bufsize 3000k -pix_fmt yuv420p -preset ultrafast -tune zerolatency -c:a aac -strict -2 -f flv "rtmp://live.twitch.tv/app/$(<~/genesis/keys/.twitch_key)"
}

mute_music() {
	music_playing=$(mpc | grep '^\[playing\]')
	[[ $music_playing ]] && mpc -q pause
	eval $*
	[[ $music_playing ]] && mpc -q play
}

work() { termdown -f roman $* && mute_music "(xdg-open http://matmartinez.net/nsfw/ &>/dev/null & termdown -b -f roman 0 -t 'good job')" }

fix_perms() {
	find $* -type f -exec chmod 644 {} \;
	find $* -type d -exec chmod 755 {} \;
}

rvm_init() {
	export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
}

PROMPT=$'
%{\e[1;34m%}┌─[%{\e[0;36m%}%n%{\e[0;34m%}@%{\e[0;32m%}%m%{\e[1;34m%}]───[%{\e[0;33m%}%D{%Y/%m/%d}, %*%{\e[1;34m%}]───[%{\e[1;37m%}%~%{\e[1;34m%}]%{\e[0m%} 
%{\e[1;34m%}└─[%{\e[1;35m%}$%{\e[1;34m%}]%{\e[0m%} '

typeset -g -A key

bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line

export LESS="-RFX"
