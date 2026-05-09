{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.writeShellScript "start-hyprland" ''
          SETUP="/home/mier/dotfiles/.config/hypr/machines/setup.sh"
          [ -x "$SETUP" ] && "$SETUP"
          exec ${pkgs.hyprland}/bin/Hyprland
        ''}";
        user = "mier";
      };
    };
  };

  # evitar log de greetd en tty
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = ["hyprland" "gtk"];
  };

  services.xserver.xkb = {
    layout = "es";
    variant = "ast";
  };
  console.keyMap = "es";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}
