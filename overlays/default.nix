let
  overlays = [
    ./ferdium.nix
    ./rider.nix
    ./fcitx.nix
    # ./kubelogin.nix
    # ./vcluster.nix
    # ./dotnet-sdk.nix
    # ./linkerd.nix
    # ./vscode.nix
    # ./wavebox.nix
    # ./tilt.nix
  ];
in
builtins.map import overlays
