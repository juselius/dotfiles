self: super:
let
  arch = "amd64";
  version = "7.2.2";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
    inherit version;
    src = super.fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
      hash = "sha256-zTJWVv7CHEH3Tg1bDqpxB+Kiraoli1jTvQ9hXn3MOWA=";
    };
  });
}
