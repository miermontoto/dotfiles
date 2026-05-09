{pkgs, ...}: {
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.tailscale.enable = true;

  networking.firewall.trustedInterfaces = ["tailscale0"];
}
