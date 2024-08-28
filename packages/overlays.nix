# do not move this file to ../overlays, it breaks home-manager badly
let
  overlays = [
    ../overlays/dotnet-sdk.nix
    ../overlays/linkerd.nix
    ## ../overlays/minio-client.nix
    ../overlays/rider.nix
    ##../overlays/teams.nix
    #../overlays/vscode.nix
    # ../overlays/wavebox.nix
    ../overlays/ferdium.nix
    ../overlays/vcluster.nix
    # ../overlays/tilt.nix
    ../overlays/fcitx.nix
  ];
in builtins.map import overlays

