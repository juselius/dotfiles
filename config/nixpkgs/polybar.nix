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
      height = 20;
      radius = 2;
      font-0 = "xft:Ubuntu:size=8:antialias=true";
      separator = "|";
      modules-right = "volume cpu memory date powermenu";
      modules-center = "";
      modules-left = "xmonad";
      tray-position = "right";
    };

    "module/date" = {
      type = "internal/date";
      internal = 5;
      date = "%d.%m";
      time = "%H:%M";
      label = "%date%  %time%";
    };
    "module/memory" = {
      type = "internal/memory";
      interval = 2;
      format-prefix = "%{T2}%{T-} ";
      format-prefix-foreground = "\${colors.foreground}";
      format-underline = "\${colors.grey}";
      label = "%percentage_used%%";
    };
    "module/eth" = {
      type = "internal/network";
      interface = "eno2";
      interval = "3.0";

      format-connected-underline = "\${colors.grey}";
      format-connected-prefix = " ";
      format-connected-prefix-foreground = "\${colors.foreground}";
      label-connected = "%local_ip%";
    };
    "module/powermenu" = {
      type = "custom/menu";

      format-underline = "\${colors.grey}";
      expand-right = "true";

      format-spacing = 1;

      label-open = "";
      label-open-foreground = "\${colors.secondary}";
      label-close = "";
      label-close-foreground = "\${colors.secondary}";
      label-separator = "|";
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
    "module/xwindow" = {
      type = "internal/xwindow";
      label = "%title:0:30:...%";
    };
    "module/xkeyboard" = {
      type = "internal/xkeyboard";
      blacklist-0 = "num lock";
      format-prefix = " ";
      format-prefix-foreground = "\${colors.foreground}";
      format-prefix-underline = "\${colors.grey}";
      label-layout = "%layout%";
      label-layout-underline = "\${colors.secondary}";
      label-indicator-padding = "2";
      label-indicator-margin = "1";
      label-indicator-background = "\${colors.secondary}";
      label-indicator-underline = "\${colors.grey}";
    };
    "module/filesystem" = {
      type = "internal/fs";
      interval = "25";
      mount-0 = "/";
      mount-1 = "/home/idzard/harddrive";
      label-mounted = "%{F#5b51c9}%mountpoint%%{F-}: %percentage_used%%";
      label-unmounted = "%mountpoint% not mounted";
      label-unmounted-foreground = "\${colors.foreground}";
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
      ramp-capacity-0 = "";
      ramp-capacity-1 = "";
      ramp-capacity-2 = "";
      ramp-capacity-3 = "";
      ramp-capacity-4 = "";
      ramp-capacity-foreground = "\${colors.foreground}";
      animation-charging-0 = "";
      animation-charging-1 = "";
      animation-charging-2 = "";
      animation-charging-3 = "";
      animation-charging-4 = "";
      animation-charging-foreground = "\${colors.foreground}";
      animation-charging-framerate = "750";
    };
    "module/cpu" = {
      type = "internal/cpu";
      interval = "2";
      format = "<ramp-load>";
      ramp-load-7 = "█";
      ramp-load-6 = "▇";
      ramp-load-5 = "▆";
      ramp-load-4 = "▅";
      ramp-load-3 = "▄";
      ramp-load-2 = "▃";
      ramp-load-1 = "▂";
      ramp-load-0 = "▁";
      format-prefix = "%{T2}%{T-} ";
      format-prefix-foreground = "\${colors.foreground}";
      format-underline = "\${colors.grey}";
      label = "%percentage%%";
    };
    "module/volume" = {
      type = "internal/alsa";
      format-volume = "<label-volume>";
      label-volume = " %percentage%%";
      label-volume-foreground = "\${root.foreground}";
      format-muted-prefix = " ";
      format-muted-foreground = "\${colors.foreground}";
      label-muted = "sound muted";
      bar-volume-width = "10";
      bar-volume-foreground-0 = "\${colors.grey2}";
      bar-volume-foreground-1 = "\${colors.grey2}";
      bar-volume-foreground-2 = "\${colors.grey2}";
      bar-volume-foreground-3 = "\${colors.grey2}";
      bar-volume-foreground-4 = "\${colors.grey2}";
      bar-volume-foreground-5 = "\${colors.grey1}";
      bar-volume-foreground-6 = "\${colors.grey}";
      bar-volume-gradient = "false";
      bar-volume-indicator = "|";
      bar-volume-indicator-font = "0";
      bar-volume-fill = " ";
      bar-volume-fill-font = "1";
      bar-volume-empty = " ";
      bar-volume-empty-font = "1";
      bar-volume-empty-foreground = "\${colors.foreground}";
    };
  };
}
