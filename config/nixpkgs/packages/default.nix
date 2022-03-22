{
  nixpkgs.overlays = import ../overlays;
  imports = [
    ./base.nix
    ./devel.nix
    ./desktop.nix
    ./misc.nix
  ];
}
