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

  i3 =
    let
      base00 = "#101218";
      base01 = "#1f222d";
      base02 = "#252936";
      base03 = "#7780a1";
      base04 = "#C0C5CE";
      base05 = "#d1d4e0";
      base06 = "#C9CCDB";
      base07 = "#ffffff";
      base08 = "#ee829f";
      base09 = "#f99170";
      base0A = "#ffefcc";
      base0B = "#a5ffe1";
      base0C = "#97e0ff";
      base0D = "#97bbf7";
      base0E = "#c0b7f9";
      base0F = "#fcc09e";
    in {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        window.titlebar = false;
        # terminal = "alacritty --working-directory $($HOME/nixos-configuration/get-last-location.sh)";
        terminal = "alacritty";
        modifier = "Mod4";  # this is the "windows" key
        defaultWorkspace = "workspace number 1";
        assigns = {
          "1" = [
            { class = "^Mailspring$"; }
            { class = "^Microsoft Teams - Preview"; }
          ];
          "2" = [
            { class = "^Firefox$"; }
            { class = "^google-chrome$"; }
          ];
        };
        floating.criteria = [ { title = "^zoom$"; } ];
        bars = [{
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
            style = "Normal";
            size = 9.0;
          };
          colors = {
            separator  = base03;
            background = base01;
            statusline = base05;
            focusedWorkspace  = { background = base01; border = base01; text = base07; };
            activeWorkspace   = { background = base01; border = base02; text = base03; };
            inactiveWorkspace = { background = base01; border = base01; text = base03; };
            urgentWorkspace   = { background = base01; border = base01; text = base08; };
          };
        }];
        modes.resize = {
          Up = "resize shrink height 5 px or 5 ppt";
          Down = "resize grow height 5 px or 5 ppt";
          Left = "resize shrink width 5 px or 5 ppt";
          Right = "resize grow width 5 px or 5 ppt";
          Escape = "mode default";
          Return = "mode default";
        };
        startup = [
          { command = "${pkgs.i3-auto-layout}/bin/i3-auto-layout"; always = true; notification = false; }
        ];
        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
            switch = n: "exec --no-startup-id ${pkgs.i3-wk-switch}/bin/i3-wk-switch ${n}";
            switches =
              builtins.foldl' (a: x:
                a // { "${mod}+${x}" = switch x; }
              ) {} (builtins.genList (x: toString x) 10);
          in lib.mkOptionDefault {
            "${mod}+1" = switch "1";
            "${mod}+2" = switch "2";
            "${mod}+3" = switch "3";
            "${mod}+4" = switch "4";
            "${mod}+5" = switch "5";
            "${mod}+6" = switch "6";
            "${mod}+7" = switch "7";
            "${mod}+8" = switch "8";
            "${mod}+9" = switch "9";
            "${mod}+0" = switch "0";

            "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -n -c 111111";
            "${mod}+Ctrl+s" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
            "${mod}+Ctrl+n" = "exec --no-startup-id ${pkgs.gnome3.nautilus}/bin/nautilus";

            # Pulse Audio controls
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
            "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";

            # Sreen brightness controls
            "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 20";
            "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 20";

            # Media player controls
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
            "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          };
      };
    };

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks = [
            {
              block = "disk_space";
              path = "/";
              alias = "/";
              info_type = "available";
              unit = "GB";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
            }
            # {
            #   block = "temperature";
            # }
            (if config.dotfiles.desktop.laptop then {
              block = "battery";
              allow_missing = true;
            } else {})
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{mem_used_percents}";
              format_swap = "{swap_used_percents}";
            }
            {
              block = "cpu";
              interval = 1;
              format = "{utilization} {frequency}";
            }
            {
              block = "net";
              interval = 2;
              hide_inactive = true;
            }
            {
              block = "load";
              interval = 1;
              format = "{1m}";
            }
            { block = "sound"; }
            {
              block = "time";
              interval = 60;
              format = "%a %d/%m %R";
            }
          ];
          settings = {
            theme =  {
              name = "nord-dark";
              overrides = {
                idle_bg = base01;
                # idle_fg = "#abcdef";
              };
            };
          };
          icons = "awesome5";
          theme = "nord-dark";
        };
      };
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

