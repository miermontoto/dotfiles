{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      inter
      dm-sans
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Inter" "Noto Sans"];
        # symbols nerd font mono cubre los glifos que faltan en el parche parcial de BerkeleyMono Nerd Font
        monospace = ["TX-02" "BerkeleyMono Nerd Font" "Symbols Nerd Font Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
