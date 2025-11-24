let
  overlays = [
    ./ferdium.nix
    ./vcluster.nix
    ./fcitx.nix
    ./kubelogin.nix
    # ./rider.nix
    # ./dotnet-sdk.nix
    # ./linkerd.nix
    # ./vscode.nix
    # ./wavebox.nix
    # ./tilt.nix
  ];
in
builtins.map import overlays
