{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.dotfiles.desktop;

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
        monitor = cfg.hyprland.monitor;

        "$terminal" = "${pkgs.alacritty}/bin/alacritty";
        "$fileManager" = "${pkgs.nautilus}/bin/nautilus";
        "$lock" = "${pkgs.hyprlock}/bin/hyprlock";
        "$menu" = "${pkgs.wofi}/bin/wofi --show drun";
        "$wofipass" = "${pkgs.wofi-pass}/bin/wofi-pass";

        general = {
          gaps_in = 0;
          gaps_out = 0;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "master";
        };

        decoration = {
          rounding = 3;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 0.90;

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
          kb_layout = "us(altgr-intl)";
          kb_model = "pc104";
          kb_options = "eurosign:e,caps:none";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
            natural_scroll = false;
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
          "$mainMod SHIFT, D, exec, $wofipass -c -s"
          "$mainMod, W, togglegroup, "
          "$mainMod SHIFT, L, exec, $lock"
          "$mainMod, Print, exec, ${pkgs.grimblast}/bin/grimblast copy area"
          "$mainMod SHIFT, Print, exec, ${pkgs.grimblast}/bin/grimblast savecopy area"

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
          "$mainMod, Tab, cyclenext,"
          "$mainMod, Tab, changegroupactive, f"

          # Master
          "$mainMod, SPACE, layoutmsg, swapwithmaster"
          "$mainMod SHIFT, SPACE, layoutmsg, orientationnext"

          # "h workspaces with mainMod + [0-9]"
          "$mainMod, 1, focusworkspaceoncurrentmonitor, 1"
          "$mainMod, 2, focusworkspaceoncurrentmonitor, 2"
          "$mainMod, 3, focusworkspaceoncurrentmonitor, 3"
          "$mainMod, 4, focusworkspaceoncurrentmonitor, 4"
          "$mainMod, 5, focusworkspaceoncurrentmonitor, 5"
          "$mainMod, 6, focusworkspaceoncurrentmonitor, 6"
          "$mainMod, 7, focusworkspaceoncurrentmonitor, 7"
          "$mainMod, 8, focusworkspaceoncurrentmonitor, 8"
          "$mainMod, 9, focusworkspaceoncurrentmonitor, 9"
          "$mainMod, 0, focusworkspaceoncurrentmonitor, 10"

          # active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

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
          ", switch:Lid Switch, exec, $lock"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.*" # You'll probably like this.
          "opacity 1.0 override 1.0 override 1.0 override, class:(google-chrome|firefox|ferdium)"
          "stayfocused, class:(gcr-prompter)"
        ];
      };
    };

    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 10;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";
              # path = "screenshot";
              blur_passes = 2;
              blur_size = 2;
            }
          ];

          input-field = [
            {
              size = "300, 50";
              position = "0, -10";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              placeholder_text = ''
                <span foreground="##cad3f5">Enter password...</span>
              '';
              shadow_passes = 1;
            }
          ];

          label = [
            {
              position = "-130, -70";
              halign = "right";
              valign = "top";
              font_size = 70;
              text = "cmd[update:1000] echo \"<span foreground='white'>$(date +\"%T\")</span>\"";
            }
          ];
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
            lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
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
          #mosaic = $"{pkgs.nix-artwork.wallpapers.mosaic-blue}/share/backgrounds/nixos/nix-wallpaper-mosaic-blue.png";
          wallpaper = "${pkgs.nixos-artwork.wallpapers.binary-blue}/share/backgrounds/nixos/nix-wallpaper-binary-blue.png";
        in
        {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            splash_offset = 2.0;

            preload = [ wallpaper ];

            wallpaper = [ ",${wallpaper}" ];
          };
        };
    };
  };
in {
  options.dotfiles.desktop = {
    hyprland = {
      enable = mkEnableOption "Enable Hyprland";
      monitor = mkOption {
        type = types.listOf types.str;
        default = [ ", preferred, 0x0, 1.0" ];

      };
    };
  };

  config = mkMerge [
    (mkIf cfg.hyprland.enable hyprland)
  ];
}
