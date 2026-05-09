#!/bin/bash

TODO_DIR="$HOME/dotfiles/.data/waybar-todo"
TODO_FILE="$TODO_DIR/todos.txt"
SIGNAL_NUM=8
ROFI_WIDTH='window { width: 40%; }'
DATE_SEP="⌇"
SUB_PREFIX="  "

mkdir -p "$TODO_DIR"
touch "$TODO_FILE"

today() {
    date '+%b %d' | sed 's/ 0/ /'
}

# señal para refrescar waybar
refresh() {
    pkill -RTMIN+$SIGNAL_NUM waybar
}

# determina si una línea es subtarea
is_subtask() {
    [[ "$1" == "${SUB_PREFIX}"* ]]
}

# obtiene el número de línea de una entrada exacta en el archivo
line_number_of() {
    grep -nxF "$1" "$TODO_FILE" | head -1 | cut -d: -f1
}

# muestra la lista en rofi, space togglea, enter ejecuta acción
show_menu() {
    while true; do
        local options action ret

        options="➕ agregar tarea"
        if [ -s "$TODO_FILE" ]; then
            options="$options\n🗑 archivar completadas"
        fi
        if [ -s "$TODO_DIR/archive.txt" ]; then
            options="$options\n📦 ver archivadas"
        fi
        if [ -s "$TODO_FILE" ]; then
            options="$options\n$(cat "$TODO_FILE")"
        fi

        # space (kb-custom-1) retorna exit code 10, enter retorna 0
        # kb-custom-2 (tab) retorna exit code 11 para añadir subtarea
        action=$(echo -e "$options" | rofi -dmenu -theme-str "$ROFI_WIDTH" -p "Todo  [space:toggle | tab:subtarea]" -no-custom \
            -kb-custom-1 "space" -kb-element-next "" -kb-custom-2 "Tab" -kb-accept-entry "Return" 2>/dev/null)
        ret=$?

        [ -z "$action" ] && break

        if [ "$ret" -eq 10 ]; then
            # space: toggle
            case "$action" in
                *\[x\]*) toggle_todo "$action" "[ ]" ;;
                *\[\ \]*) toggle_todo "$action" "[x]" ;;
            esac
            continue
        fi

        if [ "$ret" -eq 11 ]; then
            # tab: añadir subtarea a la tarea seleccionada
            if ! is_subtask "$action"; then
                add_subtask "$action"
            fi
            continue
        fi

        # enter: ejecutar acción
        case "$action" in
            "➕ agregar tarea")
                add_todo
                continue
                ;;
            "🗑 archivar completadas")
                archive_completed
                continue
                ;;
            "📦 ver archivadas")
                show_archive
                continue
                ;;
            *\[x\]*)
                toggle_todo "$action" "[ ]"
                ;;
            *\[\ \]*)
                toggle_todo "$action" "[x]"
                ;;
        esac
        break
    done

    refresh
}

add_todo() {
    local new_todo
    new_todo=$(echo "" | rofi -dmenu -theme-str "$ROFI_WIDTH" -p "Nueva tarea" 2>/dev/null)
    [ -n "$new_todo" ] && echo "[ ] $new_todo $DATE_SEP $(today)" >> "$TODO_FILE"
}

add_subtask() {
    local parent_line="$1"
    local lineno new_sub insert_at

    lineno=$(line_number_of "$parent_line")
    [ -z "$lineno" ] && return

    new_sub=$(echo "" | rofi -dmenu -theme-str "$ROFI_WIDTH" -p "Subtarea" 2>/dev/null)
    [ -z "$new_sub" ] && return

    # inserta después de la última subtarea del padre (o después del padre si no tiene)
    insert_at="$lineno"
    local total_lines
    total_lines=$(wc -l < "$TODO_FILE")
    while [ "$insert_at" -lt "$total_lines" ]; do
        local next_line
        next_line=$(sed -n "$((insert_at + 1))p" "$TODO_FILE")
        if is_subtask "$next_line"; then
            insert_at=$((insert_at + 1))
        else
            break
        fi
    done

    sed -i "${insert_at}a\\${SUB_PREFIX}[ ] ${new_sub} ${DATE_SEP} $(today)" "$TODO_FILE"
}

toggle_todo() {
    local old_line="$1" new_prefix="$2"
    local new_line prefix=""

    # preserva indentación de subtareas
    if is_subtask "$old_line"; then
        prefix="$SUB_PREFIX"
        old_line="${old_line#$SUB_PREFIX}"
    fi

    if [ "$new_prefix" = "[x]" ]; then
        new_line="${prefix}[x]${old_line:3} → $(today)"
    else
        new_line="${prefix}[ ]$(echo "${old_line:3}" | sed "s/ → [A-Z][a-z]\{2\} [0-9]\{1,2\}$//")"
    fi

    local escaped_old escaped_new
    escaped_old=$(printf '%s' "${prefix}${old_line}" | sed 's/[][\\.*^$/&]/\\&/g')
    escaped_new=$(printf '%s' "$new_line" | sed 's/[\\&/]/\\&/g')
    sed -i "0,/^${escaped_old}$/{s/^${escaped_old}$/${escaped_new}/}" "$TODO_FILE"
}

show_archive() {
    local archive="$TODO_DIR/archive.txt"
    [ ! -s "$archive" ] && return

    sed "s/^\[x\] /✓ /; s/^${SUB_PREFIX}\[x\] /${SUB_PREFIX}✓ /" "$archive" \
        | rofi -dmenu -theme-str "$ROFI_WIDTH" -p "Archivadas" -no-custom 2>/dev/null
}

# archiva tareas completadas (padre + sus subtareas)
archive_completed() {
    local archive="$TODO_DIR/archive.txt"
    local tmpfile
    tmpfile=$(mktemp)

    local in_completed_parent=false
    while IFS= read -r line; do
        if is_subtask "$line"; then
            if $in_completed_parent; then
                # subtarea de padre completado: archivar siempre
                echo "$line" >> "$archive"
            elif [[ "$line" == "${SUB_PREFIX}[x]"* ]]; then
                # subtarea completada de padre pendiente: archivar
                echo "$line" >> "$archive"
            else
                # subtarea pendiente de padre pendiente: mantener
                echo "$line" >> "$tmpfile"
            fi
        elif [[ "$line" == "[x]"* ]]; then
            # padre completado: archivar
            echo "$line" >> "$archive"
            in_completed_parent=true
        else
            # padre pendiente
            echo "$line" >> "$tmpfile"
            in_completed_parent=false
        fi
    done < "$TODO_FILE"

    mv "$tmpfile" "$TODO_FILE"
}

# salida JSON para waybar
waybar_output() {
    local total=0 pending=0 tooltip class

    if [ -s "$TODO_FILE" ]; then
        total=$(wc -l < "$TODO_FILE")
        pending=$(grep -c '^\( \{0,2\}\)\[ \]' "$TODO_FILE" || true)
    fi

    if [ "$total" -eq 0 ]; then
        tooltip="sin tareas"
    else
        tooltip=$(sed "s/^\[x\]/✓/; s/^\[ \]/○/; s/^${SUB_PREFIX}\[x\]/${SUB_PREFIX}✓/; s/^${SUB_PREFIX}\[ \]/${SUB_PREFIX}○/" "$TODO_FILE" \
            | jq -Rs '.' | sed 's/^"//;s/"$//')
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
