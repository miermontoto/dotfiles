#!/bin/bash

# restaura los nombres de workspaces basados en directorios guardados
CONFIG_DIR="$HOME/.config/hypr/workspace-dirs"

# verificar que el directorio existe
[ ! -d "$CONFIG_DIR" ] && exit 0

# esperar a que hyprland esté listo
sleep 1

# iterar sobre cada archivo de configuración
for file in "$CONFIG_DIR"/*; do
    [ -f "$file" ] || continue

    workspace_id=$(basename "$file")
    saved_dir=$(cat "$file")

    # verificar que el directorio sigue existiendo
    if [ -d "$saved_dir" ]; then
        dir_name=$(basename "$saved_dir")
        hyprctl dispatch renameworkspace "$workspace_id" "$workspace_id: $dir_name"
    fi
done
