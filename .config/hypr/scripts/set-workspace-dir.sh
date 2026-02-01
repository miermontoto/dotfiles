#!/bin/bash

# directorio para almacenar asociaciones workspace-directory
CONFIG_DIR="$HOME/.config/hypr/workspace-dirs"
mkdir -p "$CONFIG_DIR"

# obtener el workspace actual
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# preguntar al usuario por el directorio (con el cwd actual como default)
current_dir=$(hyprctl activewindow -j 2>/dev/null | jq -r '.pid' | xargs -I {} readlink -f /proc/{}/cwd 2>/dev/null || echo "$HOME")
selected_dir=$(echo "$current_dir" | rofi -dmenu -p "Set directory for workspace $current_workspace:")

# validar que se ingresó un directorio
if [ -z "$selected_dir" ]; then
    exit 0
fi

# expandir ~ si se usa
selected_dir="${selected_dir/#\~/$HOME}"

# validar que el directorio existe
if [ ! -d "$selected_dir" ]; then
    notify-send "Error" "Directory does not exist: $selected_dir"
    exit 1
fi

# guardar la asociación
echo "$selected_dir" > "$CONFIG_DIR/$current_workspace"

# renombrar el workspace con el nombre del directorio
dir_name=$(basename "$selected_dir")
hyprctl dispatch renameworkspace "$current_workspace" "$current_workspace: $dir_name"

notify-send "Workspace Directory" "Workspace $current_workspace → $selected_dir"
