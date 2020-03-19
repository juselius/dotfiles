#!/bin/sh

glibc=`nix-instantiate --eval -E 'with import <nixpkgs> {}; pkgs.glibc.outPath' | tr -d '"'`
patchelf --set-interpreter $glibc/lib64/ld-linux-x86-64.so.2 $@
