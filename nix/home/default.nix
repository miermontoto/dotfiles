{
  inputs,
  stateVersion,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./cli.nix
    ./dev.nix
    ./editors.nix
    ./files.nix
    ./fish.nix
    ./git.nix
    ./packages.nix
    ./secrets.nix
    ./shell-env.nix
    ./spicetify.nix
    ./terminals.nix
    ./theme.nix
    ./wayland.nix
  ];

  home = {
    username = "mier";
    homeDirectory = "/home/mier";
    stateVersion = stateVersion;
  };

  programs.home-manager.enable = true;
}
