{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.dotfiles.desktop;
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
                "custom/os_button"
                (if cfg.hyprland.enable then "hyprland/workspaces" else "sway/workspaces")
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

            "custom/os_button" = {
              format = "";
              "on-click" = "${pkgs.wofi}/bin/wofi --show drun";
              tooltip = false;
            };

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
              format-disconnected = "󰖪";
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
in {
  config = mkMerge [
    (mkIf cfg.wayland.enable waybar)
  ];
}

