# nix-prefetch-git https://github.com/tilt-dev/tilt --rev v0.33.5
self: super:
{
  panoply = super.panoply.overrideAttrs (attrs: rec {
      version = "5.2.9";

      src = super.fetchurl {
          url = "https://www.giss.nasa.gov/tools/panoply/download/PanoplyJ-${version}.tgz";
          sha256 = "sha256-InnHiaPvSCCtRmWStyrYQMhNQnoG+lhSBe7ECrPFKFc=";
      };
  });
}
