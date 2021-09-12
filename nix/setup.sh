#!/bin/env sh

set -e

# install nix package manager
sh <(curl -L https://nixos.org/nix/install) --daemon

nix-channel --update

NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

# install home manager
nix-shell '<home-manager>' -A install

# install my packages
home-manager switch

