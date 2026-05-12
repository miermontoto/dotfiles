#!/usr/bin/env bash

# obtener el workspace actual
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# preguntar al usuario el workspace destino
target_workspace=$(echo "" | rofi -dmenu -p "Move all windows to workspace:")

# validar que se ingresó un workspace
if [ -z "$target_workspace" ]; then
    exit 0
fi

# obtener todas las ventanas del workspace actual con su geometría
windows_data=$(hyprctl clients -j | jq -c ".[] | select(.workspace.id == $current_workspace) | {address: .address, floating: .floating, at: .at, size: .size}")

# mover cada ventana al workspace destino y restaurar geometría
echo "$windows_data" | while IFS= read -r window_data; do
    address=$(echo "$window_data" | jq -r '.address')
    floating=$(echo "$window_data" | jq -r '.floating')
    x=$(echo "$window_data" | jq -r '.at[0]')
    y=$(echo "$window_data" | jq -r '.at[1]')
    width=$(echo "$window_data" | jq -r '.size[0]')
    height=$(echo "$window_data" | jq -r '.size[1]')

    # mover ventana al workspace destino
    hyprctl dispatch movetoworkspacesilent "$target_workspace,address:$address"

    # si la ventana es flotante, restaurar posición y tamaño
    if [ "$floating" = "true" ]; then
        hyprctl dispatch resizewindowpixel "exact $width $height,address:$address"
        hyprctl dispatch movewindowpixel "exact $x $y,address:$address"
    fi
done

# cambiar al workspace destino
hyprctl dispatch workspace "$target_workspace"
