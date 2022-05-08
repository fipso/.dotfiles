#!/bin/bash
today=`date '+%Y_%m_%d__%H_%M_%S'`;
slop=$(slop -f "%x %y %w %h %g %i") || exit 1
read -r X Y W H G ID < <(echo $slop)
ffmpeg -f x11grab -framerate 30 -s "$W"x"$H" -i :0.0+$X,$Y -f pulse -i bluez_output.38_18_4C_6D_71_FB.a2dp-sink.monitor ~/records/$today.webm
