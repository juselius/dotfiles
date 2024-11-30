{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.dotfiles.desktop;

  xorg = {
    xsession = {
      enable = true;
      initExtra = ''
        xsetroot -solid '#888888'
        xsetroot -cursor_name left_ptr
        ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings &
        systemctl --user start gvfs-udisks2-volume-monitor.service
        xset s 1800
        xset +dpms
        xset dpms 1800 2400 3600
        xmodmap $HOME/.dotfiles/Xmodmap
      '' + cfg.xsessionInitExtra;
      numlock.enable = true;
    };

    home.packages = with pkgs; [
      networkmanager
      networkmanagerapplet
    ];
  };

  xmonad = {
    home.file.xmobarrc = {
      source = ~/.xmonad/xmobarrc;
      target = ".xmobarrc";
      recursive = false;
    };

    xdg.dataFile = {
      xmonad-desktop = {
        source = ~/.xmonad/Xmonad.desktop;
        target = "applications/Xmonad.desktop";
      };
    };

    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = self: [
        self.yeganesh
        self.xmobar
        pkgs.dmenu
        self.string-conversions
      ];
    };

    home.packages = with pkgs; [
      xmonad-log
      haskellPackages.yeganesh
      xmobar
      dmenu
    ];
  };


  wayland =
  let
    wallpaper = "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";
  in {
    home.sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };

    programs.swaylock = {
      enable = true;
      settings = {
           color = "202020";
           image = wallpaper;
           scaling = "fill";
           font-size = 24;
           indicator-idle-visible = false;
           indicator-radius = 75;
           line-color = "ffffff";
           show-failed-attempts = true;
      };
    };

    home.packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wezterm
      wf-recorder
      wev
      wofi
      wofi-pass
      wlr-randr
      wdisplays
      sway-contrib.grimshot
      clipman
      swaybg
      # networkmanager
      networkmanager_dmenu
      networkmanagerapplet
    ];

    services.mako = {
      enable = true;
      borderSize = 2;
      defaultTimeout = 2500;
    };

  };

in {
  options.dotfiles.desktop = {
    xmonad = {
      enable = mkEnableOption "Enable XMonad";
    };

    wayland = {
      enable = mkEnableOption "Enable wayland";
    };

    xsessionInitExtra = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.xmonad.enable || cfg.i3.enable) xorg)
    (mkIf cfg.xmonad.enable xmonad)
    (mkIf cfg.wayland.enable wayland)
  ];

  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./i3-sway.nix
  ];
}

