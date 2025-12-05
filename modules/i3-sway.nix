{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dotfiles.desktop;

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
      statusbar =
        if (!cfg.wayland.enable && cfg.i3.enable) then
          { statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml"; }
        else
          { command = "${pkgs.waybar}/bin/waybar"; };
    in
    {
      config = {
        window.titlebar = false;
        # terminal = "alacritty --working-directory $($HOME/nixos-configuration/get-last-location.sh)";
        terminal = "wezterm";
        modifier = "Mod4"; # this is the "windows" key
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
        bars = [
          (
            {
              id = "top";
              position = "top";
              trayOutput = cfg.i3.trayOutput;
              fonts = {
                names = [
                  "DejaVu Sans Mono"
                  "FontAwesome5Free"
                  "FontAwesome"
                  "JetBrainsMono"
                ];
                style = "Normal";
                size = 9.0;
              };
              colors = {
                separator = base03;
                background = base01;
                statusline = base05;
                focusedWorkspace = {
                  background = base01;
                  border = base01;
                  text = base07;
                };
                activeWorkspace = {
                  background = base01;
                  border = base02;
                  text = base03;
                };
                inactiveWorkspace = {
                  background = base01;
                  border = base01;
                  text = base03;
                };
                urgentWorkspace = {
                  background = base01;
                  border = base01;
                  text = base08;
                };
              };
            }
            // statusbar
          )
        ];
        modes.resize = {
          Up = "resize shrink height 5 px or 5 ppt";
          Down = "resize grow height 5 px or 5 ppt";
          Left = "resize shrink width 5 px or 5 ppt";
          Right = "resize grow width 5 px or 5 ppt";
          Escape = "mode default";
          Return = "mode default";
        };
        startup = [
          {
            command = "${pkgs.autotiling}/bin/autotiling";
            always = false;
          }
          { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        ]
        ++ (
          if cfg.wayland.enable then
            [
              {
                command = "${pkgs.swaybg}/bin/swaybg -c '#444444' -i ${wallpaper} -m fill";
                always = false;
              }
              {
                command = ''
                  swayidle timeout 600 'swaylock -c 111111' \
                           timeout ${builtins.toString screen_timeout} 'swaymsg "output * dpms off"' \
                           resume 'swaymsg "output * dpms on"' \
                           before-sleep 'swaylock' '';
                always = false;
              }
            ]
          else
            [ ]
        );
        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
            switch = n: "exec --no-startup-id ${pkgs.i3-wk-switch}/bin/i3-wk-switch ${n}";
            switches = builtins.foldl' (a: x: a // { "${mod}+${x}" = switch x; }) { } (
              builtins.genList (x: toString x) 10
            );
          in
          lib.mkOptionDefault (
            {
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

              "${mod}+d" = "exec $(${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop)";
              # "${mod}+d"= "exec $(${pkgs.haskellPackages.yeganesh}/bin/yeganesh -x -- -fn 'DejaVu Sans Mono-11' -nb white -nf black)";
              # "${mod}+d"= "exec $(${pkgs.ulauncher}/bin/ulauncher)";

              "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -n -c 111111";
              # "${mod}+Ctrl+s" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
              "Print" = "exec grimshot savecopy anything";
              "${mod}+Ctrl+n" = "exec --no-startup-id ${pkgs.nautilus}/bin/nautilus";

              # Pulse Audio controls
              "XF86AudioRaiseVolume" =
                "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" =
                "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioMute" =
                "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

              # Sreen brightness controls
              "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
              "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";

              # Media player controls
              "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
              "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
              "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
              "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
            }
            // (
              if cfg.wayland.enable then
                {
                  "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.swaylock}/bin/swaylock";
                  "${mod}+Shift+r" = "exec --no-startup-id ${pkgs.sway}/bin/sway reload";
                }
              else
                { }
            )
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
            else
              [
                time
                # { block = "sound"; }
              ];
        in
        {
          enable = true;
          bars = {
            top = {
              blocks = first-block ++ last-block;

              settings = {
                theme = {
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
      wrapperFeatures.gtk = true;
      config = i3-sway.config // {
        output = cfg.sway.output;
        input = {
          "*" = with config.dotfiles.keyboard; {
            kb_layout = layout;
            kb_model = model;
            kb_options = builtins.foldl' (a: x: a + x + ",") "" options;
          };
        };
      };
    };
  };

in
{
  options.dotfiles.desktop = {
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
        default = { };
      };
    };
  };

  config = mkMerge [
    (mkIf (!cfg.wayland.enable && cfg.i3.enable) i3)
    (mkIf (cfg.wayland.enable && (cfg.sway.enable || cfg.i3.enable)) sway)
  ];
}
