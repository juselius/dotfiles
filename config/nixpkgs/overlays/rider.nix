self: super:
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.3.1";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0c788xvcd5b9jafz2yyllj1pzgc9ry3pg82qi8glghvimjnk1cfd";
      };
  });
}
