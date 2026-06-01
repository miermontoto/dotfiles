# fnm
if command -q fnm
    fnm env --shell fish --use-on-cd | source
end

# fnm
set FNM_PATH "/home/mier/.local/share/fnm"
if [ -d "$FNM_PATH" ]
  set PATH "$FNM_PATH" $PATH
  fnm env --shell fish | source
end
