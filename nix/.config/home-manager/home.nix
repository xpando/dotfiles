{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "david";
  home.homeDirectory = "/home/david";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # CLI Tools
    atuin
    bandwhich
    bat
    delta
    direnv
    dogdns
    du-dust
    duf
    eza
    fasd
    fd
    fzf
    gh
    gnupg
    htop
    http-prompt
    httpie
    jless
    jq
    lazygit
    lnav
    mise
    neofetch
    neovim
    nixpkgs-fmt
    onefetch
    ripgrep
    starship
    tailspin
    unar
    xstow
    zellij
    zoxide

    # Fonts
    iosevka
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "IosevkaTerm"
        "NerdFontsSymbolsOnly"
      ];
    })

    # Gnome stuff
    # gnome.gnome-tweaks
    # gnome.eog
    # gnomeExtensions.appindicator

    # GUI Applications
    # alacritty
    # brave
    # discord
    # jetbrains.idea-ultimate
    # neovide
    # steam
    # vscode
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/david/etc/profile.d/hm-session-vars.sh
  #
  #home.sessionVariables = {
  #  EDITOR = "neovim";
  #};

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
