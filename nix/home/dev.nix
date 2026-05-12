{pkgs, ...}: {
  home.packages = with pkgs; [
    go
    ruby
    jdk21
    php84
    php84Packages.composer

    gcc
    gnumake
    pkg-config
    openssl
    cmake

    fnm
    rustup

    # dev tools
    # docker compose v2 viene como plugin con pkgs.docker (system-wide); no instalar docker-compose v1
    # gh se instala via programs.gh en git.nix
    lazygit
    socat
    bc
    nixd
    nil
    pnpm
    bun
  ];
}
