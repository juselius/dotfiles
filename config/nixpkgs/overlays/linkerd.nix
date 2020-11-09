self: super:
let
  version = "stable-2.9.0";
  srcfile="linkerd2-cli-${version}-Linux-amd64";
in {
  linkerd = super.stdenv.mkDerivation {
      name = "linkerd-${version}";

      src = super.fetchurl {
        url="https://github.com/linkerd/linkerd2/releases/download/${version}/${srcfile}";
        sha256 = "1i4dbfgbdr73svr4raclvbk97ky6km5nybr75294a9hr69p6ch3v";
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
