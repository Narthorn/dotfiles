#!/bin/sh

# Configure X
xrandr --output DP-1 --left-of DP-2
xrandr --output DP-2 --primary
xrandr --output DP-3 --right-of DP-2

xsetroot -cursor_name left_ptr &

# set screensaver idle to 5 min
xset s 300 &

# Backgrounds
nitrogen --restore &

# Set GTK env var for Qt
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Prevent stupid GTK3 programs from spawning at-spi bloat (a11y)
export NO_AT_BRIDGE=1

# Steam close to tray
export STEAM_FRAME_FORCE_CLOSE=1

# Terminal
export EDITOR=vim

export WINEDLLOVERRIDES=winemenubuilder.exe=d

# Japanese input
export GTK_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE=fcitx
fcitx &

# System tray
trayer --edge top --align right --widthtype pixels --width 120 --expand true --heighttype pixels --height 16 --transparent true --tint 0x000000 --alpha 0 --monitor primary &

# Mails
thunderbird &

# Weird soundblaster XFi config to avoid crosstalk
amixer -c 0 sset Master Capture 256 &
amixer -c 0 sset Mic Playback 0 &
amixer -c 0 sset PCM Capture 0 &

# Piano foot pedals mappings
~/dev/mid2key/mid2key /dev/midi* ~/dev/mid2key/test &

# haskell is good for you
exec xmonad
