self: super:
let
  plat = "linux-x64";
  archive_fmt = "tar.gz";
  # all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  # hie = all-hies.selection { selector = p: { inherit (p) ghc864; }; };
in
{
  vscode = super.vscode.overrideAttrs (attrs: rec {
      version = "1.42.1";
      name = "vscode-${version}";

      src = super.fetchurl {
        name = "VSCode_${version}_${plat}.${archive_fmt}";
        url = "https://vscode-update.azurewebsites.net/${version}/${plat}/stable";
        sha256 = "0c067qp3aa5kqya3y8pzc9cvyzsafizhgjp9dsibnfl08lvz9hbs";
      };
      # postFixup = ''
      #     wrapProgram $out/bin/code --prefix PATH : ${lib.makeBinPath [hie]}
      # '';
  });
}
