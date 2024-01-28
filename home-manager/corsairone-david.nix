{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "david";
  home.homeDirectory = "/home/david";

  # Packages specific to my personal Linux machine
  home.packages = with pkgs; home.packages ++ [
    # Gnome stuff
    gnome.gnome-tweaks
    gnome.eog
    gnomeExtensions.appindicator

    # GUI Applications
    discord
    steam
  ];
}
