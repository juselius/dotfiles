self: super:
let
    arch = "amd64";
    version = "6.7.6";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-gx8tDGb2yjwexChZGJ9RdVbgseDByFeW2ZR1RebjlO4=";
      };
  });
}
