#!/bin/bash

# 1. Системные утилиты
echo "=== Установка системных утилит ==="
sudo pacman -Syu --noconfirm git base-devel wget curl jq nano

# 2. Только графика и окружение (БЕЗ ТЯЖЕЛОГО СОФТА НА 40 ГБ)
PACKAGES=(
    hyprland hyprpaper waybar rofi wlogout waypaper kitty dunst dolphin
    networkmanager network-manager-applet bluez bluez-utils polkit-kde-agent
    pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber libpulse
    grim slurp wl-clipboard imagemagick xdg-desktop-portal-hyprland xdg-utils qt5-wayland qt6-wayland
    breeze breeze-dark hicolor-icon-theme yad uwsm ttf-nerd-fonts-symbols woff2-font-awesome
)

echo "=== Установка легкого окружения Hyprland ==="
sudo pacman -S --noconfirm "${PACKAGES[@]}"

# 3. Ставим YAY, если его нет
if ! command -v yay &> /dev/null; then
    echo "=== Установка AUR-помощника (yay) ==="
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    cd - && rm -rf /tmp/yay-bin
fi

# 4. Накатываем твои конфиги из папки репозитория
echo "=== Применение конфигурационных файлов ==="
mkdir -p ~/.config

CONFIGS=(hypr rofi waybar kitty wlogout waypaper dunst gtk-3.0)
for cfg in "${CONFIGS[@]}"; do
    if [ -d "./.config/$cfg" ]; then
        rm -rf ~/.config/$cfg
        cp -r ./.config/$cfg ~/.config/
    fi
done

if [ -f "./.config/dolphinrc" ]; then
    cp ./.config/dolphinrc ~/.config/
fi

# Включаем сеть
sudo systemctl enable --now NetworkManager

echo "=== Всё готово! Без лишнего веса ==="
