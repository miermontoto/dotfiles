{
  config,
  pkgs,
  ...
}: let
  dotfiles = "/home/mier/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
  secretsExist = builtins.pathExists ../../secrets/secrets.yaml;
  secretsInit =
    if secretsExist
    then ''
      # sops-nix secrets
      if test -f ${config.sops.templates."fish-secrets.fish".path}
        source ${config.sops.templates."fish-secrets.fish".path}
      end
    ''
    else "";
in {
  programs.fish = {
    enable = true;

    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
    ];

    # las funciones viven como archivos reales en .config/fish/functions/
    # (symlink declarado más abajo en home.file)

    interactiveShellInit = ''
      ${secretsInit}
      set -g fish_greeting ""

      # disparar event handlers de plugins (autopair, puffer) que reaccionan a fish_key_bindings
      set fish_key_bindings fish_default_key_bindings

      # fzf.fish: reinstalar bindings sin ctrl-r para que atuin sea dueño
      fzf_configure_bindings --history=

      atuin init fish --disable-up-arrow | source

      # awscli envuelve completions via aws_completer (no hay vendor file en nixpkgs)
      complete -c aws -f -a '(aws_completer)'
    '';
  };

  # init de herramientas via módulos de home-manager (más rápido que `init | source` en cada shell interactivo)
  # atuin permanece como init manual arriba: el `set fish_key_bindings ...` resetea bindings, así que su ctrl-r debe registrarse después
  programs.starship.enable = true;
  programs.zoxide = {
    enable = true;
    options = [ "--cmd" "cd" ];
  };
  programs.atuin = {
    enable = true;
    enableFishIntegration = false;
  };

  # variables y PATH a nivel de sesión (login) en lugar de re-evaluarlas en cada shell interactivo
  home.sessionVariables = {
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
    BUN_INSTALL = "${config.home.homeDirectory}/.bun";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/pnpm"
    "${config.home.homeDirectory}/.bun/bin"
  ];

  home.file = {
    ".config/fish/conf.d/abbr.fish".source = link ".config/fish/conf.d/abbr.fish";
    ".config/fish/conf.d/atuin.env.fish".source = link ".config/fish/conf.d/atuin.env.fish";
    ".config/fish/conf.d/done.fish".source = link ".config/fish/conf.d/done.fish";
    ".config/fish/conf.d/fish_frozen_key_bindings.fish".source = link ".config/fish/conf.d/fish_frozen_key_bindings.fish";
    ".config/fish/conf.d/fish_frozen_theme.fish".source = link ".config/fish/conf.d/fish_frozen_theme.fish";
    ".config/fish/conf.d/fnm.fish".source = link ".config/fish/conf.d/fnm.fish";
    ".config/fish/conf.d/rustup.fish".source = link ".config/fish/conf.d/rustup.fish";
    ".config/fish/completions".source = link ".config/fish/completions";
    ".config/fish/functions".source = link ".config/fish/functions";
  };
}
