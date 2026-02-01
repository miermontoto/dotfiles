#!/bin/bash

# directorio donde se guardan las asociaciones
CONFIG_DIR="$HOME/.config/hypr/workspace-dirs"
mkdir -p "$CONFIG_DIR"

# función para limpiar workspaces cerrados
cleanup_closed_workspaces() {
    # obtener lista de workspaces activos
    active_workspaces=$(hyprctl workspaces -j | jq -r '.[].id' | sort -n)

    # obtener lista de asociaciones guardadas
    for file in "$CONFIG_DIR"/*; do
        if [ -f "$file" ]; then
            workspace_id=$(basename "$file")

            # verificar si el workspace todavía existe
            if ! echo "$active_workspaces" | grep -q "^${workspace_id}$"; then
                # remover asociación si el workspace no existe
                rm "$file"
            fi
        fi
    done
}

# escuchar eventos de hyprland
socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    event=$(echo "$line" | cut -d'>' -f1)

    # limpiar cuando se destruye un workspace
    if [ "$event" = "destroyworkspace" ] || [ "$event" = "destroyworkspacev2" ]; then
        workspace_id=$(echo "$line" | cut -d'>' -f2 | cut -d',' -f1)
        if [ -f "$CONFIG_DIR/$workspace_id" ]; then
            rm "$CONFIG_DIR/$workspace_id"
        fi
    fi

    # limpiar periódicamente workspaces huérfanos (cada vez que se cambia de workspace)
    if [ "$event" = "workspace" ]; then
        cleanup_closed_workspaces
    fi
done
