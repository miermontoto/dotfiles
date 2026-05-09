{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "mier";
    group = "users";
    dataDir = "/home/mier";
  };

  services.openssh.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.printing.enable = false;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
