self: super:
let

  rider-stable = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.1.1";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0p5xn2nj0wfs5d9hcfxx2xs6qgf46k42n68lq53li7kw2nrbl6fs";
      };
  });

  eap = "EAP2-222.2680.9.Checked";
  rider-eap = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.2";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.tar.gz";
        sha256 = "1cxkvs2gncf2qcywbcyivw3nikngfvjfig6wbnpc95890yjx2jdm";
      };
  });
in
{
  rider = rider-eap;
}
