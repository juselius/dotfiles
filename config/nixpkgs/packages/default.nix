{
  nixpkgs.overlays = import ./overlays.nix;
  imports = [
    ./base.nix
    ./devel.nix
    ./desktop.nix
    ./misc.nix
  ];
}
