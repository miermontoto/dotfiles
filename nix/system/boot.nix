{pkgs, ...}: {
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;

    # entrada para chainload de Fedora desde el menú de systemd-boot.
    # secure boot está desactivado, así que cargamos grubx64.efi directamente.
    systemd-boot.extraEntries = {
      "fedora.conf" = ''
        title Fedora
        efi /EFI/fedora/grubx64.efi
      '';
    };
  };

  # herramienta para gestionar el orden de arranque UEFI desde el OS.
  environment.systemPackages = [pkgs.efibootmgr];

  boot.tmp.cleanOnBoot = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
