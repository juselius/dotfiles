{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages;

  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  hie = all-hies.selection { selector = p: { inherit (p) ghc865; }; };

  configuration = {
    nixpkgs.overlays = [ (import ../overlays/dotnet-sdk.nix) ];

    dotfiles.packages.devel = {
      nix = mkDefault true;
    };

    home.packages = enabledPackages;
  };

  base = with pkgs; [
    git
    binutils
    gcc
    gdb
    gnumake
    cmake
    libxml2
    docker_compose
    gettext
    gnum4
    chromedriver # for selenium
    jq
    websocat
    meld
    automake
    autoconf
    libtool
    # sqsh
  ];

  haskell = with pkgs; [
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

  dotnet = {
    home.sessionVariables = {
      DOTNET_ROOT = pkgs.dotnetCorePackages.sdk_5_0;
    };
    home.packages = [
      pkgs.dotnetCorePackages.sdk_5_0
    ];
  };

  python = with pkgs; [
    (python3.withPackages (ps: with ps; [
        numpy
        matplotlib
        tkinter
        virtualenv
      ]))
  ];

  node = with pkgs.nodePackages; [
    pkgs.nodejs
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

  rust = with pkgs; [
    cargo
  ];

  go = with pkgs; [
    go
    go2nix
  ];

  clojure = with pkgs; [
    clooj
    leiningen
  ];

  nix = with pkgs; [
    niv
    lorri
    nix-prefetch-scripts
    patchelf
  ];

  db = with pkgs; [
    postgresql
    sqlite-interactive
  ];

  java = with pkgs; [
    openjdk
    gradle
    ant
  ];

  useIf = x: y: if x then y else [];

  enabledPackages =
    base ++
    useIf cfg.devel.node node ++
    useIf cfg.devel.rust rust ++
    useIf cfg.devel.haskell haskell ++
    useIf cfg.devel.python python ++
    useIf cfg.devel.go go ++
    useIf cfg.devel.clojure clojure ++
    useIf cfg.devel.nix nix ++
    useIf cfg.devel.java java ++
    useIf cfg.devel.db db;
in {
  options.dotfiles.packages = {
    devel = {
      enable = mkEnableOption "Enable development packages";
      dotnet = mkEnableOption "Enable dotnet sdk";
      node = mkEnableOption "Enable Node.js";
      nix = mkEnableOption "Enable nix";
      rust = mkEnableOption "Enable Rust";
      haskell = mkEnableOption "Enable Haskell";
      python = mkEnableOption "Enable Python";
      go = mkEnableOption "Enable Go";
      clojure = mkEnableOption "Enable Clojure";
      java = mkEnableOption "Enable Java";
      db = mkEnableOption "Enable database cli tools";
    };
  };

  config = mkIf cfg.devel.enable (mkMerge [
    configuration
    (mkIf cfg.devel.dotnet dotnet)
  ]);

}
