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
      enable = true;
      dropbox.enable = true;
      onedrive.enable = true;
      sway.enable = true;
      laptop = true;
      xsessionInitExtra = ''
        # xrandr --output HDMI-3 --auto --output DP-1 --auto --right-of HDMI-3
      '';
    };
    packages = {
      devel = {
        enable = true;
        nix = true;
        db = false;
        dotnet = true;
        node = true;
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
      geo = true;
    };
    extraDotfiles = [
      "bcrc"
      "codex"
      "ghci"
      "haskeline"
      "taskrc"
    ];
    vimDevPlugins = false;
    fish.vi-mode = true;
  };

  home.packages = with pkgs; [
    openfortivpn
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
      "fs?-?" = {
        user = "root";
        hostname = "%h.itpartner.intern";
      };
      "k?-?" = {
        user = "admin";
        hostname = "%h.itpartner.intern";
      };
      "xor" = {
        user = "admin";
        hostname = "%h.itpartner.intern";
      };
      stokes = {
        hostname = "stokes.regnekraft.io";
      };
      radon = {
        hostname = "radon.chem.helsinki.fi";
      };
      ib-switch-0 = {
        user = "admin";
        hostname = "10.1.60.10";
        extraOptions = {
          KexAlgorithms = "+diffie-hellman-group14-sha1";
        };
      };
      ads1 = {
        user = "root";
        hostname = "10.255.168.199";
      };
        # lambda-by-proxy = {
        #     proxyCommand = "ssh -q jju000@hss.cc.uit.no nc lambda.cc.uit.no 22";
        # };
        # "c*-*" = {
        #     proxyCommand = "ssh -W %h:%p stallo";
        # };
        # stallo-forward = {
        #    hostname = "ssh2.cc.uit.no";
        #    user = "jju000";
        #    extraOptions = {
        #     "PermitLocalCommand" = "yes";
        #     "LocalCommand" =  "ssh stallo.uit.no";
        #    };
        # };
    };
  };

  imports = [ ./modules ];
}
