kk#!/bin/bash

while true; do
    # 1. Получаем текущую громкость и статус мута через wpctl
    VOLUME_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

    # Проверяем на мут
    if [[ "$VOLUME_INFO" == *"[MUTED]"* ]]; then
        BAR="[ 󰝟 ЗВУК ВЫКЛЮЧЕН ]"
    else
        # Выдергиваем чистые проценты (например, 0.60 -> 60)
        VOL_NUM=$(echo "$VOLUME_INFO" | awk '{print $2}' | tr -d '.')
        # Если громкость 100% (1.00), то awk вернет 100
        if [ "$VOL_NUM" -eq 1 ]; then VOL_NUM=100; fi
        # Если громкость однозначная (например, 5%), убираем лишние нули
        VOL_NUM=$((10#$VOL_NUM))
        if [ "$VOL_NUM" -gt 100 ]; then VOL_NUM=100; fi # Ограничим полосу до 100%

        # Рисуем полосу из 10 кубиков
        SHARKS=$(( VOL_NUM / 10 ))
        SPACES=$(( 10 - SHARKS ))

        BAR="["
        for ((i=0; i<SHARKS; i++)); do BAR="${BAR}█"; done
        for ((i=0; i<SPACES; i++)); do BAR="${BAR}░"; done
        BAR="${BAR}] ${VOL_NUM}%"
    fi

    # 2. Формируем меню для Rofi
    MENU_OPTIONS="󰝝 Увеличить громкость (+5%)\n󰝞 Уменьшить громкость (-5%)\n󰝟 Включить / Выключить звук (Mute)"

    # 3. Запускаем Rofi с нашей текстовой темой, чтобы не ломать обои.
    # Добавили window { width: 500px; }, чтобы полоса громкости красиво влезала по ширине
    CHOSEN=$(echo -e "$MENU_OPTIONS" | rofi -dmenu -p "$BAR" -theme "$HOME/linux_betterwindows/waybar/scripts/wifi_theme.rasi" -theme-str 'window { width: 500px; }')

    # 4. Обрабатываем выбор. Если нажат Escape (пустой вывод) — выходим из цикла
    if [ -z "$CHOSEN" ]; then
        break
    fi

    case "$CHOSEN" in
        *"Увеличить"*)
            wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
            ;;
        *"Уменьшить"*)
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            ;;
        *"Mute"*)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            ;;
    esac
done
