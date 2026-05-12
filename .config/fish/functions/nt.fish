function nt -d "gestor declarativo de paquetes nix (add/remove/search/list/rebuild/update)"
    if test (count $argv) -eq 0
        __nt_help
        return 1
    end

    set -l cmd $argv[1]
    set -e argv[1]

    switch $cmd
        case add a
            __nt_add $argv
        case remove rm r
            __nt_remove $argv
        case search s
            __nt_search $argv
        case list ls l
            __nt_list
        case rebuild rb
            __nt_rebuild
        case update up
            __nt_update
        case help -h --help h
            __nt_help
        case '*'
            echo "comando desconocido: $cmd"
            __nt_help
            return 1
    end
end

function __nt_help
    echo "nt — gestor declarativo de paquetes nix"
    echo ""
    echo "uso:"
    echo "  nt add [query]       buscar e instalar un paquete en un .nix"
    echo "  nt remove [query]    eliminar un paquete declarado"
    echo "  nt search [query]    buscar sin instalar (muestra resultados)"
    echo "  nt list              listar todos los paquetes declarados"
    echo "  nt rebuild           nh os switch del flake"
    echo "  nt update            actualizar flake.lock y reconstruir"
    echo ""
    echo "aliases: a, rm/r, s, ls/l, rb, up"
end

function __nt_dotfiles
    echo /home/mier/dotfiles
end

function __nt_home_dir
    echo (__nt_dotfiles)/nix/home
end

# devuelve la rev pineada de nixpkgs en flake.lock, o vacío si falla
function __nt_get_rev
    set -l rev (jq -r '.nodes.nixpkgs.locked.rev' (__nt_dotfiles)/flake.lock 2>/dev/null)
    if test -z "$rev" -o "$rev" = "null"
        return 1
    end
    echo $rev
end

# busca en nixpkgs pineado, imprime filas tab-separadas: <attr>\t<version>\t<descr>
function __nt_search_pkgs -a query
    set -l rev (__nt_get_rev)
    if test -z "$rev"
        echo "no se pudo leer la rev de nixpkgs desde flake.lock" >&2
        return 1
    end

    set -l raw (nix search "github:nixos/nixpkgs/$rev" $query --json 2>/dev/null)
    if test -z "$raw"
        return 1
    end

    echo $raw | jq -r '
        to_entries
        | sort_by(.key)
        | .[]
        | "\(.key | split(".")[2:] | join("."))\t\(.value.version // "?")\t\(.value.description // "")"
    '
end

