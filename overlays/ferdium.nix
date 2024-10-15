self: super:
let
    arch = "amd64";
    version = "6.7.8-nightly.6";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-yNQy/4j11MNObW4B58mjkAXCBwdYcIQxsJ4tdDnL6+w=";
      };
  });
}
