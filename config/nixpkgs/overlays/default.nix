let
  overlays = [
    ./dotnet-sdk.nix
    ./linkerd.nix
    ./minio-client.nix
    ./rider.nix
    ./teams.nix
    ./vscode.nix
    ./wavebox.nix
  ];

in builtins.map import overlays

