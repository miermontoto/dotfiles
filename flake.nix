{
  description = "mier's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    mkHost = import ./nix/lib {inherit inputs self;};
  in {
    nixosConfigurations = {
      tnkpd = mkHost {
        hostname = "tnkpd";
        system = "x86_64-linux";
        stateVersion = "25.05";
      };

      apd-iii = mkHost {
        hostname = "apd-iii";
        system = "x86_64-linux";
        stateVersion = "25.05";
      };
    };
  };
}
