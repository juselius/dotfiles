{pkgs, ...}:
{
  enable = true;
  script = "polybar top &";
  config = {
    "colors" = {
      background = "#d0303030";
      background-transparent = "#00303030";
      background-alt = "#c0303030";
      background-alt-2 = "#ff5fafcf";
      foreground = "#eeeeee";
      foreground-alt = "#c1c2c3";
      red = "#fb4934";
      green = "#b8bb26";
      yellow = "#fabd2f";
      blue = "#83a598";
      purple = "#d3869b";
      aqua = "#8ec07c";
      orange = "#fe8019";
      white = "#dddddd";
      blue_arch = "#83afe1";
      grey = "#5b51c9";
      grey1 = "#5bb1c9";
      grey2 = "#5bf1c9";
      primary = "green";
      secondary = "blue";
      alert = "red";
    };
    "bar/top" = {
      # monitor = "\${env:MONITOR:VGA-1}";
      width = "100%";
      height = 22;
      radius = 0;
      padding = 1;
      module-margin = 2;
      separator = "|";
      font-0 = "xft:Ubuntu:size=10:antialias=true";
      modules-right = "cpu memory eth date powermenu volume";
      modules-center = "";
      modules-left = "xmonad";
      tray-position = "right";
      tray-padding = 2;
    };
    "module/date" = {
      type = "internal/date";
      internal = 1;
      date = "%d %B %Y";
      time = "%H:%M:%S";
      # label = "%date% %time%";
      label = "%{A1:${pkgs.gsimplecal}/bin/gsimplecal:}%date% %time% %{A}";
    };
    "module/cpu" = {
      type = "internal/cpu";
      interval = "2";
      format = "<label>";
      format-prefix = "%{T2}cpu%{T-} ";
      format-prefix-foreground = "\${colors.foreground}";
      format-underline = "\${colors.grey}";
      label = "%percentage%%";
    };
    "module/memory" = {
      type = "internal/memory";
      interval = 2;
      format = "<ramp-used>";
      format-prefix = "%{T2}mem%{T-} ";
      format-prefix-foreground = "\${colors.foreground}";
      format-underline = "\${colors.grey}";
      label = "%percentage_used%%";
      ramp-used-7 = "█";
      ramp-used-6 = "▇";
      ramp-used-5 = "▆";
      ramp-used-4 = "▅";
      ramp-used-3 = "▄";
      ramp-used-2 = "▃";
      ramp-used-1 = "▂";
      ramp-used-0 = "▁";
    };
    "module/eth" = {
      type = "internal/network";
      interface = "ens33";
      interval = "2.0";
      format-connected = "<label-connected>";
      format-connected-underline = "\${colors.grey}";
      format-connected-prefix = "";
      format-connected-prefix-foreground = "\${colors.foreground}";
      label-connected = "%ifname%: %{F#ccccff}↓%downspeed%%{F-} %{F#ffcccc}↑%upspeed%%{F-}";
    };
    "module/powermenu" = {
      type = "custom/menu";
      format-underline = "\${colors.grey}";
      expand-right = "true";
      format-spacing = 1;
      label-open = "O";
      label-open-foreground = "\${colors.secondary}";
      label-close = "close";
      label-close-foreground = "\${colors.secondary}";
      label-separator = "/";
      label-separator-foreground = "\${colors.foreground}";

      menu-0-0 = "reboot";
      menu-0-0-exec = "menu-open-1";
      menu-0-1 = "power off";
      menu-0-1-exec = "menu-open-2";

      menu-1-0 = "cancel";
      menu-1-0-exec = "menu-open-0";
      menu-1-1 = "reboot";
      menu-1-1-exec = "sudo reboot";

      menu-2-0 = "power off";
      menu-2-0-exec = "sudo poweroff";
      menu-2-1 = "cancel";
      menu-2-1-exec = "menu-open-0";
    };
    "module/xmonad" = {
      type = "custom/script";
      exec = "${pkgs.xmonad-log}/bin/xmonad-log";
      tail = true;
    };
    "module/battery" = {
      type = "internal/battery";
      battery = "BAT1";
      adapter = "ADP1";
      full-at = "98";
      time-format = "%H:%M";
      format-charging = "<animation-charging>";
      format-discharging = "<ramp-capacity> <label-discharging>";
      label-discharging = "%time%";
      format-full-prefix = "f ";
      format-full-prefix-foreground = "\${colors.foreground}";
      ramp-capacity-0 = "";
      ramp-capacity-1 = "";
      ramp-capacity-2 = "";
      ramp-capacity-3 = "";
      ramp-capacity-4 = "";
      ramp-capacity-foreground = "\${colors.foreground}";
      animation-charging-0 = "";
      animation-charging-1 = "";
      animation-charging-2 = "";
      animation-charging-3 = "";
      animation-charging-4 = "";
      animation-charging-foreground = "\${colors.foreground}";
      animation-charging-framerate = "750";
    };
    "module/volume" = {
      type = "internal/alsa";
      format-volume = "<label-volume>";
      label-muted = "muted";
      label-volume = "%{A1:${pkgs.pavucontrol}/bin/pavucontrol:}vol %percentage%%%{A}";
      label-muted-foreground = "#66";
    };
  };
}
