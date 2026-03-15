#!/bin/bash

TODO_DIR="$HOME/dotfiles/.data/waybar-todo"
TODO_FILE="$TODO_DIR/todos.txt"
SIGNAL_NUM=8

mkdir -p "$TODO_DIR"
touch "$TODO_FILE"

# señal para refrescar waybar
refresh() {
    pkill -RTMIN+$SIGNAL_NUM waybar
}

# muestra la lista en rofi para interacción
show_menu() {
    local options action

    options="➕ agregar tarea"
    if [ -s "$TODO_FILE" ]; then
        options="$options\n🗑 eliminar completadas\n$(cat "$TODO_FILE")"
    fi

    action=$(echo -e "$options" | rofi -dmenu -p "Todo" -no-custom 2>/dev/null)
    [ -z "$action" ] && return

    case "$action" in
        "➕ agregar tarea")
            add_todo
            ;;
        "🗑 eliminar completadas")
            remove_completed
            ;;
        \[x\]*)
            toggle_todo "$action" "[ ]"
            ;;
        \[\ \]*)
            toggle_todo "$action" "[x]"
            ;;
    esac

    refresh
}

add_todo() {
    local new_todo
    new_todo=$(echo "" | rofi -dmenu -p "Nueva tarea" 2>/dev/null)
    [ -n "$new_todo" ] && echo "[ ] $new_todo" >> "$TODO_FILE"
}

toggle_todo() {
    local old_line="$1" new_prefix="$2"
    local content="${old_line#\[?\] }"
    local escaped_old
    escaped_old=$(printf '%s\n' "$old_line" | sed 's/[[\.*^$()+?{|]/\\&/g')
    sed -i "0,/$escaped_old/{s/$escaped_old/$new_prefix $content/}" "$TODO_FILE"
}

remove_completed() {
    sed -i '/^\[x\]/d' "$TODO_FILE"
}

# salida JSON para waybar
waybar_output() {
    local total=0 pending=0 tooltip class

    if [ -s "$TODO_FILE" ]; then
        total=$(wc -l < "$TODO_FILE")
        pending=$(grep -c '^\[ \]' "$TODO_FILE" || true)
    fi

    if [ "$total" -eq 0 ]; then
        tooltip="sin tareas"
    else
        tooltip=$(sed 's/^\[x\]/✓/; s/^\[ \]/○/' "$TODO_FILE" | jq -Rs '.' | sed 's/^"//;s/"$//')
    fi

    class="empty"
    [ "$pending" -gt 0 ] && class="has-pending"

    local done=$((total - pending))
    printf '{"text": "📋 %d/%d", "tooltip": "%s", "class": "%s"}\n' "$done" "$total" "$tooltip" "$class"
}

case "${1:-}" in
    toggle) show_menu ;;
    *) waybar_output ;;
esac
