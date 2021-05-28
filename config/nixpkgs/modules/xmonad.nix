{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.dotfiles.desktop.xmonad;

  configuration = {
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

    dotfiles.desktop.polybar.enable = mkDefault true;

    xsession = {
      enable = true;
      initExtra = ''
        xrandr --output HDMI-3 --auto --output DP-1 --auto --right-of HDMI-3
        xsetroot -solid '#888888'
        xsetroot -cursor_name left_ptr
        ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings &
        systemctl --user start gvfs-udisks2-volume-monitor.service
        xset s 1800
        xset +dpms
        xset dpms 1800 2400 3600
        xmodmap $HOME/.dotfiles/Xmodmap
      '';
      numlock.enable = true;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = self: [
          self.yeganesh
          self.xmobar
          pkgs.dmenu
          self.string-conversions
        ];
      };
    };

    home.packages = with pkgs; [
      xmonad-log
      haskellPackages.yeganesh
      xmobar
      networkmanager
      networkmanagerapplet
      dmenu
    ];
  };
in {
  options.dotfiles.desktop.xmonad = {
    enable = mkEnableOption "Enable XMonad";
  };

  config = mkIf cfg.enable configuration;

  imports = [ ./polybar.nix ];
}

