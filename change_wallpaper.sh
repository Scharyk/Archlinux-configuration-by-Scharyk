#!/bin/bash

# Папка с твоими обоями, которую скопирует установщик
WALLPAPER_DIR="$HOME/Wallpapers"

# Выбираем случайную картинку
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

if [ -z "$RANDOM_WALLPAPER" ]; then
    echo "Ошибка: Папка $WALLPAPER_DIR пуста или не существует!"
    exit 1
fi

echo "Ставим обои: $RANDOM_WALLPAPER"

# 1. Скармливаем картинку Pywal для генерации цветов
wal -i "$RANDOM_WALLPAPER"

# 2. Обновляем hyprpaper
pkill hyprpaper || true
echo "preload = $RANDOM_WALLPAPER" > ~/.config/hypr/hyprpaper.conf
echo "wallpaper = ,$RANDOM_WALLPAPER" >> ~/.config/hypr/hyprpaper.conf
hyprpaper &

# 3. Перезапускаем Waybar, чтобы подтянуть новые цвета
pkill waybar || true
waybar &
