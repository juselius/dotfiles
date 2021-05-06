self: super:
let
  plat = "linux-x64";
  archive_fmt = "tar.gz";
  # all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  # hie = all-hies.selection { selector = p: { inherit (p) ghc864; }; };
in
{
  vscode = super.vscode.overrideAttrs (attrs: rec {
      version = "1.56.0";
      name = "vscode-${version}";

      src = super.fetchurl {
        name = "VSCode_${version}_${plat}.${archive_fmt}";
        url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
        sha256 = "0v1g7j5q2j86c3r7jib8xs1sf2h3xvwv1s0xsqbig480fchlshjg";
      };

      buildInputs = attrs.buildInputs ++ [ super.xorg.libxshmfence ];
      # src = /home/jonas/Downloads/code-stable-x64.tar.gz;
      # postFixup = ''
      #     wrapProgram $out/bin/code --prefix PATH : ${lib.makeBinPath [hie]}
      # '';
  });
}
