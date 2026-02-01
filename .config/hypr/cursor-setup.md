# Hyprland Cursor Setup (Fedora)

Change `macOS` and `24` to your theme/size:

```bash
CURSOR=macOS SIZE=24 && \
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR" && \
gsettings set org.gnome.desktop.interface cursor-size "$SIZE" && \
flatpak override --user --env=XCURSOR_THEME="$CURSOR" --env=XCURSOR_SIZE="$SIZE" --filesystem=~/.icons:ro && \
echo -e "Xcursor.theme: $CURSOR\nXcursor.size: $SIZE" > ~/.Xresources && xrdb -merge ~/.Xresources && \
hyprctl setcursor "$CURSOR" "$SIZE"
```

Also add to `hyprland.conf`:
```
env = XCURSOR_THEME,macOS
env = XCURSOR_SIZE,24
env = HYPRCURSOR_THEME,macOS
env = HYPRCURSOR_SIZE,24
```
