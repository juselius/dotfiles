self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  # dotnetCorePackages.sdk_3_1 = super.dotnetCorePackages.sdk_3_1.overrideAttrs (attrs: rec {
  #   version = "3.1.402";
  #   src = super.fetchurl {
  #     url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
  #     sha512 = "2zdb5cl4swg7kvnla6kgnnwg3kkb3rj2ccizg43fw89h8nacr1klz3zdl5km9l553lvm364dy8xsdwm79bw1ch0qgff6snnbbxlw5a2";
  #   };
  # });

  dotnetCorePackages.sdk_5_0 = super.dotnetCorePackages.sdk_3_1.overrideAttrs (attrs: rec {
    version = "5.0.202";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "0w9hgfrbfiiz63bvwqqlkz9nwcm7lagxq6pl10ik7f03yg65mqlcq4y0f9kih7xasaw3fvx1s1rvqjwsm04klkkar08fj8q6vr5kv81";
    };
  });

# workaround for a bug in nixpkgs
  dotnetCorePackages.aspnetcore_2_1 = {};
  dotnetCorePackages.netcore_2_1 = {};
  dotnetCorePackages.sdk_2_1 = {};
  dotnetCorePackages.sdk_3_1 = {};
}
