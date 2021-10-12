#!/bin/sh

nix-instantiate --eval -E 'with import <nixpkgs> {}; pkgs.glibc.outPath' | \
    tr -d '"' | sed 's,.*,&/lib/ld-linux-x86-64.so.2,'
