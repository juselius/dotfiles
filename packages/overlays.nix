# do not move this file to ../overlays, it breaks home-manager badly
let
  overlays = [
    ../overlays/dotnet-sdk.nix
    ../overlays/linkerd.nix
    ../overlays/rider.nix
    ../overlays/vscode.nix
    ../overlays/ferdium.nix
    ../overlays/vcluster.nix
    ../overlays/fcitx.nix
    ../overlays/kubelogin.nix
    # ../overlays/wavebox.nix
    # ../overlays/tilt.nix
  ];
in builtins.map import overlays

