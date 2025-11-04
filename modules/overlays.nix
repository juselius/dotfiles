# do not move this file to ../overlays, it breaks home-manager badly
let
  overlays = [
    ../overlays/rider.nix
    ../overlays/ferdium.nix
    ../overlays/vcluster.nix
    ../overlays/fcitx.nix
    ../overlays/kubelogin.nix
    # ../overlays/dotnet-sdk.nix
    # ../overlays/linkerd.nix
    # ../overlays/vscode.nix
    # ../overlays/wavebox.nix
    # ../overlays/tilt.nix
  ];
in builtins.map import overlays