# enumera paquetes declarados, imprime <basename>\t<numero-linea>\t<contenido>
function __nt_enumerate_packages
    set -l home_dir (__nt_home_dir)
    for f in $home_dir/*.nix
        set -l fname (basename $f)
        awk -v fname="$fname" '
            function count_brackets(s,    i, c, n) {
                n = 0
                for (i = 1; i <= length(s); i++) {
                    c = substr(s, i, 1)
                    if (c == "[") n++
                    else if (c == "]") n--
                }
                return n
            }
            BEGIN { in_pkgs = 0; depth = 0 }
            !in_pkgs && /home\.packages.*\[/ {
                in_pkgs = 1
                depth = count_brackets($0)
                next
            }
            in_pkgs {
                delta = count_brackets($0)
                if (depth + delta == 0) {
                    in_pkgs = 0
                    next
                }
                trimmed = $0
                sub(/^[[:space:]]+/, "", trimmed)
                sub(/[[:space:]]+$/, "", trimmed)
                if (trimmed != "" && substr(trimmed, 1, 1) != "#") {
                    printf "%s\t%d\t%s\n", fname, NR, trimmed
                }
                depth += delta
                next
            }
        ' $f
    end
end

# inserta una entrada justo antes del ] que cierra home.packages
function __nt_insert_into_file -a file pkg
    set -l tmpfile (mktemp)
    awk -v pkg="$pkg" '
        function count_brackets(s,    i, c, n) {
            n = 0
            for (i = 1; i <= length(s); i++) {
                c = substr(s, i, 1)
                if (c == "[") n++
                else if (c == "]") n--
            }
            return n
        }
        BEGIN { in_pkgs = 0; depth = 0 }
        !in_pkgs && /home\.packages.*\[/ {
            in_pkgs = 1
            depth = count_brackets($0)
            print
            next
        }
        in_pkgs {
            delta = count_brackets($0)
            if (depth + delta == 0) {
                print "    " pkg
                in_pkgs = 0
            }
            depth += delta
            print
            next
        }
        { print }
    ' $file > $tmpfile

    if cmp -s $file $tmpfile
        rm $tmpfile
        return 1
    end
    mv $tmpfile $file
end

function __nt_add
    set -l dotfiles (__nt_dotfiles)
    set -l home_dir (__nt_home_dir)

    set -l query
    if test (count $argv) -gt 0
        set query "$argv"
    else
        read -P "buscar paquete: " query
    end

    if test -z "$query"
        echo "query vacía"
        return 1
    end

    set -l rev (__nt_get_rev)
    if test -z "$rev"
        echo "no se pudo leer la rev de nixpkgs desde $dotfiles/flake.lock"
        return 1
    end

    echo "buscando '$query' en nixpkgs (rev "(string sub -l 7 -- $rev)")..."
    set -l results (__nt_search_pkgs $query)

    if test -z "$results"
        echo "sin resultados para '$query'"
        return 1
    end

    set -l selected (printf '%s\n' $results | fzf \
        --delimiter=\t \
        --with-nth=1,2,3 \
        --nth=1,3 \
        --header="seleccionar paquete (col1=nombre, col2=versión, col3=descripción)")

    if test -z "$selected"
        echo "cancelado"
        return 1
    end

    set -l pkg (string split -f1 \t -- $selected)

    set -l candidates
    for f in $home_dir/*.nix
        if grep -q "home.packages" $f
            set -a candidates $f
        end
    end

    if test (count $candidates) -eq 0
        echo "ningún archivo en $home_dir tiene home.packages"
        return 1
    end

    set -l file (printf '%s\n' $candidates | fzf \
        --preview="bat --color=always --style=numbers {}" \
        --header="añadir '$pkg' a")

    if test -z "$file"
        echo "cancelado"
        return 1
    end

    for line in (cat $file)
        if test (string trim -- $line) = "$pkg"
            echo "$pkg ya está en "(basename $file)
            return 1
        end
    end

    set -l backup (mktemp)
    cp $file $backup

    if not __nt_insert_into_file $file $pkg
        rm $backup
        echo "no se pudo localizar el cierre de home.packages en "(basename $file)
        return 1
    end

    alejandra -q $file 2>/dev/null

    echo "añadido $pkg a "(basename $file)". reconstruyendo..."

    if nh os switch $dotfiles
        rm $backup
        echo "ok"
    else
        echo "fallo el rebuild, revirtiendo "(basename $file)"..."
        mv $backup $file
        return 1
    end
end

function __nt_remove
    set -l dotfiles (__nt_dotfiles)
    set -l home_dir (__nt_home_dir)

    set -l entries (__nt_enumerate_packages)
    if test (count $entries) -eq 0
        echo "no se encontraron paquetes en ningún archivo"
        return 1
    end

    # reordenamos a <pkg>\t<fname>\t<lineno> antes de fzf. con --with-nth que
    # *reordena* (p.e. 3,1), fzf 0.72 deja escapar el match a campos vecinos del
    # display y la búsqueda fuzzy "ensucia" el resultado. con el paquete ya en
    # la columna 1, basta --with-nth=1,2 (que solo *oculta* la lineno) y --nth=1
    # restringe correctamente la búsqueda al nombre del paquete.
    set -l fzf_args \
        --delimiter=\t \
        --with-nth=1,2 \
        --nth=1 \
        --header="seleccionar paquete a eliminar (col1=paquete, col2=archivo)" \
        --preview="bat --color=always --highlight-line {3} --style=numbers,changes $home_dir/{2}"

    if test (count $argv) -gt 0
        set -a fzf_args --query "$argv"
    end

    set -l selected (printf '%s\n' $entries \
        | awk 'BEGIN{FS=OFS="\t"}{print $3, $1, $2}' \
        | fzf $fzf_args)

    if test -z "$selected"
        echo "cancelado"
        return 1
    end

    set -l parts (string split \t -- $selected)
    set -l pkg $parts[1]
    set -l fname $parts[2]
    set -l lineno $parts[3]
    set -l file $home_dir/$fname

    set -l backup (mktemp)
    cp $file $backup

    set -l tmpfile (mktemp)
    awk -v target="$lineno" 'NR != target { print }' $file > $tmpfile
    mv $tmpfile $file

    alejandra -q $file 2>/dev/null

    echo "eliminado '$pkg' de $fname. reconstruyendo..."

    if nh os switch $dotfiles
        rm $backup
        echo "ok"
    else
        echo "fallo el rebuild, revirtiendo $fname..."
        mv $backup $file
        return 1
    end
end

function __nt_search
    set -l query
    if test (count $argv) -gt 0
        set query "$argv"
    else
        read -P "buscar paquete: " query
    end

    if test -z "$query"
        echo "query vacía"
        return 1
    end

    set -l rev (__nt_get_rev)
    echo "buscando '$query' en nixpkgs (rev "(string sub -l 7 -- $rev)")..."

    set -l results (__nt_search_pkgs $query)
    if test -z "$results"
        echo "sin resultados para '$query'"
        return 1
    end

    set -l selected (printf '%s\n' $results | fzf \
        --delimiter=\t \
        --with-nth=1,2,3 \
        --nth=1,3 \
        --header="resultados de búsqueda (enter para imprimir, esc para salir)")

    if test -n "$selected"
        set -l parts (string split \t -- $selected)
        echo $parts[1]" "$parts[2]
        if test -n "$parts[3]"
            echo $parts[3]
        end
    end
end

function __nt_list
    set -l entries (__nt_enumerate_packages)
    if test (count $entries) -eq 0
        echo "no hay paquetes declarados"
        return 1
    end

    set -l count (count $entries)
    set -l files (printf '%s\n' $entries | awk -F\t '{ print $1 }' | sort -u | wc -l)
    echo "$count paquetes en $files archivos"
    echo ""

    printf '%s\n' $entries | awk -F\t '{ printf "  %-22s %s\n", $1, $3 }' | sort
end

function __nt_rebuild
    nh os switch (__nt_dotfiles)
end

function __nt_update
    set -l dotfiles (__nt_dotfiles)
    echo "actualizando flake.lock..."
    nix flake update --flake $dotfiles
    or begin
        echo "fallo nix flake update"
        return 1
    end
    echo ""
    nh os switch $dotfiles
end
