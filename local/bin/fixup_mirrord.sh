#!/usr/bin/env fish
# vim:ft=fish

set interp (nix-instantiate --eval -E 'with import <nixpkgs> {}; "${pkgs.glibc.outPath}/lib64/ld-linux-x86-64.so.2"' | tr -d \")

for i in ~/.local/bin/mirrord ~/.local/share/JetBrains/Rider20*/mirrord/bin/linux/x86-64/mirrord;
    echo $i $interp
    chmod 755 $i
    patchelf --set-interpreter $interp $i
end

