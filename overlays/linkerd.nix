self: super:
let
  version = "stable-2.12.0";
  srcfile="linkerd2-cli-${version}-Linux-amd64";
in {
  linkerd = super.stdenv.mkDerivation {
      name = "linkerd-${version}";

      src = super.fetchurl {
        url="https://github.com/linkerd/linkerd2/releases/download/${version}/${srcfile}";
        sha256 = "sha256-nGCARKoRvezXkxUcvqRfEu2H2aiROre+F5Xns8mTRyQ=";
      };

      buildCommand = ''
        . $stdenv/setup

        mkdir -p $out/bin
        cp $src $out/bin/${srcfile}
        chmod 755 $out/bin/${srcfile}
        ln -s $out/bin/${srcfile} $out/bin/linkerd
      '';

      buildInputs = with super; [ curl ];
    };
}
