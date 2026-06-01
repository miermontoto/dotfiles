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
    # solo dig/nslookup/host, sin el servidor BIND completo
    dnsutils
    awscli2
    awslogs

    nh
    cloudflared
    ssm-session-manager-plugin
    witr
    tldr
    clamav
    stow
  ];

  # mantener man pero saltarse el mandb (rompe apropos/man -k)
  programs.man.generateCaches = false;
}
