#!/bin/bash

action=$(echo -e "Disconnect Headphones\nConnect Headphones\nRestart Bluetooth" | rofi -dmenu -p ">")

if [ "$action" = "Disconnect Headphones" ]; then
	bluetoothctl disconnect
elif [ "$action" = "Connect Headphones" ]; then
	bluetoothctl connect 38:18:4C:6D:71:FB
elif [ "$action" = "Restart Bluetooth" ]; then
	kitty bash -c "sudo systemctl restart bluetooth && exit"
fi
