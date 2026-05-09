{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    vscode
    zed-editor
  ];
}
