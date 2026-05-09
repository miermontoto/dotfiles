{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelParams = ["amd_pstate=active"];

  hardware.amdgpu.initrd.enable = true;

  # gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;
}
