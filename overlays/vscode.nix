self: super:
let
  plat = "linux-x64";
  archive_fmt = "tar.gz";
  # all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  # hie = all-hies.selection { selector = p: { inherit (p) ghc864; }; };
in
{
  vscode = super.vscode.overrideAttrs (attrs: rec {
      version = "1.66.2";
      name = "vscode-${version}";

      src = super.fetchurl {
        name = "VSCode_${version}_${plat}.${archive_fmt}";
        url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
        sha256 = "1si0r8nww5m3yn3vzw0pk3nykfvxnlwna4pp11bsli4vqj1ym2nz";
      };

      buildInputs = attrs.buildInputs ++ [ super.xorg.libxshmfence ];

      postPatch = builtins.replaceStrings [ "vscode-ripgrep" ] [ "@vscode/ripgrep" ] attrs.postPatch;
      # postFixup = ''
      #     wrapProgram $out/bin/code --prefix PATH : ${lib.makeBinPath [hie]}
      # '';
  });
}
