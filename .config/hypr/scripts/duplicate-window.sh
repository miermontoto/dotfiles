#!/bin/bash

# obtiene información de la ventana activa
window_info=$(hyprctl activewindow -j)
window_class=$(echo "$window_info" | jq -r '.class')
window_pid=$(echo "$window_info" | jq -r '.pid')

# lista de clases de terminales conocidas
terminals=("Alacritty" "alacritty" "ghostty" "kitty" "foot" "wezterm")

# verifica si la ventana activa es un terminal
is_terminal=false
for term in "${terminals[@]}"; do
    if [[ "$window_class" == "$term" ]]; then
        is_terminal=true
        break
    fi
done

if $is_terminal; then
    # busca el proceso hijo (shell) del terminal para obtener su cwd
    shell_pid=$(pgrep -P "$window_pid" | head -1)

    if [ -n "$shell_pid" ]; then
        # obtiene el directorio de trabajo del shell
        cwd=$(readlink -f "/proc/$shell_pid/cwd" 2>/dev/null)
    fi

    # fallback al home si no se pudo obtener el cwd
    if [ -z "$cwd" ] || [ ! -d "$cwd" ]; then
        cwd="$HOME"
    fi

    # lanza nuevo terminal en el mismo directorio
    case "$window_class" in
        Alacritty|alacritty)
            alacritty --working-directory "$cwd"
            ;;
        ghostty)
            ghostty --working-directory="$cwd"
            ;;
        kitty)
            kitty --directory "$cwd"
            ;;
        foot)
            foot --working-directory "$cwd"
            ;;
        wezterm)
            wezterm start --cwd "$cwd"
            ;;
    esac
else
    # para aplicaciones no-terminal, intenta lanzar una nueva instancia
    case "$window_class" in
        firefox|Firefox)
            firefox &
            ;;
        zen-alpha|zen)
            zen-browser &
            ;;
        Code|code)
            code -n &
            ;;
        Zed|zed)
            /home/mier/.local/bin/zed -n &
            ;;
        Slack)
            flatpak run com.slack.Slack &
            ;;
        Spotify|spotify)
            flatpak run com.spotify.Client &
            ;;
        obsidian|Obsidian)
            flatpak run md.obsidian.Obsidian &
            ;;
        1Password|1password)
            1password &
            ;;
        nautilus|org.gnome.Nautilus)
            nautilus --new-window &
            ;;
        *)
            # intento genérico: busca el ejecutable por el nombre de clase
            exec_name=$(echo "$window_class" | tr '[:upper:]' '[:lower:]')
            if command -v "$exec_name" &> /dev/null; then
                "$exec_name" &
            else
                notify-send "Duplicate Window" "No se pudo duplicar: $window_class"
            fi
            ;;
    esac
fi
