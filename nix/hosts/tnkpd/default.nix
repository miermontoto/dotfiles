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

  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  hardware.amdgpu.initrd.enable = true;
}
