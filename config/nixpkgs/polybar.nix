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
      font-0 = "NotoSans Regular:size=12;2";
      font-1 = "Termsynu:size=8;-1";
      font-2 = "Material Icons:style=Regular:size=14";
      font-3 = "Noto Sans Symbols2:size=13";
      font-4 = "Noto Color Emoji:style=Regular";
      modules-right = "cpu memory eth volume powermenu date";
      modules-center = "";
      modules-left = "xmonad";
      tray-position = "right";
      tray-padding = 2;
    };
    "module/date" = {
      type = "internal/date";
      internal = 1;
      date = "%{F#C9AA7C}%d %B %Y%{F-}";
      time = "%H:%M:%S";
      label = "%{A1:${pkgs.gsimplecal}/bin/gsimplecal:}%date% %time% %{A}";
    };
    "module/cpu" = {
      type = "internal/cpu";
      interval = "2";
      format = "<label>";
      format-prefix = "cpu ";
      format-prefix-foreground = "\${colors.foreground}";
      format-underline = "\${colors.grey}";
      label = "%percentage%%";
    };
    "module/memory" = {
      type = "internal/memory";
      interval = 2;
      format = "<bar-used>";
      format-prefix = "mem ";
      format-prefix-foreground = "\${colors.foreground}";
      format-underline = "\${colors.grey}";
      label = "%percentage_used%%";
      bar-used-indicator = "";
      bar-used-width = "10";
      bar-used-foreground-0 = "#55aa55";
      bar-used-foreground-1 = "#557755";
      bar-used-foreground-2 = "#f5a70a";
      bar-used-foreground-3 = "#ff5555";
      bar-used-fill = "▐";
      bar-used-empty = "▐";
      bar-used-empty-foreground = "#444444";
    };
    "module/eth" = {
      type = "internal/network";
      interface = "ens33";
      interval = "2.0";
      format-connected = "<label-connected>";
      format-connected-underline = "\${colors.grey}";
      format-connected-prefix = "";
      format-connected-prefix-foreground = "\${colors.foreground}";
      label-connected = "%ifname%: %{F#7C99C9}↓%downspeed%%{F-} %{F#C07A74}↑%upspeed%%{F-}";
    };
    "module/powermenu" = {
      type = "custom/menu";
      format-underline = "\${colors.grey}";
      expand-right = "true";
      format-spacing = 1;
      label-open = "⏻";
      label-open-foreground = "\${colors.secondary}";
      label-close = "%{F#C4392E}✕%{F-}";
      label-close-foreground = "\${colors.secondary}";
      label-separator = "/";
      label-separator-foreground = "\${colors.foreground}";

      menu-0-0 = "%{F#83A9C8}reboot%{F-}";
      menu-0-0-exec = "menu-open-1";
      menu-0-1 = "%{F#83A9C8}power off%{F-}";
      menu-0-1-exec = "menu-open-2";

      menu-1-0 = "%{F#CB2A2F}reboot%{F-}";
      menu-1-0-exec = "sudo reboot";

      menu-2-0 = "%{F#CB2A2F}power off%{F-}";
      menu-2-0-exec = "sudo poweroff";
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
      label-volume = "%{A1:${pkgs.pavucontrol}/bin/pavucontrol:}%{A} %percentage%%";
      label-muted-foreground = "#66";
    };
  };
}
