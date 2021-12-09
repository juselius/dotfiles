self: super:
let
  eap = "EAP10-213.5744.263.Checked";
in
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.3";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0m1y770dsl8fyrvbmp1b56rka1jhanlxzdbp8pa0jx9fxjr9anmi";
      };
  });

  rider-eap = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.3";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.tar.gz";
        sha256 = "07fihd6cqcvi549wv4lkkhg9yhvvxrk01vr2a3qhlm0ifzgzld5r";
      };
  });
}
