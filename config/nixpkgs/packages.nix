{ pkgs, options }:
with pkgs;
let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  hie = all-hies.selection { selector = p: { inherit (p) ghc865; }; };
  sys = [
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
  ];
  user = [
    kubernetes-helm
    kubectl
    gnupg
    tomb
    sshuttle
    minio-client
  ];
  devel = [
    git
    patchelf
    binutils
    gcc
    gdb
    cmake
    libxml2
    chromedriver
    awscli
    postgresql
    docker_compose
    gnumake
    gradle
    gettext
    nix-prefetch-scripts
    sqlite-interactive
    # sqsh
    # automake
    # autoconf
    # libtool
  ];
  desktop = if ! options.desktop.enable then [] else [
    dropbox-cli
    wireshark-qt
    xorg.xmodmap
    xorg.xev
    glib
    google-chrome
    # googleearth
    firefox
    drive
    meld
    mplayer
    xorg.xmessage
    xorg.xvinfo
    imagemagick
    rdesktop
    remmina
    scrot
    xsel
    taskwarrior
    # timewarrior
    pass
    tectonic
    pavucontrol
    gimp
    spotify
    gnome3.dconf-editor
    signal-desktop
    inkscape
    # ledger
    # slack
    # pidgin
    # pidginsipe
    vscode
    # browserpass
    calibre
    cargo
    farstream
    freerdp
    fira-code
    keybase
    keybase-gui
    pandoc
    networkmanager
    networkmanagerapplet
    pinentry
    polkit_gnome
    steghide
    cdrtools
    innoextract
    tectonic
    timewarrior
    tlaps
    unrtf
    # wireshark-cli
    xclip
    wavebox
    gnome3.gnome-settings-daemon
    gnome3.gnome-font-viewer
    gnome3.adwaita-icon-theme
    gnome3.gnome-themes-extra
    gnome3.evince
    gnome3.gnome-calendar
    gnome3.gnome-bluetooth
    gnome3.seahorse
    gnome3.nautilus
    gnome3.dconf
    gnome3.gnome-disk-utility
    gnome3.gnome-tweaks
    gnome3.eog
    blueman
    gparted
    virtmanager
    qrencode
    wkhtmltopdf
    zbar
    haskellPackages.yeganesh
    xmobar
    dmenu
  ];
  haskell = if ! options.haskell then [] else with haskellPackages; [
    ghc
    stack
    # hie
    # cabal-install
    # cabal2nix
    # alex
    # happy
    # cpphs
    # hscolour
    # hlint
    # hoogle
    # haddock
    # pointfree
    # pointful
    # hasktags
    # threadscope
    # hindent
    # codex
    # hscope
    # parallel
    # aeson
    # split
    # tasty
    # tasty-hunit
    # tasty-smallcheck
    # contravariant
    # profunctors
    # glirc
  ];
  dotnet = if ! options.dotnet then [] else with dotnetPackages; [
    # mono
    # dotnet-sdk
  ];
  python = if ! options.python then [] else with pythonPackages;
     python3.withPackages (ps: with ps; [
      numpy
      matplotlib
      tkinter
    ]);
  node = if ! options.node then [] else with nodePackages; [
    nodejs
    npm
    yarn
    webpack
    # node2nix
    # gulp
    # bundler
    # bundix
    # yo
    # purescript
    # psc-package
    # pulp
    # cordova
  ];
  proton = if ! options.proton then []  else [
    protonvpn-cli
    openvpn
    python
    dialog
  ];
  languages = if ! options.languages then []  else [
    idris
    io
    clooj
    leiningen
  ];
in
  sys ++
  user ++
  devel ++
  desktop ++
  dotnet ++
  haskell ++
  node ++
  languages ++
  python ++
  proton ++
  []
