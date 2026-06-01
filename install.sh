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
    # Графическая среда и блокировка/выход
    hyprland hyprpaper waybar dunst rofi wofi wlogout waypaper sddm uwsm xdg-desktop-portal-hyprland
    
    # Терминал и консольные украшательства (для красоты)
    kitty fastfetch cmatrix cava tty-clock htop jq imagemagick python-pywal python-pillow
    
    # Системный минимум (утилиты, буфер, скриншоты)
    git nano vim wget wl-clipboard grim slurp yad network-manager-applet openbsd-netcat zram-generator
    
    # Звук и Bluetooth (чтобы всё работало из коробки)
    pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber libpulse bluez bluez-utils
    
    # Обязательные шрифты (иначе иконки в Waybar сломаются!)
    ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common woff2-font-awesome
)

# Установка только необходимых пакетов
yay -S --needed "${PACKAGES[@]}"
sudo pacman -S --noconfirm "${PACKAGES[@]}"

echo "=== 3. Проверка и установка AUR-помощника (yay) ==="
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    cd - && rm -rf /tmp/yay-bin
fi

echo "=== 4. Установка недостающих утилит из AUR через yay ==="
yay -S --noconfirm wlogout waypaper

echo "=== 5. Скачивание репозитория и нормальное КОПИРОВАНИЕ конфигов ==="
REPO_DIR="$HOME/linux_betterwindows"

# Если папки репозитория нет, качаем
if [ ! -d "$REPO_DIR" ]; then
    git clone https://github.com/Scharyk/Archlinux-configuration-by-Scharyk.git "$REPO_DIR"
fi

# Жестко создаем чистую .config если её не было
mkdir -p "$HOME/.config"

# Список папок для копирования
CONFIGS=(hypr rofi waybar kitty wlogout waypaper dunst gtk-3.0)
for cfg in "${CONFIGS[@]}"; do
    SRC_DIR=""
    # Ищем, где лежит папка в репозитории
    if [ -d "$REPO_DIR/$cfg" ]; then
        SRC_DIR="$REPO_DIR/$cfg"
    elif [ -d "$REPO_DIR/.config/$cfg" ]; then
        SRC_DIR="$REPO_DIR/.config/$cfg"
    fi

    # Если нашли — выжигаем дефолт с флагом -rf (чтобы не было ошибок 'Directory not empty')
    if [ -n "$SRC_DIR" ]; then
        # Удаляем и файл, и папку, и возможные старые симлинки
        rm -rf "$HOME/.config/$cfg" 2>/dev/null || true
        sudo rm -rf "$HOME/.config/$cfg" 2>/dev/null || true
        
        # Теперь чистое копирование папки целиком
        cp -r "$SRC_DIR" "$HOME/.config/"
        echo "Конфиг [$cfg] успешно СКОПИРОВАН в ~/.config/"
    fi
done

# Копируем файл дельфина
DOLPHIN_SRC=""
if [ -f "$REPO_DIR/dolphinrc" ]; then
    DOLPHIN_SRC="$REPO_DIR/dolphinrc"
elif [ -f "$REPO_DIR/.config/dolphinrc" ]; then
    DOLPHIN_SRC="$REPO_DIR/.config/dolphinrc"
fi

if [ -n "$DOLPHIN_SRC" ]; then
    rm -rf "$HOME/.config/dolphinrc" 2>/dev/null || true
    cp "$DOLPHIN_SRC" "$HOME/.config/"
    echo "Конфиг Dolphin успешно скопирован!"
fi

echo "=== 6. Включение автозапуска сети ==="
sudo systemctl enable --now NetworkManager

# =========================================================
# Настройка экрана логина в стиле CachyOS (SDDM)
# =========================================================
echo "=== Настройка SDDM ==="

# 1. Устанавливаем нужные зависимости
sudo pacman -S --noconfirm sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg imagemagick

# 2. Создаем папку и качаем базовую тему Astronaut
sudo mkdir -p /usr/share/sddm/themes
if [ ! -d "/usr/share/sddm/themes/sddm-betterwindows" ]; then
    echo "Скачиваем базовую тему Astronaut..."
    sudo git clone https://github.com/Keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-betterwindows
fi

# 3. Настраиваем черно-красный народный стиль через конфиг
cat <<EOF | sudo tee /usr/share/sddm/themes/sddm-betterwindows/theme.conf.user > /dev/null
[General]
FormPosition="center"
TextColor="#ff0000"
AccentColor="#ff0000"
MainColor="#111111"
ButtonColor="#ff0000"
HoverColor="#aa0000"
FieldColor="#222222"
FontSize="14"
EOF

# 4. Прописываем тему как дефолтную в системе
sudo mkdir -p /etc/sddm.conf.d
cat <<EOF | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null
[Theme]
Current=sddm-betterwindows
EOF

# 5. Включаем автозапуск SDDM при старте системы
sudo systemctl enable sddm.service --force

echo "========================================================"
echo "   УСТАНОВКА ЗАВЕРШЕНА! ВСЕ КОНФИГИ ПРИВЯЗАНЫ НАМЕРТВО! "
echo "========================================================"
