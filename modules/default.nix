{
  nixpkgs.overlays = import ../overlays;
  imports = [
    ./dotfiles.nix
    ./nvim.nix
    ./devel.nix
    ./desktop.nix
    ./packages.nix
    ./wsl.nix
  ];
}
