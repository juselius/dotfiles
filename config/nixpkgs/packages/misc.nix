{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  configuration = {
    nixpkgs.overlays = [
      (import ../overlays/linkerd.nix)
      (import ../overlays/minio-client.nix)
    ];

    home.packages = enabledPackages;
  };

  cloud = with pkgs; [
    awscli
    minio-client
    vault-bin
  ];

  geo = with pkgs; [
    ncview
    netcdf
    nco
  ];

  kubernetes = with pkgs; [
    kubernetes-helm
    kubectl
    linkerd
  ];

  useIf = x: y: if x then y else [];

  enabledPackages =
    useIf cfg.cloud cloud ++
    useIf cfg.kubernetes kubernetes ++
    useIf cfg.geo geo;
in {
  options.dotfiles.packages = {
    cloud = mkEnableOption "Enable cloud cli tools";
    kubernetes = mkEnableOption "Enable Kuberntes cli tools";
    geo = mkEnableOption "Enable geo tools";
  };

  config = configuration;

}
