#!/bin/bash

# Формируем список вариантов для меню
OPTIONS="󰜉 Перезагрузить\n󰐥 Выключить\n󰈆 Выйти"

# Запускаем Rofi с нашей готовой текстовой темой, которую мы сделали для вайфая
CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -p "Питание" -theme "$HOME/linux_betterwindows/waybar/scripts/wifi_theme.rasi" -theme-str 'window { width: 350px; height: 250px; }')

# Если ничего не выбрано (нажат Escape) — просто выходим
if [ -z "$CHOSEN" ]; then
    exit 0
fi

# Выполняем команду в зависимости от выбора
case "$CHOSEN" in
    *"Перезагрузить"*)
        systemctl reboot
        ;;
    *"Выключить"*)
        systemctl poweroff
        ;;
    *"Выйти"*)
        # Команда полной очистки сессии Hyprland (то же самое, что делает выход по кнопкам)
        hyprctl dispatch exit
        ;;
esac
