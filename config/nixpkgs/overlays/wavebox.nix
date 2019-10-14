self: super:
with super.stdenv.lib;
let
  version = "4.11.4";
  tarball = "Wavebox_${replaceStrings ["."] ["_"] (toString version)}_linux_x86_64.tar.gz";
  desktopItem = super.makeDesktopItem rec {
    name = "Wavebox";
    exec = name;
    icon = "wavebox";
    desktopName = name;
    genericName = name;
    categories = "Network;";
  };
in
{
  wavebox = super.wavebox.overrideAttrs (attrs: rec {
    name = "wavebox-${version}";
    src = super.fetchurl {
      url = "https://github.com/wavebox/waveboxapp/releases/download/v${version}/${tarball}";
      sha256 = "0y1q01fi2fz6gg7fcfr4qkbvvpkwdf255c3qhqzirqjkd6dibgqx";
    };
    installPhase = ''
      mkdir -p $out/bin $out/opt/wavebox
      cp -r * $out/opt/wavebox

      # provide desktop item and icon
      mkdir -p $out/share/applications $out/share/pixmaps
      ln -s ${desktopItem}/share/applications/* $out/share/applications
      ln -s $out/opt/wavebox/wavebox_icon.png $out/share/pixmaps/wavebox.png
    '';
  });
}
