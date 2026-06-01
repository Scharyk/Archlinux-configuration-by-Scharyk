#!/bin/bash

# Скрипт падает, если споткнется об ошибку
set -e

echo "=== 1. Установка системных сборщиков ==="
sudo pacman -Syu --noconfirm git base-devel wget curl jq nano

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

echo "=== 5. Скачивание репозитория и создание СВЯЗЕЙ (симлинков) ==="
# Папка, куда склонируется твой репозиторий на новой системе
REPO_DIR="$HOME/Archlinux-configuration-by-Scharyk"

# Если папки репозитория ещё нет, качаем её
if [ ! -d "$REPO_DIR" ]; then
    git clone https://github.com/Scharyk/Archlinux-configuration-by-Scharyk.git "$REPO_DIR"
fi

mkdir -p ~/.config

# Список папок для создания связей
CONFIGS=(hypr rofi waybar kitty wlogout waypaper dunst gtk-3.0)
for cfg in "${CONFIGS[@]}"; do
    if [ -d "$REPO_DIR/.config/$cfg" ]; then
        # Удаляем старую папку или старый симлинк, если они были
        rm -rf ~/.config/$cfg
        
        # Создаем символическую ссылку (живую связь)
        ln -s "$REPO_DIR/.config/$cfg" ~/.config/$cfg
        echo "Создана живая связь для конфига: $cfg"
    else
        echo "Предупреждение: Папка $cfg не найдена в репозитории!"
    fi
done

# Привязываем файл дельфина
if [ -f "$REPO_DIR/.config/dolphinrc" ]; then
    rm -f ~/.config/dolphinrc
    ln -s "$REPO_DIR/.config/dolphinrc" ~/.config/dolphinrc
    echo "Создана живая связь для Dolphin!"
fi

echo "=== 6. Включение автозапуска сети ==="
sudo systemctl enable --now NetworkManager

echo "========================================================"
echo "   ВСЕ СВЯЗИ НАСТРОЕНЫ! Перезагружайся и заходи!       "
echo "========================================================"
