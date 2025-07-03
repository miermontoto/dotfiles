if status is-interactive
  printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
end

function fish_remove_path
  if set -l index (contains -i "$argv" $fish_user_paths)
    set -e fish_user_paths[$index]
    echo "Removed $argv from the path"
  end
end

starship init fish | source
zoxide init --cmd cd fish | source
atuin init fish --disable-up-arrow | source

# pnpm
set -gx PNPM_HOME "/home/mier/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
