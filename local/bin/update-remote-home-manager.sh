#!/usr/bin/env bash

for i in $@; do
    ssh -t $i "cd .dotfiles; git pull; home-manager switch -f ~/.dotfiles/config/nixpkgs/home.nix"
done
