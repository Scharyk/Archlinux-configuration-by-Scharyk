#!/bin/bash

export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

# Путь к твоей папке с обоями
WALLPAPER_DIR="/home/scharyk/linux_betterwindows/Wallpapers"

# Выбираем случайную картинку из папки (поддерживает jpg, jpeg, png)
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)

# Проверяем, нашлось ли вообще что-нибудь
if [ -z "$WALLPAPER" ]; then
    echo "Ошибка: В папке $WALLPAPER_DIR нет картинок!"
    exit 1
fi

# Сканируем и ставим обои
/usr/bin/hyprctl hyprpaper preload "$WALLPAPER"
/usr/bin/hyprctl hyprpaper wallpaper ",$WALLPAPER"

# Перекрашиваем Waybar
/usr/bin/wal -i "$WALLPAPER"

# Перезапускаем стили Waybar и чистим память
/usr/bin/killall -SIGUSR2 waybar
/usr/bin/hyprctl hyprpaper unload all

echo "Кайф! Поставили случайные обои: $(basename "$WALLPAPER")"

swaync-client -rs
