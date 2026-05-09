{
  config,
  pkgs,
  lib,
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

    functions = {
      fish_remove_path = ''
        if set -l index (contains -i -- $argv[1] $fish_user_paths)
          set -e fish_user_paths[$index]
        end
      '';
    };

    interactiveShellInit = ''
      ${secretsInit}
      starship init fish | source
      zoxide init --cmd cd fish | source
      atuin init fish --disable-up-arrow | source

      set -gx PNPM_HOME "/home/mier/.local/share/pnpm"
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end

      set --export BUN_INSTALL "$HOME/.bun"
      set --export PATH $BUN_INSTALL/bin $PATH
    '';
  };

  home.file = {
    ".config/fish/conf.d/abbr.fish".source = link ".config/fish/conf.d/abbr.fish";
    ".config/fish/conf.d/done.fish".source = link ".config/fish/conf.d/done.fish";
    ".config/fish/conf.d/fnm.fish".source = link ".config/fish/conf.d/fnm.fish";
    ".config/fish/conf.d/rustup.fish".source = link ".config/fish/conf.d/rustup.fish";
    ".config/fish/conf.d/atuin.env.fish".source = link ".config/fish/conf.d/atuin.env.fish";
    ".config/fish/completions".source = link ".config/fish/completions";
    ".config/fish/functions".source = link ".config/fish/functions";
  };

  home.packages = with pkgs; [
    starship
    zoxide
    atuin
  ];
}
