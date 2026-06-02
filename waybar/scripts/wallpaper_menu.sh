KK#!/bin/bash

WALLPAPER_DIR="$HOME/linux_betterwindows/Wallpapers"
THEME_DIR="$HOME/.config/rofi/dark-half.rasi"

if [ ! -f "$THEME_DIR" ]; then
    THEME_DIR="$HOME/linux_betterwindows/dark-half.rasi"
fi

# Собираем файлы (передаем путь как скрытое значение, а иконку как картинку)
ROFI_INPUT=""
while read -r img; do
    ROFI_INPUT+="$img\0icon\x1f$img\n"
done < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \))

# Просто вызываем тему, она теперь сама всё знает
SELECTED_IMG=$(echo -e "$ROFI_INPUT" | rofi -dmenu -theme "$THEME_DIR" -p "Выбери обои:")

if [ -z "$SELECTED_IMG" ]; then
    exit 0
fi

SELECTED_IMG=$(echo "$SELECTED_IMG" | xargs)

if [ -f "$HOME/apply_wallpaper.sh" ]; then
    bash "$HOME/apply_wallpaper.sh" "$SELECTED_IMG"
else
    bash "$HOME/linux_betterwindows/apply_wallpaper.sh" "$SELECTED_IMG"
fi
