{pkgs, ...}: {
  programs.fish.enable = true;
  environment.localBinInPath = true;

  users.users.mier = {
    isNormalUser = true;
    description = "Juan Mier";
    extraGroups = ["networkmanager" "wheel" "docker" "video" "audio" "input"];
    shell = pkgs.fish;
  };
}
