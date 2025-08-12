#!/bin/zsh

# Цвета из темы
GREEN=0xffa6da95    # Download
YELLOW=0xfff5a97f   # Upload

# Определяем имена элементов
DOWN_NAME="${NAME_DOWN:-network.down}"
UP_NAME="${NAME_UP:-network.up}"

# Получаем байты за секунду
getBytes() {
    netstat -w1 > ~/.config/sketchybar/plugins-laptop/network.out & sleep 1; kill $!
}

getBytes > /dev/null
BYTES=$(grep '[0-9].*' ~/.config/sketchybar/plugins-laptop/network.out)

DOWN=$(echo $BYTES | awk '{print $3}')
UP=$(echo $BYTES | awk '{print $6}')

# Перевод в удобный формат
human_readable() {
    local abbrevs=(
        $((1 << 60)):ZiB
        $((1 << 50)):EiB
        $((1 << 40)):TiB
        $((1 << 30)):GiB
        $((1 << 20)):MiB
        $((1 << 10)):KiB
        $((1)):B
    )

    local bytes="$1"
    local precision="$2"

    for item in "${abbrevs[@]}"; do
        local factor="${item%:*}"
        local abbrev="${item#*:}"
        if [[ "$bytes" -ge "$factor" ]]; then
            local size="$(bc -l <<< "$bytes / $factor")"
            printf "%.*f %s\n" "$precision" "$size" "$abbrev"
            break
        fi
    done
}

DOWN_FORMAT=$(human_readable "$DOWN" 1)
UP_FORMAT=$(human_readable "$UP" 1)

sketchybar --set "$DOWN_NAME" label="$DOWN_FORMAT/s" label.color="$GREEN" icon.color="$GREEN" \
           --set "$UP_NAME"   label="$UP_FORMAT/s"   label.color="$YELLOW" icon.color="$YELLOW"
