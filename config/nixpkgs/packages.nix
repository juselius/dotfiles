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
    nixos-generators
    utillinux
  ];
  user = [
    kubernetes-helm
    kubectl
    gnupg
    tomb
    sshuttle
    minio-client
    openfortivpn
    lorri
    direnv
    byobu
  ];
  libs = [
    icu
    zlib
    lttng-ust
    libsecret
    libkrb5
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
    chromedriver
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
  desktop = if ! options.desktop.enable then [] else ([
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
    inkscape
    # ledger
    # slack
    # pidgin
    # pidginsipe
    vscode
    # browserpass
    blueman
    gparted
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
    wavebox
    virtmanager
    qrencode
    wkhtmltopdf
    zbar
    haskellPackages.yeganesh
    xmobar
    dmenu
    zoom-us
    teams
  ]
  ++ gnome
  ++ x11
  ++ media
  ++ []);
  haskell = if ! options.haskell then [] else with haskellPackages; [
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
  dotnet = if ! options.dotnet then [] else with dotnetCorePackages; [
    sdk_3_1
    omnisharp-roslyn
    # mono
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
    go
    go2nix
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
  ++ [] # my monoid friend
