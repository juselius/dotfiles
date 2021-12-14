self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  # dotnetCorePackages.sdk_6_0 = super.dotnetCorePackages.sdk_6_0.overrideAttrs (attrs: rec {
  #   version = "6.0.100";
  #   src = super.fetchurl {
  #     url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
  #     sha512 = "1dz46ngv255lldgvgyad85jdhq360yw3zayzc449q8f1y92120yrfp0ql4vr639mqazxhgngj7xlyd4lvdlbdk148q4qafng551f3fb";
  #   };
  #   buildInputs = attrs.buildInputs ++ [ super.icu ];
  # });

# workaround for a bug in nixpkgs
  # dotnetCorePackages.aspnetcore_2_1 = {};
  # dotnetCorePackages.netcore_2_1 = {};
  # dotnetCorePackages.sdk_2_1 = {};
  # dotnetCorePackages.sdk_3_1 = {};
}
