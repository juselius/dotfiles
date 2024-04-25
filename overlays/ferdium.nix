self: super:
let
    arch = "amd64";
    version = "6.7.3";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-Q5fUMQQTQKgUkakmsiBFH2UwJdk/XV8wpQi6uRHi90U=";
      };
  });
}
