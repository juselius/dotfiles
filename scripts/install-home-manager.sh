#!/usr/bin/env bash

top="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/.."

cd $top

git submodule init
git submodule update

nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
nix-channel --update

export NIX_PATH="home-manager=$HOME/.nix-defexpr/channels/home-manager${NIX_PATH:+:}$NIX_PATH"
nix-shell '<home-manager>' -A install

mkdir -p ~/.config/omf

~/.nix-profile/bin/home-manager switch -f $top/config/nixpkgs/home.nix
