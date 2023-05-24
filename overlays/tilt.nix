self: super:
{
  tilt = super.tilt.overrideAttrs (attrs: rec {
      version = "0.32.3";

      src = super.fetchFromGitHub {
          owner  = "tilt-dev";
          repo   = attrs.pname;
          rev    = "v${version}";
          sha256 = "sha256-5QTZUapHhSSI+UZu77IUZdflCIm+oCu4kPQVhLHCsUQ=";
      };
  });
}
