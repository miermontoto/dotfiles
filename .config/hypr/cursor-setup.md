# Hyprland Cursor Setup (Fedora)

Change `macOS` and `32` to your theme/size:

```bash
CURSOR=macOS SIZE=32 && \
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR" && \
gsettings set org.gnome.desktop.interface cursor-size "$SIZE" && \
flatpak override --user --env=XCURSOR_THEME="$CURSOR" --env=XCURSOR_SIZE="$SIZE" --filesystem=~/.icons:ro && \
echo -e "Xcursor.theme: $CURSOR\nXcursor.size: $SIZE" > ~/.Xresources && xrdb -merge ~/.Xresources && \
hyprctl setcursor "$CURSOR" "$SIZE"
```

Add to `hyprland.conf`:

```
env = XCURSOR_THEME,macOS
env = XCURSOR_SIZE,32
env = HYPRCURSOR_THEME,macOS
env = HYPRCURSOR_SIZE,32
```

Add to `startup.conf` (for gsettings persistence):

```
exec-once = hyprctl setcursor macOS 32
exec-once = gsettings set org.gnome.desktop.interface cursor-theme macOS && gsettings set org.gnome.desktop.interface cursor-size 32
```
