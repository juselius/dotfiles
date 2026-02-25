with import (import ./npins { }).nixpkgs { };
mkShell {
  nativeBuildInputs = [ ];

  buildInputs = [
    npins
  ];
}
