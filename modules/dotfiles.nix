{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.dotfiles;

  configuration = {
    manual.manpages.enable = true;

    programs = {
      man.enable = true;
      lesspipe.enable = false;
      dircolors.enable = true;
      zoxide.enable = true;

      fish = {
        enable = true;
        shellInit = ''
          set -e TMUX_TMPDIR
          set PATH ~/.local/bin $HOME/.nix-profile/bin ~/.dotnet/tools $PATH
          bind \cp push-line
          bind -M insert \cp push-line
          bind -M insert \ce end-of-line
          bind -M insert \ca beginning-of-line

          # for vi mode
          set fish_cursor_default block
          set fish_cursor_insert line
          set fish_cursor_replace_one underscore
          set fish_cursor_visual block
        '' + (if cfg.fish.vi-mode then "fish_vi_key_bindings" else "");
        interactiveShellInit = ''
          omf theme j2
        '';
        shellAliases = {
          ls = "exa";
          ll = "ls -l";
          la = "ls -a";
          lla = "ls -la";
          ltr = "ls -l --sort newest";
          # ltr = "ls -ltr";
          cat = "bat -p";
          diff = "diff -u";
          ps = "procs";
          du = "dust";
          df = "duf";
          # sed = "sed -r";
          top = "htop";
          vimdiff = "nvim -d";
          pssh = "parallel-ssh -t 0";
          xopen = "xdg-open";
          lmod = "module";
          unhist = "unset HISTFILE";
          nix-zsh = ''nix-shell --command "exec zsh"'';
          nix-fish = ''nix-shell --command "exec fish"'';
          halt = "halt -p";
          kc = "kubectl";
          k = "kubectl";
          tw = "timew";
          vim = "nvim";
          home-manager = "home-manager -f ~/.dotfiles";
          lock = "xset s activate";
          dig = "dog";
        };
        functions = {
          push-line = ''
            commandline -f kill-whole-line
            function restore_line -e fish_postexec
              commandline -f yank
              functions -e restore_line
            end'';
        };
      };

      neovim =
        let
          vimPlugins = pkgs.vimPlugins // {
            vim-gnupg = pkgs.vimUtils.buildVimPlugin {
              name = "vim-gnupg";
              src = ~/.dotfiles/plugins/vim-plugins/vim-gnupg;
            };
            vim-singularity-syntax = pkgs.vimUtils.buildVimPlugin {
              name = "vim-singularity-syntax";
              src = ~/.dotfiles/plugins/vim-plugins/vim-singularity-syntax;
              buildPhase = ":";
              configurePhase = ":";
            };
            jonas = pkgs.vimUtils.buildVimPlugin {
              name = "jonas";
              src = ~/.dotfiles/plugins/vim-plugins/jonas;
            };
          };
        in
        {
          enable = true;
          plugins = with vimPlugins; [
            jonas
            ctrlp
            deoplete-nvim
            neocomplete
            nerdcommenter
            nerdtree
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
            vim-singularity-syntax
          ];
          extraConfig = builtins.readFile ../adhoc/vimrc;
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
          ltr = "branch --sort=-committerdate";
        };
        ignores = ["*~" "*.o" "*.a" "*.dll" "*.bak" "*.old"];
        extraConfig = {
          init = {
            defaultBranch = "main";
          };
          core = {
            editor = "vim";
            pager = "${pkgs.delta}/bin/delta";
          };
          merge = {
            tool = "meld";
          };
          interactive = {
            diffFilter = "${pkgs.delta}/bin/delta --color-only";
          };
          delta = {
            navigate = true;
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
          help = {
            autocorrect = 1;
          };
          http = {
            sslVerify = false;
          };
        };
      };

      ssh = {
        enable = true;
        compression = false;
        forwardAgent = true;
        serverAliveInterval = 30;
        extraConfig = ''
          IPQoS throughput
          UpdateHostKeys no
        '';
      };

      tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        escapeTime = 10;
        terminal = "tmux-256color";
        historyLimit = 5000;
        keyMode = "vi";
        plugins = with pkgs; [
          (tmuxPlugins.mkTmuxPlugin {
            pluginName = "statusbar";
            version = "1.0";
            src = ../plugins/tmux-plugins;
          })
          (tmuxPlugins.mkTmuxPlugin {
            pluginName = "current-pane-hostname";
            version = "master";
            src = fetchFromGitHub {
              owner = "soyuka";
              repo = "tmux-current-pane-hostname";
              rev = "6bb3c95250f8120d8b072f46a807d2678ecbc97c";
              sha256 = "1w1x8w351v9yppw37kcs985mm5ikpmdnckfjwqyhlqx90lf9sqdy";
            };
          })
          (tmuxPlugins.mkTmuxPlugin {
            pluginName = "simple-git-status";
            version = "master";
            src = fetchFromGitHub {
              owner = "kristijanhusak";
              repo = "tmux-simple-git-status";
              rev = "287da42f47d7204618b62f2c4f8bd60b36d5c7ed";
              sha256 = "04vs4afxcr118p78mw25nnzvlms7pmgmi2a80h92vw5pzw9a0msq";
            };
          })
        ];
        extraConfig = ''
          # start windows and panes at 1
          setw -g pane-base-index 1
          set -ga terminal-overrides ",xterm-termite:Tc"
          set-option -g default-shell ${pkgs.fish}/bin/fish
        '';
      };

      htop = {
        enable = true;
        settings.left_meter_modes = [ "AllCPUs4" "Memory" "Swap" ];
        settings.right_meter_modes = [ "Tasks" "LoadAverage" "Uptime" ];
      };


      home-manager = {
        enable = true;
        path = "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
      };
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      KUBE_EDITOR = "nvim";
      LESS = "-MiSR";
      GIT_ALLOW_PROTOCOL = "ssh:https:keybase:file";
      LD_LIBRARY_PATH = "$HOME/.nix-profile/lib";
    };

    systemd.user.startServices = true;

    systemd.user.sessionVariables = {
      GIT_ALLOW_PROTOCOL = "ssh:https:keybase:file";
    };


    nixpkgs.config = {
      allowUnfree = true;
    };

    xdg.configFile = {
      fish = {
        source = ~/.dotfiles/config/fish;
        target = "fish";
        recursive = true;
      };
      "home.nix" = {
        source = ~/.dotfiles/home.nix;
        target = "nixpkgs/home.nix";
      };
      "config.nix" = {
        source = ~/.dotfiles/config.nix;
        target = "nixpkgs/config.nix";
      };
      modules = {
        source = ~/.dotfiles/modules;
        target = "nixpkgs/modules";
        recursive = true;
      };
      packages = {
        source = ~/.dotfiles/packages;
        target = "nixpkgs/packages";
        recursive = true;
      };
      overlays = {
        source = ~/.dotfiles/overlays;
        target = "nixpkgs/overlays";
        recursive = true;
      };
    };

    xdg.dataFile = {
      omf = {
        source = "${pkgs.oh-my-fish}/share/oh-my-fish";
        target = "omf";
        recursive = true;
      };

      themes = {
        source = ~/.dotfiles/config/fish/themes;
        target = "omf/themes";
        recursive = true;
      };
    };

    services.unison = {
      enable = false;
      pairs = {
        docs = [ "/home/$USER/Documents"  "ssh://example/Documents" ];
      };
    };
  };

  extraHomeFiles = {
    home.file = {
      local-bin = {
        source = ~/.dotfiles/local/bin;
        target = ".local/bin";
        recursive = true;
      };
    } // builtins.foldl' (a: x:
      let
        mkHomeFile = x: {
          ${x} = {
            source = ~/. + "/.dotfiles/adhoc/${x}";
            target = ".${x}";
          };
        };
      in
        a // mkHomeFile x) {} cfg.extraDotfiles;
  };

  vimDevPlugins =
    let
      vim-ionide = pkgs.vimUtils.buildVimPlugin {
          name = "vim-ionide";
          src = ~/.dotfiles/plugins/vim-plugins/Ionide-vim;
          buildInputs = [ pkgs.curl pkgs.which pkgs.unzip ];
        };
      devPlugins = with pkgs.vimPlugins; [
          LanguageClient-neovim
          idris-vim
          neco-ghc
          purescript-vim
          rust-vim
          # vim-ionide
          # vim-clojure-static
          # vim-clojure-highlight
        ];
    in { programs.neovim.plugins = devPlugins; };

  # settings when not running under NixOS
  plainNix = {
    home.sessionVariables = {
      NIX_PATH = "$HOME/.nix-defexpr/channels/:$NIX_PATH";
    };

    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 43200; # 12 hours
        defaultCacheTtlSsh = 64800; # 18 hours
        maxCacheTtl = 64800;
        maxCacheTtlSsh = 64800;
        pinentryFlavor = "curses";
      };
    };
  };
in
{
  options.dotfiles = {
    extraDotfiles = mkOption {
      type = types.listOf types.str;
      default = [];
    };

    vimDevPlugins = mkEnableOption "Enable vim devel plugins";

    plainNix = mkEnableOption "Tweaks for non-NixOS systems";

    fish.vi-mode = mkEnableOption "Enable vi-mode for fish";
  };

  config = mkMerge [
    configuration
    extraHomeFiles
    (mkIf cfg.vimDevPlugins vimDevPlugins)
  ];
}

