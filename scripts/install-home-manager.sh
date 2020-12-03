#!/usr/bin/env bash

top="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/.."

cd $top
git checkout master
git submodule init
git submodule update

nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

mkdir -p ~/.config/omf

~/.nix-profile/bin/home-manager switch -f $top/config/nixpkgs/home.nix
