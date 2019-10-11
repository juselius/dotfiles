{ pkgs }:
with pkgs;
let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  hie = all-hies.selection { selector = p: { inherit (p) ghc865; }; };
  sys = [
    dpkg
    cryptsetup
    fuse
    nmap
    wireshark-qt
    # kubernetes
    #bind
    postgresql
    openldap
    kubernetes-helm
    # dropbox
    dropbox-cli
    xorg.xmodmap
    xorg.xev
    glib
  ];
  user = [
    google-chrome
    # googleearth
    firefox
    drive
    gnupg
    meld
    mplayer
    sshuttle
    xorg.xmessage
    xorg.xvinfo
    imagemagick
    rdesktop
    remmina
    scrot
    xsel
    taskwarrior
    #timewarrior
    pass
    tomb
    tectonic
    pavucontrol
    gimp
    spotify
    minio-client
    gnome3.dconf-editor
    signal-desktop
   # inkscape
   # ledger
   # slack
   # pidgin
   # pidginsipe
  ];
  devel = [
    git
    patchelf
    binutils
    gcc
    gdb
    cmake
    automake
    autoconf
    libtool
    libxml2
    fsharp41
    chromedriver
    awscli
  ];
  haskell = with haskellPackages; [
    ghc
    hie
    cabal-install
    #cabal2nix
    alex
    happy
    cpphs
    hscolour
    hlint
    hoogle
    #haddock
    #pointfree
    #pointful
    #hasktags
    #threadscope
    hindent
    # codex
    # hscope
    stack
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
  dotnet = with dotnetPackages; [
    # fsharp41
    # mono-addins
    mono5
    dotnet-sdk
  ];
  # python27 = with python27Packages; [
  #   python
  #   matplotlib
  #   numpy
  # ];
  node = with nodePackages; [
    nodejs-9_x
    npm
    npm2nix
    node2nix
    gulp
    yarn
    webpack
    # yo
    # purescript
    # psc-package
    # pulp
    # cordova
    bundler
    bundix
  ];
  proton = [
    protonvpn-cli
    openvpn
    python
    dialog
  ];
  eol = [];
in
[
    #browserpass
    calibre
    cargo
    docker_compose
    farstream
    freerdp
    fira-code
    gnumake
    gradle
    gettext
    keybase
    keybase-gui
    # cabal-install
    # cabal2nix
    # haskellPackages.ghc
    # haskellPackages.ghc-mod
    # haskellPackages.glirc
    # haskellPackages.hakyll
    # haskellPackages.hindent
    # haskellPackages.hlint
    # haskellPackages.hpack
    # haskellPackages.stylish-haskell
    pandoc
    # idris
    io
    clooj
    leiningen
    iftop
    networkmanager
    networkmanagerapplet
    nix-prefetch-scripts
    # nixopsUnstable
    nodejs
    openssl
    # pidgin-sipe
    pinentry
    polkit_gnome
    postgresql
    #psc-package
    #purescript
    sqlite-interactive
    #stack
    steghide
    tectonic
    timewarrior
    tlaps
    unrtf
    vimPlugins.idris-vim
    # wireshark-cli
    # wkhtmltopdf
    xclip
    yarn
    vscode
    wavebox
    # mono
    unrar
    sqsh
    inetutils
    haskellPackages.yeganesh
    haskellPackages.xmobar
    dmenu
    kubectl
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
    cdrtools
    dmidecode
    ethtool
    #googleearth
    gparted
    innoextract
    parted
    pciutils
    pwgen
    qrencode
    usbutils
    virtmanager
    wkhtmltopdf
    zbar
] ++
sys ++
user ++
devel ++
dotnet ++
haskell ++
proton ++
# python27 ++
#node ++
#ruby ++
eol
