#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="$BASE_DIR/Wallpapers"
STYLE="$BASE_DIR/scripts/wallstyle.rasi"

if [ ! -d "$DIR" ]; then
    notify-send "Ошибка" "Папка с обоями не найдена"
    exit 1
fi

# Генерируем список для Rofi с иконками
MENU_ITEMS=""
while IFS= read -r file; do
    if [[ "$file" =~ \.(jpg|jpeg|png|webp)$ ]]; then
        # Формат для Rofi: отображаемое_имя\0icon\x1fпуть_к_картинке
        MENU_ITEMS+="${file}\0icon\x1f${DIR}/${file}\n"
    fi
done < <(ls "$DIR")

# Вызываем Rofi с нашей кастомной прозрачной темой
SELECTED=$(echo -e "$MENU_ITEMS" | rofi -dmenu -theme "$STYLE" -p "Обои:")

if [ -n "$SELECTED" ]; then
    FILE="$DIR/$SELECTED"
    
    # Применяем обои
    hyprctl hyprpaper preload "$FILE"
    hyprctl hyprpaper wallpaper "eDP-1,$FILE"
    
    # Генерируем новые цвета системы
    wal -i "$FILE"
    
    # Даем pywal время записать цвета
    sleep 0.3
    
    # Жестко убиваем старый вейбар
    pkill -9 waybar
    sleep 0.2
    
    # Запускаем заново с принудительным указанием конфигов, чтобы сбросить кэш
    waybar &
fi
