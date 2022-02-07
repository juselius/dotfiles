{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  configuration = {
    home.packages = enabledPackages;
  };

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
  ];

  user = with pkgs; [
    gnupg
    tomb
    sshuttle
    direnv
    exa
    ripgrep
    fd
    bat
    procs
    bottom
    du-dust
    duf
    sd
    zellij
    dog
    curlie
    xh
    gping
    tldr
    cheat
    choose
    ag
    delta
  ];

  enabledPackages =
    sys ++
    user;
in {
  options.dotfiles.packages = {};

  config = configuration;
}
