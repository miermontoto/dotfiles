{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    vscode
    zed-editor
  ];

  # alias "zeditor" -> "zed"
  home.file.".local/bin/zed".source = "${pkgs.zed-editor}/bin/zeditor";
}
