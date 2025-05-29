{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.desktop;

  x11services =
    if !cfg.wayland.enable then
      {
        pasystray.enable = true;
        flameshot.enable =  true;

        screen-locker = {
          enable = true;
          inactiveInterval = 45;
          lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 121212";
          # lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -n -p";
        };
      }
    else {};

  configuration = {
    dotfiles.desktop.onedrive.enable = mkDefault false;
    dotfiles.desktop.xmonad.enable = mkDefault false;
    dotfiles.desktop.i3.enable = mkDefault true;

    programs = {
      browserpass.enable = true;
      feh.enable = true;
      firefox.enable = true;
      gpg = {
        enable = true;
        settings = {
          use-agent = true;
        };
      };
    };

    home.file = {
      icons = {
        source = ~/.dotfiles/icons;
        target = ".icons";
        recursive = true;
      };
      xmodmap = {
        source = ~/.dotfiles/adhoc/Xmodmap;
        target = ".Xmodmap";
        recursive = false;
      };
    };

    # systemd.user.services.pa-applet = {
    #   Unit = {
    #     Description = "PulseAudio volume applet";
    #   };
    #   Service = {
    #     ExecStart = "${pkgs.pa_applet}/bin/pa-applet";
    #     Restart = "on-failure";
    #     RestartSec = "10s";
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };
    # };

    services = {
      clipmenu.enable =  false;

      network-manager-applet.enable = true; #!cfg.wayland.enable;
      blueman-applet.enable = true;

      # kanshi = {
      #  enable = true;
      # };
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 43200; # 12 hours
        defaultCacheTtlSsh = 43200;
        maxCacheTtl = 604800; # 7 days
        maxCacheTtlSsh = 604800;
        pinentry.package = pkgs.pinentry-gnome3;
      };

      gnome-keyring = {
        enable = true;
        components = [ "pkcs11" "secrets" ];
      };
    } // x11services;

    systemd.user.sessionVariables = {
      GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
    };

    gtk = {
      enable = true;
      font.name = "DejaVu Sans 11";
      iconTheme.name = "Ubuntu-mono-dark";
      theme.name = "Adwaita";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 0;
        # gtk-theme-name = "Sierra-compact-light";
        # gtk-icon-theme-name = "ePapirus";
        gtk-font-name = "Ubuntu 11";
        gtk-cursor-theme-name = "Adwaita";
        # gtk-cursor-theme-size = 0;
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-modules = "gail:atk-bridge";
      };
    };

    xresources.properties = {
      "Xclip.selection" = "clipboard";
      "Xcursor.theme" = "cursor-theme";
      "Xcursor.size" = 18;
    };

    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          vscodevim.vim
          ms-vsliveshare.vsliveshare
          ms-dotnettools.csharp
          ionide.ionide-fsharp
        ];
        userSettings = {
        };
      };
      haskell = {
        enable = false;
        hie.enable = false;
      };
    };

    programs.wezterm = {
      enable = true;
      extraConfig = ''
         local wezterm = require 'wezterm'
         local act = wezterm.action
         local config = {}

         return {
            font = wezterm.font("JetBrains Mono"),
            font_size = 11.0,
            color_scheme = "Classic Dark (base16)",
            hide_tab_bar_if_only_one_tab = true,
            mouse_bindings = {
              -- Disable the default click behavior
              {
                event = { Up = { streak = 1, button = "Left"} },
                mods = "NONE",
                action = wezterm.action.DisableDefaultAssignment,
              },
              -- Bind 'Up' event of CTRL-Click to open hyperlinks
              {
                event = { Up = { streak = 1, button = 'Left' } },
                mods = 'CTRL',
                action = act.OpenLinkAtMouseCursor,
              },
              -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
              {
                event = { Down = { streak = 1, button = 'Left' } },
                mods = 'CTRL',
                action = act.Nop,
              },
            },
           -- default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },
           -- keys = {
           --  {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
           -- }
         }
      '';
    };

    programs.alacritty = {
      enable = true;
      settings = {
        hints.enabled = [
          {
            regex =
              "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
            command = "xdg-open";
            post_processing = true;
            mouse = {
              enabled = true;
              mods = "Control";
            };
          }
        ];
        font.size = 13.0;
      #   colors = {
      #     primary = {
      #       background = "";
      #       dim_background = "";
      #     };
      #   };
      };
    };
  };

  dropbox = {
    services.dropbox.enable = true;
    home.packages = with pkgs; [ dropbox-cli ];
  };

  onedrive = {
    home.packages =[ pkgs.onedrive ];
    systemd.user.services.onedrive = {
      Unit = {
        Description = "OneDrive sync";
      };
      Service = {
        ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor --disable-notifications";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
in
{
  options.dotfiles.desktop = {
    enable = mkEnableOption "Enable desktop";
    laptop = mkEnableOption "Enable laptop features";
    dropbox.enable = mkEnableOption "Enable Dropbox";
    onedrive.enable = mkEnableOption "Enable OneDrive";
  };

  config = mkIf cfg.enable (mkMerge [
      configuration
      (mkIf cfg.dropbox.enable dropbox)
      (mkIf cfg.onedrive.enable onedrive)
  ]);

  imports = [ ./wm.nix ];
}
