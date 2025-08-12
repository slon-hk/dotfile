#!/bin/zsh

# Цвета из темы
CYAN=0xffa2d9f7     # VPN (осветлённый)
BLUE=0xff8aadf4     # Wi-Fi
WHITE=0xffcad3f5    # Нет сети

# Фоны
VPN_BG=0x667dc4e4   # Полупрозрачный голубой (как в теме)
DEFAULT_BG=0xe01d2021

# Определяем имя элемента
NAME="${NAME:-$1}"
NAME="${NAME:-ip_address}"

# Получаем IP и проверяем VPN
IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')

if [[ -n $IS_VPN ]]; then
    COLOR=$CYAN
    ICON=
    LABEL="VPN"
    BG_COLOR=$VPN_BG
elif [[ -n $IP_ADDRESS ]]; then
    COLOR=$BLUE
    ICON=
    LABEL="$IP_ADDRESS"
    BG_COLOR=$DEFAULT_BG
else
    COLOR=$WHITE
    ICON=
    LABEL="Not Connected"
    BG_COLOR=$DEFAULT_BG
fi

sketchybar --set "$NAME" \
    background.color=$BG_COLOR \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="$LABEL" \
    label.color="$COLOR"
