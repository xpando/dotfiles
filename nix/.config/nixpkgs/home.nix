{ config, pkgs, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "david";
    homeDirectory = "/home/david";
    packages = [
      stow
      antibody
      starship
      exa
      fzf
      fasd
      fd
      bat
      htop
      neofetch
      vim
      neovim
      git
      delta
      ripgrep
      direnv
      gnupg

      (nerdfonts.override { fonts = [ "Iosevka" "Hack" ]; })
    ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
