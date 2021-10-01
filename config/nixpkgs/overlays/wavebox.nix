self: super:
with super.lib;
let
  # version = "10.0.554-2";
  version = "10.94.17-2";
  tarball = "Wavebox_${version}.tar.gz";
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
      url = "https://download.wavebox.app/stable/linux/tar/${tarball}";
      sha256 = "197hx9nbyxxvwf5mw9k6x16h31a8y9yyz2c5q3axdx4z54c9fxqm";
    };
    buildInputs =
      attrs.buildInputs ++ [
        super.xorg.libxshmfence
        super.xorg.libXdamage
        super.libdrm
        super.mesa
        super.gtk4
      ];
    runtimeDependencies = attrs.runtimeDependencies ++ [ super.gtk4 ];
    installPhase = ''
      mkdir -p $out/bin $out/opt/wavebox
      cp -r * $out/opt/wavebox

      # provide desktop item and icon
      mkdir -p $out/share/applications $out/share/pixmaps
      ln -s ${desktopItem}/share/applications/* $out/share/applications
      ln -s $out/opt/wavebox/wavebox_icon.png $out/share/pixmaps/wavebox.png
    '';
    postFixup = ''
      makeWrapper $out/opt/wavebox/wavebox $out/bin/wavebox \
      --prefix PATH : ${self.xdg_utils}/bin
    '';

  });
}
