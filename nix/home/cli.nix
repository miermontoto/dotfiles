{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    eza
    fzf
    jq
    ripgrep
    fd
    htop
    btop
    fastfetch
    glow
    tree
    unzip
    wget
    curl
    file
    pciutils
    usbutils
    lsof

    powertop
    brightnessctl
    playerctl
    pavucontrol

    alejandra
    nix-output-monitor
  ];
}
