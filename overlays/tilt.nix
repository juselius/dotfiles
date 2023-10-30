# nix-prefetch-git https://github.com/tilt-dev/tilt --rev v0.33.5
self: super:
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

  tilt = super.callPackage ./tilt/default.nix {};
}

