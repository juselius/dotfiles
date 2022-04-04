{pkgs, lib, config, ...}:
let
  extraDesktopPackages =
    if config.dotfiles.desktop.enable then
      with pkgs; [
        zoom
        wavebox
        rider
        mailspring
      ]
    else [];
in
{
  dotfiles = {
    desktop = {
      enable = false;
      dropbox.enable = false;
      onedrive.enable = false;
      laptop = false;
      xsessionInitExtra = ''
      '';
    };
    packages = {
      devel = {
        enable = true;
        nix = true;
        db = false;
        dotnet = false;
        node = false;
        rust = false;
        haskell = false;
        python = false;
        go = false;
        java = false;
        clojure = false;
      };
      desktop = {
        gnome = true;
        x11 = true;
        media = true;
        chat = true;
        graphics = true;
      };
      kubernetes = true;
      cloud = true;
      geo = false;
    };
    extraDotfiles = [
      "bcrc"
      "codex"
      "ghci"
      "haskeline"
      "taskrc"
    ];
    vimDevPlugins = false;
  };

  home.packages = with pkgs; [
  ] ++ extraDesktopPackages;

  home.keyboard = {
    layout = "us(altgr-intl)";
    model = "pc104";
    options = [
      "eurosign:e"
      "caps:none"
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs = {
    git = {
      userEmail = "jonas.juselius@tromso.serit.no";
      userName = "Jonas Juselius";
      signing = {
        key = "jonas@juselius.io";
      };
    };

    ssh.matchBlocks = {
      example = {
        user = "foo";
        hostname = "acme.com";
      };
    };
  };

  imports = [ ./modules ];
}
