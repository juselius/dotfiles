self: super:
let
    arch = "amd64";
  version = "1.31.0";
in {
  kubelogin = super.stdenv.mkDerivation {
      name = "kubelogin-${version}";

      src = super.fetchurl {
        url = "https://github.com/int128/kubelogin/releases/download/v${version}/kubelogin_linux_${arch}.zip";
        hash = "sha256-bPPPqmuBMF67yDzxEZ+mDAefbNl1apuvQWkQO4Ee+Gs=";
      };

      buildCommand = ''
        . $stdenv/setup

        mkdir -p $out/bin
        cd $out/bin
        unzip $src
        rm LICENSE README.md
        ln -s kubelogin kubectl-oidc_login
      '';

      buildInputs = with super; [ unzip ];
  };
}
