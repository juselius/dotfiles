{
  nixpkgs.overlays = import ./overlays.nix;
  imports = [
    ./dotfiles.nix
    ./nvim.nix
    ./devel.nix
    ./desktop.nix
    ./packages.nix
    ./wsl.nix
  ];
}
