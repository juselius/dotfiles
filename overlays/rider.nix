self: super:
let

  rider-stable = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.1.1";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0p5xn2nj0wfs5d9hcfxx2xs6qgf46k42n68lq53li7kw2nrbl6fs";
      };
  });

  eap = "EAP3-222.2889.22.Checked";
  rider-eap = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.2";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.tar.gz";
        sha256 = "sha256-dPRpv5zWT/B5ETuq6eptVQAOR3YEfe7OxaJGUVmYzOg=";
      };
  });
in
{
  rider = rider-stable;
}
