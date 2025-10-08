self: super:
let
    arch = "amd64";
    version = "7.1.1";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-1jXo8MMk2EEkLo0n4ICmGJteKProLYKkMF//g63frHs=";
      };
  });
}
