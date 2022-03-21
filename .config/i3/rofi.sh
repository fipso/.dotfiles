#!/bin/bash

#SCREEN_POS=$(swaymsg -t get_outputs \
#	| jq -r \
#	'.[] | select(.focused).rect | "\(.width)x\(.height)\\+\(.x)\\+\(.y)"')

# ripgrep
#XWAYLAND_OUTPUT=$(xrandr | rg -oP "[A-Z]+[0-9]+(?= [a-z]+ $SCREEN_POS)")

#MONITOR_ID=$(rofi --help | rg $XWAYLAND_OUTPUT -B1 \
#	| sed -sr '/ID/!d;s/[^:]*:\s([0-9])/\1/')

# GNU grep
#XWAYLAND_OUTPUT=$(xrandr | grep -oP "[A-Z]+[0-9]+(?= connected $SCREEN_POS)

#MONITOR_ID=$(rofi --help | grep $XWAYLAND_OUTPUT -B1 \
#	| sed -sr '/ID/!d;s/[^:]*:\s([0-9])/\1/')


rofi -combi-modi window,drun,ssh -font "Hack 16" -show combi -theme glue_pro_blue -icon-theme "Papirus" -show-icons
