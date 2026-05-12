{inputs, self}: {
  hostname,
  system,
  stateVersion,
  extraModules ? [],
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {inherit inputs self hostname stateVersion;};
  modules =
    [
      ../hosts/${hostname}
      ../system
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      {
        networking.hostName = hostname;
        system.stateVersion = stateVersion;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          # ante colisiones con archivos no gestionados, los renombra a *.bak en lugar de abortar la activación
          backupFileExtension = "bak";
          extraSpecialArgs = {inherit inputs self hostname stateVersion;};
          users.mier = import ../home;
        };
      }
    ]
    ++ extraModules;
}
