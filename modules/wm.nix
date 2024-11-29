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
      screen_timeout = if cfg.laptop then 240 else 900;
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
                  swayidle timeout 600 'swaylock -c 111111' \
                           timeout ${builtins.toString screen_timeout} 'swaymsg "output * dpms off"' \
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
              modules-center = [
                # "sway/window"
              ];
              modules-right = [
                (if cfg.laptop then "battery" else "")
                (if cfg.laptop then "backlight" else "")
                "disk"
                "cpu"
                "memory"
                "idle_inhibitor"
                "wireplumber"
                "network"
                "tray"
                "clock"
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
            backlight = {
                device = "intel_backlight";
                format = "{percent}% {icon}";
                format-icons = [ " " " " " " " " " " " " " " " " " " ];
            };
            tray = {
              icon-size = 20;
              spacing = 10;
            };

            clock = {
              format = "  {:%a %d/%m %R}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              interval = 60;
              calendar = {
                    mode           = "year";
                    mode-mon-col   = 3;
                    weeks-pos      = "right";
                    on-scroll      = 1;
                    format = {
                              months =     "<span color='#ffead3'><b>{}</b></span>";
                              days =       "<span color='#ecc6d9'><b>{}</b></span>";
                              weeks =      "<span color='#99ffdd'><b>{}</b></span>";
                              weekdays =   "<span color='#ffcc66'><b>{}</b></span>";
                              today =      "<span color='#ff6699'><b><u>{}</u></b></span>";
                              };
                    };
                    actions =  {
                      on-click-right = "mode";
                    # on-scroll-up = "shift_up";
                    # on-scroll-down = "shift_down";
                  };
                };

            network = {
              # TODO: Pass in terminal emulator as a binding for better modularity
              # on-click = "networkmanager_dmenu";
              rotate = 0;
              interval = 2;
              format-wifi = " ";
              format-ethernet = "󰈀  ";
              format-linked = "󰈀   {ifname} (No IP)";
              format-disconnected = "󰖪  ";
              format-alt = "<span foreground='#99ffdd'>   {bandwidthDownBytes} </span> <span foreground='#ffcc66'>   {bandwidthUpBytes}</span>";
              tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
              tooltip-format-disconnected = "Disconnected";
              tooltip-format-ethernet = "{ifname}";
              tooltip-format-wifi = "{essid} ({signlStrength}%)";
            };

            wireplumber = {
              format = "{icon}  {volume}% ";
              format-muted = "󰝟 ";
              format-icons = [ " " " " " " ];
              on-click = "pavucontrol";
            };

            memory = {
              # format = "   {}%";
              format = "󰾆  {used}GB";
              format-m = "󰾅  {used}GB";
              format-h = "<span color='#ffffa5'>󰓅 </span>  {used}GB";
              format-c = "<span color='#dd532e'> </span>  {used}GB";
              format-alt = "󰾆  {percentage}%";
              rotate = 0;
              max-length = 10;
              tooltip = true;
              tooltip-format = "󰾆  {percentage}%\n  {used:0.1f}GB/{total:0.1f}GB";
              interval = 10;
              on-click = "alacritty -e btop";
              states = {
                c = 90; # critical
                h = 60; # high
                m = 30; # medium
              };
            };

            cpu = {
              format = "   {usage}%";
              interval = 5;
              on-click = "alacritty -e btop";
              format-alt = "{icon0}{icon1}{icon2}{icon3}";
              format-icons = [
                "<span color='#ffffff'>▁</span>"
                "<span color='#ffffff'>▂</span>"
                "<span color='#ffffff'>▃</span>"
                "<span color='#aaffaa'>▄</span>"
                "<span color='#aaffaa'>▅</span>"
                "<span color='#ffffa5'>▆</span>"
                "<span color='#ffffa5'>▇</span>"
                "<span color='#dd532e'>█</span>"
              ];
            };

            disk = {
              format = "󰆼   {free}";
              unit = "GB";
              interval = 30;
            };

            idle_inhibitor = {
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
                "<span color='#dd532e'>󰂎 </span>"
                "<span color='#ffffa5'>󰁺 </span>"
                "<span color='#ffffa5'>󰁻 </span>"
                "<span color='#ffffff'>󰁼 </span>"
                "<span color='#ffffff'>󰁽 </span>"
                "<span color='#ffffff'>󰁾 </span>"
                "<span color='#ffffff'>󰁿 </span>"
                "<span color='#ffffff'>󰂀 </span>"
                "<span color='#ffffff'>󰂁 </span>"
                "<span color='#ffffff'>󰂂 </span>"
                "<span color='#ffffff'>󰁹 </span>"
              #   "<span color='#dd532e'> </span>"
              #   "<span color='#ffffa5'> </span>"
              #   "<span color='#ffffff'> </span>"
              #   "<span color='#ffffff'> </span>"
              #   "<span color='#ffffff'> </span>"
              ];
              interval = 60;
              states = {
              good = 95;
                warning = 30;
                critical = 15;
              };
              rotate = 0;
              format-charging = "  {capacity}%";
              format-plugged = "  {capacity}%";
              format-alt = "{time} {icon}";
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

  hyprland = {
    home.packages = with pkgs; [
      wev
      wl-clipboard
      wofi
      wofi-pass
    ];

    wayland.windowManager = {
      hyprland.enable = true;
      hyprland.settings = {
        # TODO: Set your monitor here. See hyprctl monitors and https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [
          "DP-1, preferred, 0x0, 1.0"
        ];

        "$terminal" = "wezterm";
        "$fileManager" = "nautilus";
        "$menu" = "wofi --show drun";

        general = {
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "master";
        };

        decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 0.8;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.4696;
          };
        };

        animations = {
          enabled = true;

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          pseudotile = true;
          preserve_split = true; # You probably want this
        };

        master = {
          new_status = "slave";
        };

        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = false;
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, return, exec, $terminal"
          "$mainMod SHIFT, Q, killactive,"
          "$mainMod SHIFT, E, exit,"
          "$mainMod SHIFT, N, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, F, fullscreen,"
          "$mainMod, D, exec, $menu"
          "$mainMod SHIFT, D, exec, wofi-pass -c -s"
          "$mainMod, W, togglegroup, "
          "$mainMod CTRL, L, exec, hyprlock"
          # TODO: Screenshot

          # "focus with mainMod + vim keys"
          "$mainMod,  left, movefocus, l"
          "$mainMod,  down, movefocus, d"
          "$mainMod,    up, movefocus, u"
          "$mainMod, right, movefocus, r"

          # Move in and out of groups
          "$mainMod SHIFT,  left, movewindoworgroup, l"
          "$mainMod SHIFT,  down, movewindoworgroup, d"
          "$mainMod SHIFT,    up, movewindoworgroup, u"
          "$mainMod SHIFT, right, movewindoworgroup, r"

          # Window cycling
          "$mainMod, Tab, layoutmsg, swapwithmaster"
          "$mainMod, Tab, changegroupactive, f"

          # "h workspaces with mainMod + [0-9]"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 0, movetoworkspace, 0"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"

          # le special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # l through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        binde = [
          ", XF86MonBrightnessUp,   exec, brightnessctl set +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

          ", XF86AudioMute,         exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ", XF86AudioRaiseVolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ +10%"
          ", XF86AudioLowerVolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ -10%"
        ];

        bindl = [
          ", switch:Lid Switch, exec, hyprlock"
        ];

        windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.
      };
    };

    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 300;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              placeholder_text = ''
                <span foreground="##cad3f5">Password...</span>
              '';
              shadow_passes = 2;
            }
          ];
        };
      };

      waybar = {
        enable = true;
        systemd.enable = true;
        style = builtins.readFile ./style.css;
        settings = {
          mainBar = {
            name = "main-bar";
            layer = "top";
            position = "bottom";
            height = 30;

            modules-left = [
              "custom/os_button"
              "hyprland/workspaces"
            ];

            modules-center = [];

            modules-right = [
              "hyprland/language"
              "temperature"
              "cpu"
              "memory"
              "network"
              "pulseaudio"
              "backlight"
              "battery"
              "tray"
              "clock"
            ];

            "custom/os_button" = {
              format = "";
              "on-click" = "wofi --show drun";
              tooltip = false;
            };

            "hyprland/language" = {
              format = "{short} ({variant})";
            };

            cpu = {
              format = "  {usage}%";
            };

            memory = {
              format = "  {percentage}%";
            };

            network = {
              "format-wifi" = "   {signalStrength}%";
              "format-ethernet" = " {ifname}";
              "tooltip-format" = " {ifname} via {gwaddr}";
              "format-linked" = " {ifname} (No IP)";
              "format-disconnected" = "Disconnected ⚠ {ifname}";
              "format-alt" = " {ifname}: {ipaddr}/{cidr}";
            };

            pulseaudio = {
              "format" = "{icon}   {volume}% ";
              "format-icons" = {
                "headphone" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = [
                  ""
                  ""
                  ""
                ];
              };
              "on-click" = "pavucontrol";
            };

            backlight = {
              "device" = "intel_backlight";
              "format" = "{icon}   {percent}% ";
              "format-icons" = [
                ""
                ""
              ];
            };

            battery = {
              "states" = {
                "warning" = 30;
                "critical" = 15;
              };
              "format" = "{icon}   {capacity}%";
              "format-charging" = " {capacity}%";
              "format-plugged" = " {capacity}%";
              "format-alt" = "{icon} {time}";
              "format-icons" = [
                ""
                ""
                ""
                ""
                ""
              ];
            };

            tray = {
              "icon-size" = 18;
              spacing = 3;
            };
          };
        };
      };
    };

    services = {
      # Notification engine using gnome
      swaync.enable = true;

      # For sleeping Zzz
      hypridle = {
        enable = true;
        settings = {
          general = {
            ignore_dbus_inhibit = false;
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 900;
              on-timeout = "loginctl lock-session";
            }

            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      hyprpaper =
        # TODO: Expose wallpapers as option
        let
          mosaic = $"{pkgs.nix-artwork.wallpapers.mosaic-blue}/share/backgrounds/nixos/nix-wallpaper-mosaic-blue.png";
        in
        {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            splash_offset = 2.0;

            preload = [ mosaic ];

            wallpaper = [ ",${mosaic}" ];
          };
        };
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

    hyprland = {
      enable = mkEnableOption "Enable Hyprland";
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
    (mkIf cfg.hyprland.enable hyprland)
  ];

  imports = [ ./polybar.nix ];
}

