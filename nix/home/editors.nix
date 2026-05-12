{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    vscode
    zed-editor
  ];

  # nixpkgs expone el binario como `zeditor`; aliasamos a `zed` en ~/.local/bin
  home.file.".local/bin/zed".source = "${pkgs.zed-editor}/bin/zeditor";
}
