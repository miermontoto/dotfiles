{
  security.polkit.enable = true;

  security.pam.services.hyprlock = {};

  # desbloquea el keyring automáticamente al iniciar sesión por greetd
  security.pam.services.greetd.enableGnomeKeyring = true;

  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["mier"];
  };
}
