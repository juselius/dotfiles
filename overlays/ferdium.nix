self: super:
let
    arch = "amd64";
    version = "7.0.0";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-Ey2FhekQVSYB0ki4U3HyuKs/URgtZMCl41jkPsZMNrQ=";
      };
  });
}
