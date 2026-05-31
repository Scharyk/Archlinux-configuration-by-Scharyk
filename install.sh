#!/bin/bash

# Цвета для красоты
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Ссылка на твой репозиторий
REPO_URL="https://github.com/Scharyk/Archlinux-configuration-by-Scharyk.git"
TMP_DIR="/tmp/betterwindows_install"

echo -e "${BLUE}=======================================${NC}"
echo -e "${GREEN}   Запуск сетевого установщика...     ${NC}"
echo -e "${BLUE}=======================================${NC}"

# 1. Проверяем наличие git и curl
echo -e "${BLUE}[1/5] Проверка базовых утилит...${NC}"
for tool in git curl; do
    if ! command -v $tool &> /dev/null; then
        echo -e "   [+] Установка $tool..."
        sudo pacman -S --noconfirm $tool
    fi
done

# 2. Клонируем конфиги во временную папку
echo -e "${BLUE}[2/5] Скачивание конфигов с GitHub...${NC}"
rm -rf "$TMP_DIR"
git clone "$REPO_URL" "$TMP_DIR"

if [ ! -d "$TMP_DIR" ]; then
    echo -e "${RED}[КРИТИЧЕСКАЯ ОШИБКА] Не удалось скачать файлы с GitHub!${NC}"
    exit 1
fi

# 3. Установка всех нужных программ
PACKAGES=(hyprland waybar kitty dolphin rofi grim slurp wl-clipboard pipewire wireplumber)
echo -e "${BLUE}[3/5] Установка системных пакетов...${NC}"
for pkg in "${PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &> /dev/null; then
        echo "   [✓] $pkg уже установлен"
    else
        echo "   [+] Установка $pkg..."
        sudo pacman -S --noconfirm "$pkg"
    fi
done

# 4. Раскидываем конфиги по местам
echo -e "${BLUE}[4/5] Установка конфигурационных файлов...${NC}"
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar

cp -r "$TMP_DIR/hypr/"* ~/.config/hypr/
cp -r "$TMP_DIR/waybar/"* ~/.config/waybar/

# Накатываем права на скрипты
chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null

# Очищаем за собой временную папку
rm -rf "$TMP_DIR"

# 5. Запуск
echo -e "${BLUE}[5/5] Запуск интерфейса...${NC}"
killall waybar &> /dev/null
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &> /dev/null &

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}  BetterWindows успешно установлен!   ${NC}"
echo -e "${GREEN}=======================================${NC}"
