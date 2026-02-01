#!/bin/bash

# directorio donde se guardan las asociaciones
CONFIG_DIR="$HOME/.config/hypr/workspace-dirs"

# obtener el workspace actual
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# buscar si hay un directorio asociado a este workspace
workspace_dir=""
if [ -f "$CONFIG_DIR/$current_workspace" ]; then
    workspace_dir=$(cat "$CONFIG_DIR/$current_workspace")
fi

# si no hay directorio asociado, usar HOME
if [ -z "$workspace_dir" ] || [ ! -d "$workspace_dir" ]; then
    workspace_dir="$HOME"
fi

# lanzar alacritty en el directorio correspondiente
alacritty --working-directory "$workspace_dir"
