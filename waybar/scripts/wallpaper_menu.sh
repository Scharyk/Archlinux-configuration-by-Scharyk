k#!/bin/bash

WALL_DIR="$HOME/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper_thumbs"

mkdir -p "$WALL_DIR"
mkdir -p "$CACHE_DIR"

cd "$WALL_DIR" 2>/dev/null || exit 1
options=$(ls *.jpg *.jpeg *.png 2>/dev/null)

if [ -z "$options" ]; then
    echo "Папка ~/Wallpapers пуста!"
    exit 1
fi

# Генерируем ЧЁТКИЕ ГОРИЗОНТАЛЬНЫЕ превьюшки 16:9 (размер 500x281)
for img in $options; do
    if [ ! -f "$CACHE_DIR/$img" ]; then
        convert "$img" -thumbnail 500x281^ -gravity center -extent 500x281 "$CACHE_DIR/$img" >/dev/null 2>&1
    fi
done

rofi_list=""
for img in $options; do
    rofi_list+="$img\x00icon\x1f$CACHE_DIR/$img\n"
done

# Вызываем Rofi через твою старую тему
chosen=$(echo -e "$rofi_list" | rofi -dmenu -p "Обои" -show-icons -theme "$HOME/linux_betterwindows/waybar/scripts/theme.rasi")

if [ -z "$chosen" ]; then
    exit 0
fi

# Установка обоев через hyprpaper
hyprctl hyprpaper preload "$WALL_DIR/$chosen" 2>/dev/null
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
hyprctl hyprpaper wallpaper "$MONITOR,$WALL_DIR/$chosen" 2>/dev/null

echo "preload = $WALL_DIR/$chosen" > ~/.config/hypr/hyprpaper.conf
echo "wallpaper = $MONITOR,$WALL_DIR/$chosen" >> ~/.config/hypr/hyprpaper.conf
