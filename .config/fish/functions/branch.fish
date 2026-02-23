function branch -d "selector interactivo de ramas git con fzf"
    if not git rev-parse --is-inside-work-tree &>/dev/null
        echo "no estás en un repositorio git"
        return 1
    end

    set -l flags
    set -l header "local branches"

    if contains -- -a $argv
        set flags -a
        set header "all branches"
    end

    set -l selected (git branch $flags --sort=-committerdate --format='%(refname:short)' | fzf --header=$header --preview='git log --oneline -10 {}')

    if test -n "$selected"
        git checkout $selected
    end
end
