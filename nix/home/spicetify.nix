{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    theme = {
      name = "text";
      src = ../../.config/spicetify/Themes/text;
    };

    enabledCustomApps = with spicePkgs.apps; [
      # marketplace
    ];
  };
}
