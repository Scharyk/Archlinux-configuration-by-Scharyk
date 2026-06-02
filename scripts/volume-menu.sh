#!/bin/bash

# Получаем текущую громкость
CURRENT_VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | cut -d. -f1)
if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
    CURRENT_VOL="Muted"
fi

# Подтягиваем цвета Pywal для рамки и выделения
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    source "$HOME/.cache/wal/colors.sh"
else
    color2="#00ff00"
fi

# Генерируем кастомный оверлей стилей, чтобы текст горел белым
# Вытаскиваем основной темный цвет фона из pywal для rofi
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    bg_color=$(grep "color0=" "$HOME/.cache/wal/colors.sh" | cut -d"'" -f2)
else
    bg_color="#1a1a1a"
fi

# Жестко прописываем прозрачность фона (добавляем 'cc' к hex цвету) и белый текст
ROFI_STYLE="window { background-color: ${bg_color}cc; border: 2px; border-color: ${color2}; border-radius: 12px; } * { text-color: #ffffff; } element selected { background-color: ${color2}; text-color: #000000; }"
# Функция для отрисовки меню шкалы
show_menu() {
    echo "  Текущая громкость: $CURRENT_VOL%"
    echo "────────────────────────────"
    echo "  [+++++++++++++++]  100%"
    echo "  [+++++++++++++-]   90%"
    echo "  [++++++++++++-]   80%"
    echo "  [+++++++++++-]   70%"
    echo "  [++++++++++-]   60%"
    echo "  [+++++++++-]   50%"
    echo "  [++++++++-]   40%"
    echo "  [+++++++-]   30%"
    echo "  [++++++-]   20%"
    echo "  [++++-]   10%"
    echo "  [---]   0%"
    echo "────────────────────────────"
    echo "  󰝟 Включить / Выключить звук (Mute)"
}

# Запускаем Rofi с форсированием белого текста
CHOICE=$(show_menu | rofi -dmenu -p "Громкость" -i -theme ~/.cache/wal/colors-rofi-dark.rasi -theme-str "$ROFI_STYLE")

# Проверяем, что выбрал пользователь
case "$CHOICE" in
    *100%) wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *90%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.9 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *80%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.8 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *70%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.7 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *60%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.6 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *50%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *40%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.4 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *30%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.3 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *20%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.2 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *10%)  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1 && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    *0%)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.0 ;;
    *Mute*) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac
