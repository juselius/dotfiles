self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  dotnet-sdk_6 = super.dotnetCorePackages.sdk_6_0.overrideAttrs (attrs: rec {
    version = "6.0.400";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "sha512-jey7oKawlQHa7eUsu1qa6eXzGt4gGRjAPvzRtMw0Xsk0+IMhcE7DvrH5DyIEk0vnJZx29m2SBMvdFZM1gmAnYw==";
    };
  });

# workaround for a bug in nixpkgs
  # dotnetCorePackages.aspnetcore_2_1 = {};
  # dotnetCorePackages.netcore_2_1 = {};
  # dotnetCorePackages.sdk_2_1 = {};
  # dotnetCorePackages.sdk_3_1 = {};
}
