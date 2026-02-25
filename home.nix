{
  pkgs,
  config,
  ...
}:
let
  sources = import ./npins;
  unstable = import sources.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  username = "";
  fullname = "";
  email = "";

  keyboard = "us(altgr-intl)";
  extraDesktopPackages =
    if config.dotfiles.desktop.enable then
      with pkgs;
      [
        zoom-us
        ferdium
        unstable.jetbrains.rider
      ]
    else
      [ ];
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    packages =
      with pkgs;
      [
        python3
      ]
      ++ extraDesktopPackages;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  dotfiles = {
    keyboard = {
      layout = keyboard;
      model = "pc104";
      options = [
        "eurosign:e"
        "caps:none"
      ];
    };

    desktop = {
      enable = false;
      laptop = false;
      wayland.enable = true;
      hyprland = {
        enable = true;
        # monitor = [
        #   "DP-1, preferred, 0x0, 1.25"
        #   "HDMI-A-1, preferred, 2048x0, 1.25"
        # ];
      };
      noctalia-shell.enable = true;
      waybar.enable = false;
      sway.enable = false;
      dropbox.enable = false;
      onedrive.enable = false;
      cursorSize = 24;
      packages = {
        gnome = true;
        x11 = false;
        media = true;
        chat = true;
        graphics = true;
      };
    };
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
    packages = {
      kubernetes = true;
      cloud = true;
      geo = true;
    };
    fish.vi-mode = false;
    atuin = false;
  };

  services.lorri.enable = true;

  programs = {
    git.settings = {
      user = {
        inherit email;
        name = fullname;
      };
    };
    difftastic = {
      enable = false;
      git = {
        enable = true;
        diffToolMode = true;
      };
    };

    ssh.matchBlocks = {
      example = {
        user = "nobody";
        hostname = "acme.com";
      };
    };
  };

  imports = [ ./modules ];
}
