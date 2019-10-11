{pkgs, ...}:
let
  dotfiles = [
    "aliases"
    "bcrc"
    "codex"
    "ghci"
    "haskeline"
    "Xmodmap"
  ];

  mkHomeFile = x: {
    ${x} = {
      source = ~/. + "/.dotfiles/${x}";
      target = ".${x}";
    };
  };

  vimPlugins = pkgs.vimPlugins // {
    vim-gnupg = pkgs.vimUtils.buildVimPlugin {
      name = "vim-gnupg";
      src = ~/.dotfiles/vim-plugins/vim-gnupg;
    };
    vim-ionide = pkgs.vimUtils.buildVimPlugin {
      name = "vim-ionide";
      src = ~/.dotfiles/vim-plugins/vim_fsharp_languageclient;
    };
    jonas = pkgs.vimUtils.buildVimPlugin {
      name = "jonas";
      src = ~/.dotfiles/vim-plugins/jonas;
    };
  };

  private = import ./private.nix;
in
{
  home.file =
    {
      local-bin = {
        source = ~/.dotfiles/local/bin;
        target = ".local/bin";
        recursive = true;
      };
      xmobarrc = {
        source = ~/.xmonad/xmobarrc;
        target = ".xmobarrc";
        recursive = false;
      };
    }
    // private.home.file
    // builtins.foldl' (a: x: a // mkHomeFile x) {} dotfiles;


  home.packages = import ./packages.nix { pkgs = pkgs; };

  gtk = {
    enable = true;
    font.name = "DejaVu Sans 11";
    # font.name = "Carlito 11";
    iconTheme.name = "Ubuntu-mono-dark";
    theme.name = "Adwaita";
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 0; };
  };

  home.keyboard = {
    layout = "us(altgr-intl)";
    model = "pc104";
    options = [ "eurosign:e" "caps:none" ];
  };

  home.sessionVariables = {};

  programs = {
    browserpass.enable = true;
    feh.enable = true;
    firefox.enable = true;
    htop.enable = true;
    man.enable = true;
    neovim = {
      enable = true;
      plugins = with vimPlugins; [
        jonas
        LanguageClient-neovim
        ctrlp
        idris-vim
        neco-ghc
        neocomplete
        nerdcommenter
        nerdtree
        purescript-vim
        supertab
        syntastic
        tabular
        tlib_vim
        vim-addon-mw-utils
        vim-airline
        vim-airline-themes
        NeoSolarized
        vim-commentary
        vim-fish
        vim-markdown
        vim-nix
        vimproc
        vim-sensible
        vim-snipmate
        vim-surround
        vim-unimpaired
        vim-gnupg
        vim-ionide
      ];
      extraConfig = builtins.readFile ../../vimrc;
    };
    git = {
      enable = true;
      aliases = {
        ll = "log --stat --abbrev-commit --decorate";
        history = "log --graph --abbrev-commit --decorate --all";
        co = "checkout";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD";
        pick = "cherry-pick";
      };
      ignores = ["*~" "*.o" "*.a" "*.dll" "*.bak" "*.old"];
      extraConfig = {
        merge = {
          tool = "meld";
        };
        color = {
          branch = "auto";
          diff = "auto";
          status = "auto";
        };
        push = {
          # matching, tracking or current
          default = "current";
        };
        pull = {
          rebase = false;
        };
        core = {
          editor = "vim";
        };
        help = {
          autocorrect = 1;
        };
        http = {
          sslVerify = false;
        };
      };
    } // private.git;

    ssh = {
      enable = true;
      compression = false;
      forwardAgent = true;
      serverAliveInterval = 30;
      extraConfig = "IPQoS throughput";
    } // private.ssh;

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 10;
      terminal = "tmux-256color";
      extraConfig = ''
        # start windows and panes at 1
        setw -g pane-base-index 1
        set -ga terminal-overrides ",xterm-termite:Tc"
      '';
    };
  };

  systemd.user.sessionVariables = {
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
  };
  systemd.user.startServices = true;
  systemd.user.services = {
    dropbox = {
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
    };
  };

  services.flameshot.enable =  true;
  services.screen-locker = {
    enable = true;
    inactiveInterval = 45;
    lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
  };
  services.polybar = {
    enable = false;
    script = "polybar bar/top &";
    config = {
      "bar/top" = {
        # monitor = "\${env:MONITOR:VGA-1}";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-center = "date";
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };
    };
  };

  services.network-manager-applet.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 64800; # 18 hours
    defaultCacheTtlSsh = 64800;
    maxCacheTtl = 64800;
    maxCacheTtlSsh = 64800;
    extraConfig = '''';
  };

  programs.lesspipe.enable = true;
  programs.termite = {
    enable = true;
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

  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    (import ./overlays/dotnet-sdk.nix)
    (import ./overlays/vscode.nix)
    (import ./overlays/wavebox.nix)
  ];

   xresources.properties = {
    "Xclip.selection" = "clipboard";
    "Xcursor.theme" = "cursor-theme";
    "Xcursor.size" = 16;
  };

  xdg.configFile = {
    fish = {
      source = ~/.dotfiles/config/fish;
      target = "fish";
      recursive = true;
    };
    nixpkgs = {
      source = ~/.dotfiles/config/nixpkgs/overlays;
      target = "nixpkgs/overlays";
      recursive = true;
    };
  };

  xdg.dataFile = {
    xmonad-desktop = {
      source = ~/.xmonad/Xmonad.desktop;
      target = "applications/Xmonad.desktop";
    };
    omf = {
      source = ~/.dotfiles/local/share/omf;
      target = "omf";
    };
  };

  xsession = {
    enable = true;
    initExtra = ''
      xsetroot -solid '#888888'
      xsetroot -cursor_name left_ptr
      ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings &
      systemctl --user start gvfs-udisks2-volume-monitor.service
      #[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
      xmodmap $HOME/.Xmodmap
      xset s off
      xset dpms 0 0 3600
    '';
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = self: [
        self.yeganesh
        self.taffybar
        self.xmobar
        pkgs.dmenu
        pkgs.xmonad-log
        self.string-conversions
      ];
    };
  };

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };
}

