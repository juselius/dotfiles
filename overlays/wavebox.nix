self: super:
with super.lib;
let
  version = "10.108.19-2";
  tarball = "Wavebox_${version}.tar.gz";
  desktopItem = super.makeDesktopItem rec {
    name = "Wavebox";
    exec = name;
    icon = "wavebox";
    desktopName = name;
    genericName = name;
    categories = [ ];
  };
in
{
  wavebox = super.wavebox.overrideAttrs (attrs: rec {
    name = "wavebox-${version}";
    src = super.fetchurl {
      url = "https://download.wavebox.app/stable/linux/tar/${tarball}";
      sha256 = "sha256-VI2/qhD5EK3e00lexcsGXt72Vm6ncVNqMkUmGbDATWc=";
    };
    buildInputs =
      attrs.buildInputs ++ [
        super.xorg.libxshmfence
        super.xorg.libXdamage
        super.libdrm
        super.mesa
        super.gtk4
        # super.libsForQt5.full
      ];
    runtimeDependencies = attrs.runtimeDependencies ++ [ super.gtk4 ];
    installPhase = ''
      mkdir -p $out/bin $out/opt/wavebox
      cp -r * $out/opt/wavebox

      # provide desktop item and icon
      mkdir -p $out/share/applications $out/share/pixmaps
      ln -s ${desktopItem}/share/applications/* $out/share/applications
      ln -s $out/opt/wavebox/wavebox_icon.png $out/share/pixmaps/wavebox.png
      rm $out/opt/wavebox/libqt5_shim.so
    '';
    postFixup = ''
      makeWrapper $out/opt/wavebox/wavebox $out/bin/wavebox \
      --prefix PATH : ${self.xdg_utils}/bin
    '';

  });
}
