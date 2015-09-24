# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh/

DISABLE_AUTO_UPDATE="true"
#COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-syntax-highlighting archlinux colored-man)

alias sc='xrandr --output DVI-1 --auto --output DVI-0 --left-of DVI-1 --auto'
alias suspend_dpms='xset -dpms; xset s off; (sleep 2h; xset s on; xset +dpms) &'
alias wsteam='wine "C:\\Steam\\Steam.exe" -no-dwrite &!'

source $ZSH/oh-my-zsh.sh

PROMPT=$'
%{\e[1;34m%}┌─[%{\e[0;36m%}%n%{\e[0;34m%}@%{\e[0;32m%}%m%{\e[1;34m%}]───[%{\e[0;33m%}%D{%Y/%m/%d}, %*%{\e[1;34m%}]───[%{\e[1;37m%}%~%{\e[1;34m%}]%{\e[0m%} 
%{\e[1;34m%}└─[%{\e[1;35m%}$%{\e[1;34m%}]%{\e[0m%} '

typeset -g -A key

bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line

#PS1="\n\[\e[34m\]# [\[\e[35m\]\t\[\e[34m\]] \[\e[36m\]\u\[\e[34m\]@\[\e[32m\]\h:\[\e[33m\]\w\[\e[34m\]\$\[\e[m\] "
