#!/bin/bash

   # Путь к картинке передается как аргумент (например: ./change_wallpaper.sh ~/Pictures/wall.png)
   WALLPAPER=$1

   if [ -z "$WALLPAPER" ]; then
       echo "Использование: ./change_wallpaper.sh /путь/к/обоям.jpg"
       exit 1
   fi

   # 1. Меняем обои (подставь swww или hyprpaper, смотря что у тебя работает)
   swww img "$WALLPAPER" --transition-type random || hyprpaper &

   # 2. Pywal вытаскивает палитру цветов
   wal -i "$WALLPAPER" -q -t

   # 3. Перезапускаем Waybar, чтобы применились новые цвета из @import
   killall waybar
   waybar &
