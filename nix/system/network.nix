{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    # syncthing
    allowedTCPPorts = [22000];
    allowedUDPPorts = [22000 21027];
  };
}
