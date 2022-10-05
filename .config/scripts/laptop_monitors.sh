#!/bin/bash
xrandr --output eDP-1-1 --mode 1920x1080 --rate 144 --left-of HDMI-0
xrandr --output DP-0 --mode 1920x1080 --rate 144 --left-of eDP-1-1
xrandr --output HDMI-0 --mode 1920x1080 --rate 60 --right-of eDP-1-1
