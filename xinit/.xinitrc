#!/bin/sh

# Configure X
xrandr --output DVI-D-1 --primary
#xrandr --output HDMI-0 --mode 1680x1050 --rate 59.95 --right-of DVI-1
#xrandr --output DFP11  --mode 1920x1200 --primary
#xrandr --output DFP10  --mode 1680x1050 --left-of DFP11
xsetroot -cursor_name left_ptr &

# set screensaver idle to 5 min
xset s 300 &

# Backgrounds
nitrogen --restore &

# temp RK3 fix
xinput disable "RigKontrol3" &

# Set GTK env var for Qt
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Prevent stupid GTK3 programs from spawning at-spi bloat (a11y)
export NO_AT_BRIDGE=1

# Steam close to tray
export STEAM_FRAME_FORCE_CLOSE=1

# Terminal
export EDITOR=vim

# System tray
trayer --edge top --align right --widthtype pixels --width 120 --expand true --heighttype pixels --height 16 --transparent true --tint 0x000000 --alpha 0 &

# haskell is good for you
exec xmonad
