#!/bin/sh

interp=$(nix-instantiate --eval -E 'with import <nixpkgs> {}; "${pkgs.glibc.outPath}/lib64/ld-linux-x86-64.s.2"')
patchelf --set-interpreter $interp $@
