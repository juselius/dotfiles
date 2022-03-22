self: super:
let
  eap = "EAP7-221.5080.29.Checked";
in
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.3.3";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "13q6hk5l3fqmz818z5wj014jd5iglpdcpi8zlpgaim1jg5fpvi8x";
      };
  });

  rider-eap = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.1";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.tar.gz";
        sha256 = "1xd7q56j6ivgr93p9f4mj2lhx94iqswcq8grwg6pfdg424xgilz0";
      };
  });
}
