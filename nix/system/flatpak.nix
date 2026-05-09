{
  # apps que se mantienen como flatpak:
  # - Postman, Android Studio, BurpSuite, OBS Studio, Flatseal
  # añadir flathub manualmente:
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  services.flatpak.enable = true;
}
