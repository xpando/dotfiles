{ config, pkgs, ... }:

with pkgs;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
 
  # This is my base tool set. Per project dev tools will be 
  # setup via a combo of direnv, asdf and nix-shell
  home = {
    username = "david";
    homeDirectory = "/home/david";
    packages = [
      bat         # cat replacement
      delta       # better diffs
      direnv      # auto switch env on dir change
      exa         # ls replacement
      fasd        # quick access to files and dirs
      fd          # find replacement
      fzf         # fuzzy find
      gh          # github CLI
      git         # dvcs
      gnupg       # digital sigs for things like git commits
      htop        # system resource monitor
      iosevka     # mono spaced font for terminal and code editors
      micro       # better nano
      neofetch    # system info
      neovim      # better vim
      nodejs      # global nodejs for npm CLI tools
      ripgrep     # better grep
      starship    # prompt
      stow        # dotfiles manager
      tree-sitter # lang syntax parser for neovim
      zsh         # Z shell

      # patched nerd fonts with symbols for prompts and status lines in the terminal
      # the full package is quite large so override with just the fonts I use
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
