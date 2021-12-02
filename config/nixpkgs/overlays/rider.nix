self: super:
let
  eap = "EAP10-213.5744.263.Checked";
in
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.2.2";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "17xx8mz3dr5iqlr0lsiy8a6cxz3wp5vg8z955cdv0hf8b5rncqfa";
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
