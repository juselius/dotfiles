self: super:
let
  arch = "amd64";
  version = "7.2.3";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
    inherit version;
    src = super.fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
      hash = "sha256-+KP107a8Tmr2qR8pH+gHuXqEqiC5ExPGXoYOqV1Urbo=";
    };
  });
}
