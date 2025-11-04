{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  useIf = x: y: if x then y else [];

  sys = with pkgs; [
    dpkg
    cryptsetup
    fuse
    nmap
    bind
    openldap
    iftop
    openssl
    inetutils
    unrar
    dmidecode
    ethtool
    parted
    pciutils
    pwgen
    usbutils
    utillinux
    sshfs-fuse
    xkcdpass
    inotify-tools
  ];

  user = with pkgs; [
    gnupg
    tomb
    sshuttle
    direnv
    eza
    ripgrep
    fd
    bat
    procs
    bottom
    du-dust
    duf
    sd
    zellij
    dogdns
    curlie
    xh
    gping
    cheat
    choose
    silver-searcher
    delta
    zoxide
    tealdeer
    pay-respects
  ];

  cloud = with pkgs; [
    awscli
    minio-client
    colmena
    azure-cli
    dapr-cli
    openfga-cli
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
    # starboard
    vcluster
    krew
    k9s
    hubble
    kubelogin
    cilium-cli
    talosctl
  ];


  configuration = {
    home.packages =
      sys ++
      user ++
      useIf cfg.cloud cloud ++
      useIf cfg.kubernetes kubernetes ++
      useIf cfg.geo geo;
  };

in {
  options.dotfiles.packages = {
    cloud = mkEnableOption "Enable cloud cli tools";
    kubernetes = mkEnableOption "Enable Kuberntes cli tools";
    geo = mkEnableOption "Enable geo tools";
  };

  config = mkMerge [ configuration ];
}
