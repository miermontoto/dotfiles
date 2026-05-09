{
  security.polkit.enable = true;

  security.pam.services.hyprlock = {};

  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["mier"];
  };
}
