self: super:
let
  arch = "amd64";
  version = "7.2.0";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
    inherit version;
    src = super.fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
      hash = "sha256-Gk9Swdk6jDoN8UzmdPnoslzrvN+7H5y//HPeB5GqEY8=";
    };
  });
}
