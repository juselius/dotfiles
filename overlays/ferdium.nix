self: super:
let
    arch = "amd64";
    version = "7.0.1";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-e5O8cvQqvymHQiu7kY1AhKfoVOsDLYK8hDX+PKgZPFs=";
      };
  });
}
