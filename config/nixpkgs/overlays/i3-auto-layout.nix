self: super:
let
  lib = super.lib;
  rustPlatform = super.rustPlatform;
  fetchFromGitHub = super.fetchFromGitHub;
in {
  i3-auto-layout = rustPlatform.buildRustPackage rec {
    pname = "i3-auto-layout";
    version = "0.2-fix";

    src = fetchFromGitHub {
      owner = "rengare";
      repo = pname;
      rev = "master";
      sha256 = "16s8v5hm4y34dw77vpsigkzb3fbzh8mxbw6vnq9jxnvy51bmi5c2";
    };

    cargoSha256 = "1zxa6x9wln2lsbpnsgdkszqgdy2j9x4xd7cliacnz6k0cpf3jwnx";

    # Currently no tests are implemented, so we avoid building the package twice
    doCheck = false;

    meta = with lib; {
      description = "Automatic, optimal tiling for i3wm";
      homepage = "https://github.com/chmln/i3-auto-layout";
      license = licenses.mit;
      maintainers = with maintainers; [ mephistophiles ];
      platforms = platforms.linux;
    };
  };
}
