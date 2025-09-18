{pkgs, lib, config, ...}:
let
  extraDesktopPackages =
    if config.dotfiles.desktop.enable then
      with pkgs; [
        # zoom-us
        # rider
        # ferdium
        # discord
      ]
    else [];
in
{
  home.username = "nobody";
  home.homeDirectory = "/home/nobody";

  home.packages = with pkgs; [
  ] ++ extraDesktopPackages;

  dotfiles = {
    desktop = {
      enable = false;
      wayland.enable = true;
      hyprland = {
        enable = true;
        monitor = [
          # "DP-1, preferred, 0x0, 1.25"
          # "HDMI-A-1, preferred, 2048x0, 1.25"
        ];
      };
      sway.enable = true;
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
        dotnet = {
            enable = true;
            combined = true;
        };
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
      geo = false;
    };
    extraDotfiles = [
      "bcrc"
      "codex"
      "ghci"
      "haskeline"
      "taskrc"
    ];
    vimDevPlugins = true;
    fish.vi-mode = false;
    atuin = false;
  };

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
      userEmail = "jonas.juselius@oceanbox.io";
      userName = "Jonas Juselius";
      signing = {
        key = "jonas.juselius@juselius.io";
      };
    };

    ssh.matchBlocks = {
      example = {
        user = "foo";
        hostname = "acme.com";
      };
    };
  };

  services.lorri.enable = true;

  imports = [ ./modules ];
}
