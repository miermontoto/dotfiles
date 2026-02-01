#!/bin/bash

# preguntar al usuario por el directorio del repositorio
repo_dir=$(echo "$HOME" | rofi -dmenu -p "Repository directory:")

# validar que se ingresó un directorio
if [ -z "$repo_dir" ]; then
    exit 0
fi

# expandir ~ si se usa
repo_dir="${repo_dir/#\~/$HOME}"

# validar que el directorio existe
if [ ! -d "$repo_dir" ]; then
    notify-send "Error" "Directory does not exist: $repo_dir"
    exit 1
fi

# obtener el nombre del directorio para el workspace
repo_name=$(basename "$repo_dir")

# crear nuevo workspace vacío
hyprctl dispatch workspace empty

# obtener el id del workspace recién creado
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# guardar la asociación de directorio usando la misma lógica que set-workspace-dir.sh
CONFIG_DIR="$HOME/.config/hypr/workspace-dirs"
mkdir -p "$CONFIG_DIR"
echo "$repo_dir" > "$CONFIG_DIR/$current_workspace"

# renombrar el workspace con el nombre del repo
hyprctl dispatch renameworkspace "$current_workspace" "$current_workspace: $repo_name"

# esperar un poco para asegurar que el workspace está listo
sleep 0.2

# abrir cursor primero y esperar a que cargue completamente
cursor_cmd="/home/mier/AppImages/cursor.appimage"
if [ -f "$cursor_cmd" ]; then
    (cd "$repo_dir" && $cursor_cmd . &)

    # esperar hasta que cursor realmente esté abierto antes de continuar
    for i in {1..20}; do
        cursor_check=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $current_workspace) | .address" | head -n1)
        if [ -n "$cursor_check" ]; then
            break
        fi
        sleep 0.5
    done
    sleep 0.5
fi

# abrir primera terminal (grande - para claude)
alacritty --working-directory "$repo_dir" &
sleep 0.5

# abrir segunda terminal (pequeña - para comandos/lazygit)
alacritty --working-directory "$repo_dir" &
sleep 1

# obtener las dos terminales y determinar cuál está abajo
# la terminal de abajo tendrá una coordenada Y mayor
terminals_data=$(hyprctl clients -j | jq -r "[.[] | select(.workspace.id == $current_workspace and .class == \"Alacritty\")] | sort_by(.at[1])")
bottom_terminal=$(echo "$terminals_data" | jq -r '.[-1].address')

if [ -n "$bottom_terminal" ]; then
    # hacer focus en la terminal de abajo (la pequeña)
    hyprctl dispatch focuswindow "address:$bottom_terminal"
    sleep 0.3

    # hacer la terminal más pequeña
    # horizontal: negativo reduce ancho hacia la izquierda
    # vertical: positivo reduce altura hacia arriba (para ventana de abajo)
    for i in {1..15}; do
        hyprctl dispatch resizeactive 30 30
        sleep 0.01
    done
fi

notify-send "Workspace Setup" "Workspace $current_workspace configured for $repo_name"
