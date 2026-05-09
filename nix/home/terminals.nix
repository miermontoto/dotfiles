{pkgs, ...}: {
  home.packages = with pkgs; [
    alacritty
    ghostty
    zellij
  ];
}
