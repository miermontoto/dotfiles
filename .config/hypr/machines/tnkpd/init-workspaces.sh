#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sleep 1

# detectar ubicacion por monitores conectados
MONITORS=$(hyprctl -j monitors)
is_connected() {
    echo "$MONITORS" | jq -e --arg pat "$1" '[.[].description] | any(test($pat))' > /dev/null 2>&1
}

if is_connected "LG ULTRAGEAR"; then
    LOCATION="casa"
elif is_connected "Q27q-20"; then
    LOCATION="ofi"
else
    LOCATION=""
fi

# aplicar reglas de workspace y window rules de la ubicacion
if [ -n "$LOCATION" ] && [ -f "$SCRIPT_DIR/locations/$LOCATION.conf" ]; then
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        key="${line%%[= ]*}"
        value="$(echo "$line" | sed 's/^[^=]*=[[:space:]]*//')"
        hyprctl keyword "$key" "$value" 2>/dev/null || true
    done < "$SCRIPT_DIR/locations/$LOCATION.conf"
fi

# mover workspace 1 al monitor principal y lanzar apps iniciales
case "$LOCATION" in
    casa)
        hyprctl dispatch moveworkspacetomonitor 1 "desc:LG Electronics LG ULTRAGEAR+ 206NTLE8L184"
        hyprctl dispatch exec "[workspace 1 silent]" zen-browser
        hyprctl dispatch exec "[workspace 3 silent]" "flatpak run com.spotify.Client"
        ;;
    ofi)
        hyprctl dispatch moveworkspacetomonitor 1 "desc:Lenovo Group Limited Q27q-20 UPP019DM"
        hyprctl dispatch exec "[workspace 2 silent]" zen-browser
        hyprctl dispatch exec "[workspace 8 silent]" "flatpak run com.spotify.Client"
        hyprctl dispatch exec "[workspace 9 silent]" "flatpak run md.obsidian.Obsidian"
        ;;
esac

hyprctl dispatch workspace 1
