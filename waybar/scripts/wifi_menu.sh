#!/bin/bash

options=$(nmcli -t -f SSID dev wifi | sort -u | grep -v '^$')
options="󰤭 Отключить Wi-Fi\n$options"

# Берём ИМЕННО wifi_theme.rasi
chosen=$(echo -e "$options" | rofi -dmenu -p "Wi-Fi Сети" -theme "$HOME/linux_betterwindows/waybar/scripts/wifi_theme.rasi" -theme-str 'window { width: 400px; }')

if [ -z "$chosen" ]; then
    exit 0
fi

if [[ "$chosen" == *"Отключить Wi-Fi"* ]]; then
    nmcli dev disconnect wlan0
else
    # И тут тоже wifi_theme.rasi
    password=$(rofi -dmenu -p "Пароль для $chosen" -password -theme "$HOME/linux_betterwindows/waybar/scripts/wifi_theme.rasi" -theme-str 'window { width: 400px; } listview { lines: 0; }')
    if [ -n "$password" ]; then
        nmcli dev wifi connect "$chosen" password "$password"
    fi
fi
