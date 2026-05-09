{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      inter
      dm-sans
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Inter" "Noto Sans"];
        monospace = ["TX-02" "BerkeleyMono Nerd Font"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
  # fuentes personalizadas (TX-02, BerkeleyMono, Nerd Fonts) via home.file -> .local/share/fonts
}
