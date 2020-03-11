{ pkgs, options, ... }:
{
  programs = {
    browserpass.enable = true;
    feh.enable = true;
    firefox.enable = true;
  };

  home.file = {
    xmobarrc = {
      source = ~/.xmonad/xmobarrc;
      target = ".xmobarrc";
      recursive = false;
    };
    xmodmap = {
      source = ~/.dotfiles/Xmodmap;
      target = ".Xmodmap";
      recursive = false;
    };
  };

  systemd.user.services.dropbox =
    if options.desktop.dropbox then
      {
        Unit = {
          Description = "Dropbox";
        };
        Service = {
          ExecStart = "${pkgs.dropbox}/bin/dropbox";
          Restart = "on-failure";
          RestartSec = "10s";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      }
    else {};

  systemd.user.services.pa-applet = {
      Unit = {
        Description = "PulseAudio volume applet";
      };
      Service = {
        ExecStart = "${pkgs.pa_applet}/bin/pa-applet";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
  };

  services = {
    polybar = import ./polybar.nix { inherit pkgs options; };

    flameshot.enable =  true;

    screen-locker = {
      enable = true;
      inactiveInterval = 45;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
    };

    network-manager-applet.enable = true;
    blueman-applet.enable = true;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 64800; # 18 hours
      defaultCacheTtlSsh = 64800;
      maxCacheTtl = 64800;
      maxCacheTtlSsh = 64800;
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
      '';
    };
  };

  gtk = {
    enable = true;
    font.name = "DejaVu Sans 11";
    iconTheme.name = "Ubuntu-mono-dark";
    theme.name = "Adwaita";
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 0; };
  };

  xdg.dataFile = {
    xmonad-desktop = {
      source = ~/.xmonad/Xmonad.desktop;
      target = "applications/Xmonad.desktop";
    };
  };

  xresources.properties = {
    "Xclip.selection" = "clipboard";
    "Xcursor.theme" = "cursor-theme";
    "Xcursor.size" = 16;
  };

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
    '';
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = self: [
        self.yeganesh
        self.xmobar
        pkgs.dmenu
        pkgs.xmonad-log
        self.string-conversions
      ];
    };
  };

  programs.termite = {
    enable = true;
    clickableUrl = false;
    font = "Monospace 10";
    foregroundColor         = "#d8d8d8";
    foregroundBoldColor     = "#e8e8e8";
    cursorColor             = "#e8e8e8";
    cursorForegroundColor   = "#181818";
    #backgroundColor        = "rgba(24, 24, 24, 1)";
    colorsExtra = ''
      # Base16 Default Dark
      # Author: Chris Kempson (http://chriskempson.com)

      # Black, Gray, Silver, White
      color0  = #0b1c2c
      #color0  = #181818
      color8  = #585858
      color7  = #d8d8d8
      color15 = #f8f8f8

      # Red
      color1  = #ab4642
      color9  = #ab4642

      # Green
      color2  = #a1b56c
      color10 = #a1b56c

      # Yellow
      color3  = #f7ca88
      color11 = #f7ca88

      # Blue
      color4  = #7cafc2
      color12 = #7cafc2

      # Purple
      color5  = #ba8baf
      color13 = #ba8baf

      # Teal
      color6  = #86c1b9
      color14 = #86c1b9

      # Extra colors
      color16 = #dc9656
      color17 = #a16946
      color18 = #282828
      color19 = #383838
      color20 = #b8b8b8
      color21 = #e8e8e8
    '';
  };

}
