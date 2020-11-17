self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  dotnetCorePackages.sdk_3_1 = super.dotnetCorePackages.sdk_3_1.overrideAttrs (attrs: rec {
    version = "3.1.402";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "2zdb5cl4swg7kvnla6kgnnwg3kkb3rj2ccizg43fw89h8nacr1klz3zdl5km9l553lvm364dy8xsdwm79bw1ch0qgff6snnbbxlw5a2";
    };
  });
  dotnetCorePackages.sdk_5_0 = super.dotnetCorePackages.sdk_3_1.overrideAttrs (attrs: rec {
    version = "5.0.100";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "04rmajjgpzdhimd2zir6qnb07vbibg575xlzgddvfsk3sfplh1w6i71wwjg2bb206jvn927n19zfmmm48xzjgl4zl0wqibw6bxpphxy";
    };
  });
}
