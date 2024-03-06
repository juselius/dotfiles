{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  configuration = {
    home.packages = enabledPackages;
  };

  cloud = with pkgs; [
    awscli
    minio-client
    vault-bin
    colmena
    k9s
  ];

  geo = with pkgs; [
    netcdf
    # ncview
    # nco
    # qgis
    gdal
  ];

  kubernetes = with pkgs; [
    kubernetes-helm
    kubectl
    linkerd
    step-cli # cert swiss army knife
    kubeseal
    argocd
    starboard
    vcluster
    krew
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
