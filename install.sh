#!/bin/bash

# Скрипт всегда падает, если споткнется об ошибку
set -e

echo "=== 1. Установка системных сборщиков ==="
sudo pacman -Syu --noconfirm git base-devel wget curl jq nano

echo "=== 2. Установка официальных пакетов Арча ==="
# wlogout и waypaper заменены на аналоги или убраны из pacman, breeze-dark заменен на breeze-icons
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

echo "=== 5. Скачивание и применение твоих конфигов BetterWindows ==="
# Создаем временную папку, чтобы пути внутри скрипта не ломались
TMP_DIR="/tmp/betterwindows_setup"
rm -rf "$TMP_DIR"
git clone https://github.com/Scharyk/linux_betterwindows.git "$TMP_DIR"

mkdir -p ~/.config

# Список папок для копирования
CONFIGS=(hypr rofi waybar kitty wlogout waypaper dunst gtk-3.0)
for cfg in "${CONFIGS[@]}"; do
    if [ -d "$TMP_DIR/.config/$cfg" ]; then
        rm -rf ~/.config/破cfg
        cp -r "$TMP_DIR/.config/$cfg" ~/.config/
        echo "Папка конфига $cfg успешно применена!"
    fi
done

if [ -f "$TMP_DIR/.config/dolphinrc" ]; then
    cp "$TMP_DIR/.config/dolphinrc" ~/.config/
    echo "Конфиг Dolphin применен!"
fi

# Очистка за собой
rm -rf "$TMP_DIR"

echo "=== 6. Включение автозапуска сети ==="
sudo systemctl enable --now NetworkManager

echo "========================================================"
echo " ВСЁ НАКАТИЛОСЬ САМО! Перезагружайся и заходи в Hyprland "
echo "========================================================"
