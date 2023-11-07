# nix-prefetch-git https://github.com/tilt-dev/tilt --rev v0.33.5
self: super:
let
  args = rec {
      /* Do not use "dev" as a version. If you do, Tilt will consider itself
        running in development environment and try to serve assets from the
        source tree, which is not there once build completes.  */
      version = "0.33.6";

      src = super.fetchFromGitHub {
        owner = "tilt-dev";
        repo = "tilt";
        rev = "v${version}";
        hash = "sha256-WtE8ExUKFRtdYeg0+My/DB+L/qT+J1EaKHKChNjC5oI=";
      };
  };

 tilt-assets = super.callPackage ./tilt/assets.nix args;
in
{
  untilt = super.tilt.overrideAttrs (attrs: rec {
      version = "0.33.5";

      src = super.fetchFromGitHub {
          owner  = "tilt-dev";
          repo   = attrs.pname;
          rev    = "v${version}";
          sha256 = "10p6qbc890kj50d529zylkz8n7qcpz6ghd78c5fin58a2l9krlas";
      };
  });

  tilt = super.callPackage ./tilt/binary.nix (args // { inherit tilt-assets; });
}

