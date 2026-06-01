#!/usr/bin/env bash

# obtiene el conteo y estado de dnd desde swaync
count=$(swaync-client --count 2>/dev/null)
count=${count:-0}
dnd=$(swaync-client --get-dnd 2>/dev/null)

if [ "$dnd" = "true" ]; then
    icon="󰂛"
    cls="dnd"
    tooltip="no molestar activado"
elif [ "$count" -eq 0 ]; then
    icon="󰂚"
    cls="empty"
    tooltip="sin notificaciones"
else
    icon="󱅫"
    cls="has-notifications"
    tooltip="$count notificaciones pendientes"
fi

echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$cls\"}"
