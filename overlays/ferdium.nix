self: super:
let
    arch = "amd64";
    version = "6.7.8-nightly.11";
in
{
  ferdium = super.ferdium.overrideAttrs (attrs: rec {
      inherit version;
      src = super.fetchurl {
        url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
        hash = "sha256-4KJaqws6U0fMW9Jhk+9bAq0I2zm5bJ2z4Q9whsSm900=";
      };
  });
}
