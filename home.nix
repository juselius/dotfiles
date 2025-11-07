{
  pkgs,
  config,
  ...
}:
let
  extraDesktopPackages =
    if config.dotfiles.desktop.enable then
      with pkgs;
      [
        ferdium
        # zoom-us
        # rider
        # discord
      ]
    else
      [ ];
in
{
  home = {
    username = "nobody";
    homeDirectory = "/home/nobody";

    packages = with pkgs; [ ] ++ extraDesktopPackages;

    keyboard = {
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
  };

  programs = {
    git = {
      userEmail = "";
      userName = "";
    };

    ssh.matchBlocks = {
      example = {
        user = "foo";
        hostname = "acme.com";
      };
    };
  };

  dotfiles = {
    desktop = {
      enable = false;
      wayland.enable = true;
      hyprland = {
        enable = true;
        # monitor = [
        #   "DP-1, preferred, 0x0, 1.25"
        #   "HDMI-A-1, preferred, 2048x0, 1.25"
        # ];
      };
      sway.enable = false;
      dropbox.enable = false;
      onedrive.enable = false;
      laptop = false;
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
        enable = false;
        combined = true;
      };
      node = false;
      rust = false;
      haskell = false;
      python = false;
      go = false;
      java = false;
      clojure = false;
    };
    packages = {
      kubernetes = false;
      cloud = false;
      geo = false;
    };
    fish.vi-mode = false;
    atuin = false;
  };

  services.lorri.enable = true;

  imports = [ ./modules ];
}
