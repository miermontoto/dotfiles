#!/usr/bin/env bash

# usar el modo window de rofi que maneja mejor alt+tab
rofi -show window \
    -show-icons \
    -kb-accept-alt "Alt+Alt_L,Alt+Alt_R" \
    -kb-element-next "Tab" \
    -kb-element-prev "ISO_Left_Tab" \
    -theme-str 'window {location: center;}'