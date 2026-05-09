{config, ...}: let
  dotfiles = "/home/mier/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
  home.file = {
    ".config/hypr".source = link ".config/hypr";
    ".config/waybar".source = link ".config/waybar";
    ".config/alacritty".source = link ".config/alacritty";
    ".config/ghostty".source = link ".config/ghostty";
    ".config/rofi".source = link ".config/rofi";
    ".config/mako".source = link ".config/mako";
    ".config/lazygit".source = link ".config/lazygit";
    ".config/zellij".source = link ".config/zellij";
    ".config/nvim".source = link ".config/nvim";
    ".config/MangoHud".source = link ".config/MangoHud";
    ".config/neofetch".source = link ".config/neofetch";
    ".config/zed".source = link ".config/zed";
    ".config/starship.toml".source = link ".config/starship.toml";

    ".local/share/fonts".source = link ".local/share/fonts";
  };
}
