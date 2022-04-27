self: super:
let
  eap = "EAP10-221.5080.209";

  rider-stable = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.1";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0ws66qh3i1fwsd3zzhnswipr8m6nhvrf8blx54bzzx2jyf5h3lp5";
      };
  });

  rider-eap = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.1";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.tar.gz";
        sha256 = "0lkzb3a1ky8cwsnb64bqway9qm62xgaw84vjilbjc2s1znxkfvj7";
      };
  });
in
{
  rider = rider-stable;
}