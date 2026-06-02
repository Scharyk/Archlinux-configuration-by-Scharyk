#!/bin/bash

# Путь к твоим обоям
WALLPAPER_DIR="$HOME/linux_betterwindows/Wallpapers"

# Выбор файла через rofi
selected=$(ls "$WALLPAPER_DIR" | rofi -dmenu -p "Выберите обои:")

# Если выбрал файл — применяем
if [ -n "$selected" ]; then
    swww img "$WALLPAPER_DIR/$selected" --transition-type grow --transition-duration 1
fi
