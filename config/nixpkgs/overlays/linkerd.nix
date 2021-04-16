self: super:
let
  version = "stable-2.10.1";
  srcfile="linkerd2-cli-${version}-Linux-amd64";
in {
  linkerd = super.stdenv.mkDerivation {
      name = "linkerd-${version}";

      src = super.fetchurl {
        url="https://github.com/linkerd/linkerd2/releases/download/${version}/${srcfile}";
        sha256 = "1jznbanadr94sbqvd5zaw52c5a0y6rxczvama20bm7007q09prbc";
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
