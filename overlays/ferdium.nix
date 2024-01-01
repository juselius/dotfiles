self: super:
let
    arch = "amd64";
    version = "6.7.0";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-X1wGrxwENEXKhJkY8cg0iFVJTnJzWDs/4jsluq01sZM=";
      };
  });
}
