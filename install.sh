#!/bin/bash

# Скрипт падает, если споткнется об ошибку
set -e

echo "=== 1. Установка системных сборщиков ==="
sudo pacman -Syu --noconfirm git base-devel wget curl jq nano

echo "=== 1.5 Решение возможных конфликтов аудио-серверов ==="
if pacman -Qq jack2 &>/dev/null; then
    echo "Обнаружен jack2. Безопасно удаляем для перехода на Pipewire..."
    sudo pacman -Rdd --noconfirm jack2 || true
fi

echo "=== 2. Установка официальных пакетов Арча ==="
PACKAGES=(
    hyprland hyprpaper waybar rofi kitty dunst dolphin
    networkmanager network-manager-applet bluez bluez-utils polkit-kde-agent
    pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber libpulse
    grim slurp wl-clipboard imagemagick xdg-desktop-portal-hyprland xdg-utils qt5-wayland qt6-wayland
    breeze-icons hicolor-icon-theme yad uwsm ttf-nerd-fonts-symbols woff2-font-awesome
)
sudo pacman -S --noconfirm "${PACKAGES[@]}"

echo "=== 3. Проверка и установка AUR-помощника (yay) ==="
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    cd - && rm -rf /tmp/yay-bin
fi

echo "=== 4. Установка недостающих утилит из AUR через yay ==="
yay -S --noconfirm wlogout waypaper

echo "=== 5. Скачивание репозитория и жесткое создание СВЯЗЕЙ ==="
# Папка в виртуалке теперь называется точно так же, как у тебя на основном ПК
REPO_DIR="$HOME/linux_betterwindows"

# Если папки ещё нет, качаем репозиторий
if [ ! -d "$REPO_DIR" ]; then
    git clone https://github.com/Scharyk/Archlinux-configuration-by-Scharyk.git "$REPO_DIR"
fi

mkdir -p "$HOME/.config"

# Список папок для создания связей
CONFIGS=(hypr rofi waybar kitty wlogout waypaper dunst gtk-3.0)
for cfg in "${CONFIGS[@]}"; do
    # ПРОВЕРЯЕМ И В КОРНЕ, И В ПАПКЕ .CONFIG (на всякий пожарный)
    SRC_DIR=""
    if [ -d "$REPO_DIR/$cfg" ]; then
        SRC_DIR="$REPO_DIR/$cfg"
    elif [ -d "$REPO_DIR/.config/$cfg" ]; then
        SRC_DIR="$REPO_DIR/.config/$cfg"
    fi

    # Если нашли хоть где-то — привязываем!
    if [ -n "$SRC_DIR" ]; then
        rm -rf "$HOME/.config/$cfg"
        ln -sfn "$SRC_DIR" "$HOME/.config/$cfg"
        echo "Создана ЖЕСТКАЯ живая связь для конфига: $cfg -> $SRC_DIR"
    else
        echo "Предупреждение: Конфиг $cfg не найден ни в корне, ни в .config"
    fi
done

# Привязываем файл дельфина (ищем в корне и в .config)
DOLPHIN_SRC=""
if [ -f "$REPO_DIR/dolphinrc" ]; then
    DOLPHIN_SRC="$REPO_DIR/dolphinrc"
elif [ -f "$REPO_DIR/.config/dolphinrc" ]; then
    DOLPHIN_SRC="$REPO_DIR/.config/dolphinrc"
fi

if [ -n "$DOLPHIN_SRC" ]; then
    rm -f "$HOME/.config/dolphinrc"
    ln -sfn "$DOLPHIN_SRC" "$HOME/.config/dolphinrc"
    echo "Создана живая связь для Dolphin!"
fi

echo "=== 6. Включение автозапуска сети ==="
sudo systemctl enable --now NetworkManager

echo "========================================================"
echo "   УРА! ВСЁ НАКАТИЛОСЬ И СВЯЗАЛОСЬ ИЗ КОРНЯ!            "
echo "========================================================"
