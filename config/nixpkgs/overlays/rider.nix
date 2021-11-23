self: super:
let
  eap = "EAP9-213.5744.160.Checked";
in
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.3";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.tar.gz";
        sha256 = "0n9wfgbgplvywp7vy36saxv5xd8rq85hbqs1sr88j78a448ldlw6";
      };
  });
}
