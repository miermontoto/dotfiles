{pkgs, ...}: {
  home.packages = with pkgs; [
    # hyprland ecosystem
    hyprlock
    hyprpaper
    hyprsunset
    hyprshot

    # bar y notificaciones
    waybar
    mako
    libnotify

    # launcher
    rofi-wayland

    # clipboard
    clipse
    wl-clipboard

    # screenshot
    grim
    slurp

    # tray
    blueman
    networkmanagerapplet

    # python + requests para weather.py
    (python3.withPackages (ps: [ps.requests]))
  ];
}
