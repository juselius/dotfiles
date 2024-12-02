self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
   dotnet-sdk_9x = super.dotnetCorePackages.sdk_9_0.overrideAttrs (attrs: rec {
     version = "9.0.100";
     src = super.fetchurl {
       url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
       sha256 = "sha256-TJcayAYV+qgG3oLwqzBz5QrrtAK3msJlq5d2XJop7VY=";
     };
  });
}
