self: super:
let
  arch = "amd64";
  version = "7.2.1";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
    inherit version;
    src = super.fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
      hash = "sha256-o1GKFkI1GZsO3z4ef10NPT2RGM4f8XUZE2j0OP4h4Io=";
    };
  });
}
