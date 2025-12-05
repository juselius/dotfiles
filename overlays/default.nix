let
  overlays = [
    ./ferdium.nix
    ./fcitx.nix
    # ./kubelogin.nix
    # ./vcluster.nix
    # ./rider.nix
    # ./dotnet-sdk.nix
    # ./linkerd.nix
    # ./vscode.nix
    # ./wavebox.nix
    # ./tilt.nix
  ];
in
builtins.map import overlays
