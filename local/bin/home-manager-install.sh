#!/usr/bin/env bash

mkdir -p ~/.config/nixpkgs
cd ~/.config/nixpkgs
ln -sf ~/.dotfiles/config/nixpkgs/* .
nix-shell https://github.com/rycee/home-manager/archive/master.tar.gz -A install
