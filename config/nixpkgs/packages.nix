{ pkgs, cfg }:
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
    nixos-generators
    utillinux
  ];
  user = [
    gnupg
    tomb
    sshuttle
    minio-client
    openfortivpn
    lorri
    direnv
    byobu
    vault-bin
  ];
  libs = [
    icu
    zlib
    lttng-ust
    libsecret
    libkrb5
  ];
  kubernetes = [
    kubernetes-helm
    kubectl
    linkerd
    # kustomize
  ];
  devel = [
    git
    niv
    patchelf
    binutils
    gcc
    gdb
    cmake
    libxml2
    awscli
    postgresql
    docker_compose
    gnumake
    gradle
    gettext
    nix-prefetch-scripts
    sqlite-interactive
    gnum4
    python37Packages.virtualenv
    chromedriver # for selenium
    jq
    websocat
    # sqsh
    # automake
    # autoconf
    # libtool
  ]
  ++ libs;
  media = [
    guvcview # webcam
    shotcut
    simplescreenrecorder
    audacity
    gcolor3
    xf86_input_wacom
    mpv
  ];
  x11 = with xorg; [
    appres
    editres
    listres
    viewres
    luit
    xdpyinfo
    xdriinfo
    xev
    xfd
    xfontsel
    xkill
    xlsatoms
    xlsclients
    xlsfonts
    xmessage
    xprop
    xvinfo
    xwininfo
    glxinfo
    xclip
    xmessage
    xvinfo
    xmodmap
    xsel
  ];
  gnome = with gnome3; [
    gnome-settings-daemon
    gnome-font-viewer
    adwaita-icon-theme
    gnome-themes-extra
    evince
    gnome-calendar
    gnome-bluetooth
    seahorse
    nautilus
    dconf
    gnome-disk-utility
    gnome-tweaks
    eog
    networkmanager-fortisslvpn
    gnome-keyring
    dconf-editor
    desktop-file-utils
  ];
  desktop = if ! cfg.desktop.enable then [] else ([
    xmonad-log
    dropbox-cli
    wireshark-qt
    glib
    google-chrome
    # googleearth
    firefox
    drive
    meld
    imagemagick
    rdesktop
    remmina
    scrot
    taskwarrior
    # timewarrior
    pass
    tectonic
    pavucontrol
    krita
    spotify
    signal-desktop
    # inkscape
    # ledger
    # slack
    # pidgin
    # pidginsipe
    # vscode
    # browserpass
    blueman
    gparted
    # calibre
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
    unrtf
    # wireshark-cli
    wavebox
    virtmanager
    qrencode
    wkhtmltopdf
    zbar
    haskellPackages.yeganesh
    xmobar
    dmenu
    # zoom-us
    teams
  ]
  ++ gnome
  ++ x11
  ++ media
  ++ []);
  haskell = if ! cfg.devel.haskell.enable then [] else with haskellPackages; [
    ghc
    # stack
    hie
    cabal-install
    hlint
    hoogle
    # cabal2nix
    # alex
    # happy
    # cpphs
    # hscolour
    # haddock
    # pointfree
    # pointful
    # hasktags
    # threadscope
    # hindent
    # codex
    # hscope
    # glirc
  ];
  dotnet = if ! cfg.devel.dotnet.enable then [] else with dotnetCorePackages; [
    # omnisharp-roslyn
    # mono
  ];
  python = if ! cfg.devel.python.enable then [] else with pythonPackages;
     python3.withPackages (ps: with ps; [
      numpy
      matplotlib
      tkinter
    ]);
  node = if ! cfg.devel.node.enable then [] else with nodePackages; [
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
  rust = [
    cargo
  ];
  proton = if ! cfg.proton.enable then []  else [
    protonvpn-cli
    openvpn
    python
    dialog
  ];
  languages = if ! cfg.devel.extraLanguages.enable then []  else [
    idris
    io
    clooj
    leiningen
    go
    go2nix
    # tlaps
  ];
in
  sys
  ++ user
  ++ devel
  ++ desktop
  ++ dotnet
  ++ haskell
  ++ node
  ++ languages
  ++ python
  ++ proton
  ++ kubernetes
  ++ [] # my monoid friend
