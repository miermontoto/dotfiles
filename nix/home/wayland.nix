{pkgs, ...}: {
  home.packages = with pkgs; [
    # hyprland ecosystem
    hyprlock
    hyprpaper
    hyprsunset
    hyprshot

    # bar y notificaciones
    waybar
    swaynotificationcenter
    libnotify

    # launcher
    rofi

    # clipboard
    clipse
    wl-clipboard

    # screenshot e imágenes
    grim
    slurp
    imv

    # tray
    blueman
    networkmanagerapplet

    # python + requests para weather.py
    (python3.withPackages (ps: [ps.requests]))
  ];
}
