{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix-managed languages
    go
    ruby
    jdk21
    php84
    php84Packages.composer
    python3

    # build tools
    gcc
    gnumake
    pkg-config
    openssl
    cmake

    # node via fnm (nix solo provee el binario)
    fnm

    # rust via rustup (nix solo provee el binario)
    rustup

    # dev tools
    docker-compose
    gh
    lazygit
    delta
    socat
    bc
  ];
}
