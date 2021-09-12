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
      stow      # dotfiles manager
      antibody  # zsh plugin manager
      starship  # prompt
      exa       # ls replacement
      fzf       # fuzzy find
      fasd      # quick access to files and dirs
      fd        # find replacement
      bat       # cat replacement
      htop      # system resource monitor
      neofetch  # system info
      neovim    # better vim
      git       # dvcs
      delta     # better diffs
      ripgrep   # better grep
      direnv    # auto switch env on dir change
      gnupg     # digital sigs for things like git commits

      # patched nerd fonts with symbols for prompts and status lines in the terminal
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
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
