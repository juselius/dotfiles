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

    dotfiles.desktop.polybar.enable = mkDefault true;

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

  i3 = {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        window.titlebar = false;
        # terminal = "alacritty --working-directory $($HOME/nixos-configuration/get-last-location.sh)";
        terminal = "alacritty";
        modifier = "Mod4";  # this is the "windows" key
        defaultWorkspace = "workspace number 1";
        assigns = {
          "2:" = [{ class = "^Firefox$"; }];
        };
        bars = [{
          position = "top";
        }];
        floating.criteria = [ { title = "^zoom$"; } ];
        startup = [
          { command = "${pkgs.i3-auto-layout}/bin/i3-auto-layout"; always = true; notification = false; }
        ];
        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
            switch = n: "exec --no-startup-id ${pkgs.i3-wk-switch}/bin/i3-wk-switch ${toString n}";
            wk_switch =
              builtins.foldl' (a: x:
                a // { "${mod}+${x}" = switch x; }
              ) {} (builtins.genList (x: toString x) 10);
          in lib.mkOptionDefault {
            "${mod}+1" = switch 1;
            "${mod}+2" = switch 2;
            "${mod}+3" = switch 3;
            "${mod}+4" = switch 4;
            "${mod}+5" = switch 5;
            "${mod}+6" = switch 6;
            "${mod}+7" = switch 7;
            "${mod}+8" = switch 8;
            "${mod}+9" = switch 9;
            "${mod}+0" = switch 0;
          };
      };
    };

    programs.i3status-rust = {
      enable = true;
    };

    home.packages = with pkgs; [
      dmenu
      i3lock
      i3-wk-switch
      i3-auto-layout
    ];
  };

in {
  options.dotfiles.desktop = {
    xmonad = {
      enable = mkEnableOption "Enable XMonad";
    };

    i3 = {
      enable = mkEnableOption "Enable i3";
    };

    xsessionInitExtra = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.xmonad.enable || cfg.i3.enable) xorg)
    (mkIf cfg.xmonad.enable xmonad)
    (mkIf cfg.i3.enable i3)
  ];

  imports = [ ./polybar.nix ];
}

