#!/usr/bin/env bash

# obtiene las últimas 5 notificaciones de mako
notifications=$(makoctl history | grep "^Notification" | head -5 | sed 's/Notification [0-9]*: //')

if [ -z "$notifications" ]; then
    echo '{"text": "󰂚", "tooltip": "sin notificaciones", "class": "empty"}'
else
    tooltip=$(echo "$notifications" | jq -Rs '.' | sed 's/^"//;s/"$//')
    echo "{\"text\": \"󰂚\", \"tooltip\": \"$tooltip\", \"class\": \"has-notifications\"}"
fi
