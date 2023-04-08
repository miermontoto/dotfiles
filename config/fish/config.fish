starship init fish | source
bind \b backward-kill-bigword
bind \t accept-autosuggestion # tab for autocompletion
bind \e\[Z complete           # shift-tab for regular completion
set -U fish_user_paths $fish_user_paths ~/git/scripts
set -U fish_user_paths $fish_user_paths .
