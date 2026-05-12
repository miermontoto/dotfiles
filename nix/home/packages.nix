{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    slack
    discord
    obsidian
    inputs.zen-browser.packages.${pkgs.system}.default

    firefox
    vlc
    ffmpeg-full
    nautilus
    appimage-run
    mongodb-compass
    tableplus
  ];
}
