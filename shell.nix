with import <nixpkgs> { };
let
  unstable = import (import ./npins { }).unstable { };
in
mkShell {
  nativeBuildInputs = [ ];

  buildInputs = [
    unstable.npins
  ];
}
