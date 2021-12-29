self: super:
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.3.2";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0arnh9wlw874jqlgad00q0nf1kjp7pvb4xixwrb6v1l9fbr9nsan";
      };
  });
}
