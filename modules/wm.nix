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

  i3-sway =
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
      wallpaper = "${pkgs.nixos-artwork.wallpapers.binary-blue}/share/backgrounds/nixos/nix-wallpaper-binary-blue.png";
    in {
      config = {
        window.titlebar = false;
        # terminal = "alacritty --working-directory $($HOME/nixos-configuration/get-last-location.sh)";
        terminal = "wezterm";
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
        focus.mouseWarping = false;
        bars = [{
          id = "top";
          position = "top";
          trayOutput = cfg.i3.trayOutput;
          # statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          command = "${pkgs.waybar}/bin/waybar";
          fonts = {
            names = [ "DejaVu Sans Mono" "FontAwesome5Free" "FontAwesome" "JetBrainsMono" ];
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
          { command = "${pkgs.autotiling}/bin/autotiling"; always = false; }
          { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        ] ++ (if cfg.wayland.enable then
            [ { command =
             "${pkgs.swaybg}/bin/swaybg -c '#444444' -i ${wallpaper} -m fill"; always = false; }
             { command = ''
                  swayidle timeout 900 'swaylock -c 111111' \
                           timeout 180 'swaymsg "output * dpms off"' \
                           resume 'swaymsg "output * dpms on"' \
                           before-sleep 'swaylock' ''; always = false; }
           ] else []);
        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
            switch = n: "exec --no-startup-id ${pkgs.i3-wk-switch}/bin/i3-wk-switch ${n}";
            switches =
              builtins.foldl' (a: x:
                a // { "${mod}+${x}" = switch x; }
              ) {} (builtins.genList (x: toString x) 10);
          in lib.mkOptionDefault ({
            "${mod}+1" = switch "1";
            "${mod}+2" = switch "2";
            "${mod}+3" = switch "3";
            "${mod}+4" = switch "4";
            "${mod}+5" = switch "5";
            "${mod}+6" = switch "6";
            "${mod}+7" = switch "7";
            "${mod}+8" = switch "8";
            "${mod}+9" = switch "9";
            "${mod}+0" = switch "10";

            "${mod}+d"= "exec $(${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop)";
            # "${mod}+d"= "exec $(${pkgs.haskellPackages.yeganesh}/bin/yeganesh -x -- -fn 'DejaVu Sans Mono-11' -nb white -nf black)";
            # "${mod}+d"= "exec $(${pkgs.ulauncher}/bin/ulauncher)";

            "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -n -c 111111";
            # "${mod}+Ctrl+s" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
            "Print" = "exec grimshot savecopy anything";
            "${mod}+Ctrl+n" = "exec --no-startup-id ${pkgs.gnome3.nautilus}/bin/nautilus";

            # Pulse Audio controls
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

            # Sreen brightness controls
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";

            # Media player controls
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
            "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          }
          // (if cfg.wayland.enable then
              {
                "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.swaylock}/bin/swaylock";
                "${mod}+Shift+r" = "exec --no-startup-id ${pkgs.sway}/bin/sway reload";
              }
              else {})
        );
      };


    i3status-rust =
      let
          first-block = [
            {
              block = "cpu";
              interval = 1;
              format = " $icon $utilization";
              format_alt = " $icon $frequency{ $boost|} ";
            }
            {
              block = "load";
              interval = 1;
              format = " $icon $1m.eng(w:4) ";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents.eng(w:1) ";
              format_alt = " $icon_swap $swap_free.eng(w:3,u:B,p:M)/$swap_total.eng(w:3,u:B,p:M)($swap_used_percents.eng(w:2)) ";
              interval = 30;
              warning_mem = 70;
              critical_mem = 70;
            }
            {
              block = "disk_space";
              path = "/";
              interval = 60;
              warning = 10.0;
              alert = 5.0;
              info_type = "available";
            }
            {
              block = "net";
              interval = 2;
              inactive_format = " $icon down ";
            }
          ];
          time = {
              block = "time";
              interval = 60;
              format = " $timestamp.datetime(f:' %d-%m-%Y %R') ";
          };
          temperature = {
              block = "temperature";
              format = " $icon $max ";
              format_alt = " $icon $max ($average) ";
              interval = 10;
              chip = "*-isa-*";
          };
          last-block =
              if cfg.laptop then
              [
                  {
                      block = "battery";
                      format = " $icon $percentage {$time |}";
                      device = "DisplayDevice";
                      driver = "upower";
                  }
                  {
                      block = "backlight";
                      device = "intel_backlight";
                  }
                  time
              ]
              else [
                  time
                  # { block = "sound"; }
              ];
      in {
      enable = true;
      bars = {
        top = {
          blocks = first-block ++ last-block;

          settings = {
            theme =  {
              theme = "nord-dark";
              overrides = {
                idle_bg = base01;
                # idle_fg = "#abcdef";
              };
            };
            icons = {
              icons = "awesome5";
            };
          };
        };
      };
    };

    home.packages = with pkgs; [
      dmenu
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
    ];

    programs.qt5ct.enable = true;
  };

  waybar = {
    programs.waybar = {
      enable = true;
      style = builtins.readFile ./waybar.css;
      settings = {
        mainBar =
          let
            baseBar = {
              layer = "bottom";
              position = "top";
              height = 30;

              modules-left = [
                "sway/workspaces"
              ];
              modules-center = [ "sway/window" ];
              modules-right = [
                (if cfg.laptop then "battery" else "")
                "disk"
                "cpu"
                "memory"
                "idle_inhibitor"
                "wireplumber"
                "network"
                "clock"
                "tray"
            ];

            "sway/window" = {
              format = "{title}";
              max-length = 50;
              # NOTE: Long dash used by some sway windows: —
              rewrite = {
                "(.*) — Mozilla Firefox" = "󰈹 $1";
                "(.*) - Discord" = "  $1";
                "Ferdium - (.*)" = " $1";
              };
            };

            "tray" = {
              icon-size = 20;
              spacing = 10;
            };

            "clock" = {
              format = "  {:%a %d/%m %R}";
              interval = 60;
            };

            "network" = {
              format-wifi = " ";
              format-ethernet = "󰛳 ";
              format-disconnected = "󰲛 ";
              tooltip-format-wifi = "{essid} ({signalStrength}%)";
              tooltip-format-ethernet = "{ifname}";
              # TODO: Pass in terminal emulator as a binding for better modularity
              on-click = "networkmanager_dmenu";
              max-length = 20;
            };

            "wireplumber" = {
              format = "{icon}  {volume}% ";
              format-muted = "󰝟 ";
              format-icons = [
                " "
                " "
                " "
              ];
              on-click = "pavucontrol";
            };

            "memory" = {
              format = "   {}%";
              interval = 5;
              on-click = "alacritty -e btop";
            };

            "cpu" = {
              format = "   {usage}%";
              interval = 5;
              on-click = "alacritty -e btop";
            };

            "disk" = {
              format = "󰆼   {free}";
              unit = "GB";
              interval = 30;
            };

            "idle_inhibitor" = {
              format = "{icon} ";
              format-icons = {
                activated = "󰒳 ";
                deactivated = "󰒲 ";
              };
            };
          };
          laptopModules = {
            "battery" = {
              format = "{icon}  {capacity}%";
              format-icons = [
                "<span color='#dd532e'></span>"
                "<span color='#ffffa5'></span>"
                "<span color='#ffffff'></span>"
                "<span color='#ffffff'></span>"
                "<span color='#ffffff'></span>"
              ];
              interval = 60;
            };
          };
      in
        lib.mkMerge [
          baseBar
          (lib.mkIf cfg.laptop laptopModules)
        ];
      };
    };
  };

  i3 = {
    xsession.windowManager.i3 = {
      enable = true;
      config = i3-sway.config;
    };

    programs.i3status-rust = i3-sway.i3status-rust;

    home.packages = with pkgs; [
      i3lock
      # haskellPackages.yeganesh
      ulauncher
      dmenu
    ];
  };

  sway = {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true ;
      config = i3-sway.config // {
        output = cfg.sway.output;
        input = {
          "*" = {
            xkb_layout = "us(altgr-intl)";
            xkb_model = "pc104";
            xkb_options = "eurosign:e,caps:none";
          };
        };
      };
    };
  };

  river = {
    wayland.windowManager.river = {
      enable = true;
      settings =               {
        border-width = 2;
        declare-mode = [
          "locked"
          "normal"
          "passthrough"
        ];
        input = {
          pointer-foo-bar = {
            accel-profile = "flat";
            events = true;
            pointer-accel = -0.3;
            tap = false;
          };
        };
        map = {
          normal = {
            "Alt Q" = "close";
          };
        };
        rule-add = {
          "-app-id" = {
            "'bar'" = "csd";
            "'float*'" = {
              "-title" = {
                "'foo'" = "float";
              };
            };
          };
        };
        set-cursor-warp = "on-output-change";
        set-repeat = "50 300";
        spawn = [
          "firefox"
          "'foot -a terminal'"
        ];
        xcursor-theme = "someGreatTheme 12";
      };
    };
  };

  hyprland = {
    wayland.windowManager.hyprland = {
      enable = true;
      settings =               {
         decoration = {
           shadow_offset = "0 5";
           "col.shadow" = "rgba(00000099)";
         };

         "$mod" = "SUPER";
         "$terminal" = "wezterm";
         "$fileManager" = "dolphin";
         "$menu" = "wofi --show drun";

         exec-once = "waybar & hyprpaper & firefox";
         bindm = [
           # mouse movements
           "$mod, Enter, exec, $terminal"
           "$mod, D, exec, $menu"
           "$mod, mouse:272, movewindow"
           "$mod, mouse:273, resizewindow"
           "$mod ALT, mouse:272, resizewindow"
         ];
       };
    };

    services.mako = {
      enable = true;
      borderSize = 2;
      defaultTimeout = 2500;
    };
  };

  wayland =
  let
    wallpaper = "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";
  in
  {
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
      wofi
      wlr-randr
      wdisplays
      sway-contrib.grimshot
      clipman
      swaybg
      networkmanager
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

    i3 = {
      enable = mkEnableOption "Enable i3";
      trayOutput = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    sway = {
      enable = mkEnableOption "Enable sway";
      trayOutput = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      output = mkOption {
        type = types.attrsOf (types.attrsOf types.str);
        default = {};
      };
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
    (mkIf cfg.i3.enable i3)
    (mkIf cfg.wayland.enable wayland)
    (mkIf cfg.wayland.enable waybar)
    (mkIf cfg.wayland.enable sway)
  ];

  imports = [ ./polybar.nix ];
}

