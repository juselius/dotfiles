{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.dotfiles;

  homeFiles = {
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
            source = ~/. + "/.dotfiles/${x}";
            target = ".${x}";
          };
        };
      in
        a // mkHomeFile x) {} cfg.extraDotfiles;
  };

  sshFiles = {
    home.file.ssh = {
      source = ~/.dotfiles/ssh;
      target = ".ssh";
      recursive = true;
    };
  };

  vimPlugins =
    let
      vim-ionide = pkgs.vimUtils.buildVimPlugin {
          name = "vim-ionide";
          src = ~/.dotfiles/vim-plugins/Ionide-vim;
          buildInputs = [ pkgs.curl pkgs.which pkgs.unzip ];
        };
      devPlugins = with pkgs.vimPlugins; [
          LanguageClient-neovim
          idris-vim
          neco-ghc
          purescript-vim
          vim-ionide
          rust-vim
          # vim-clojure-static
          # vim-clojure-highlight
        ];
    in { programs.neovim.plugins = devPlugins; };

  configuration = {
    manual.manpages.enable = true;

    programs = {
      htop.enable = true;
      man.enable = true;
      lesspipe.enable = false;
      dircolors.enable = true;

      fish = {
        enable = true;
        shellInit = ''
          set -e TMUX_TMPDIR
          set PATH ~/.local/bin $HOME/.nix-profile/bin ~/.dotnet/tools $PATH
          bind \cp push-line
        '';
        promptInit = ''
          omf theme j
        '';
        shellAliases = {
          ll = "ls -l";
          la = "ls -a";
          lla = "ls -la";
          ltr = "ls -ltr";
          vi = "vim";
          diff = "diff -u";
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
          home-manager = "home-manager -f ~/.dotfiles/config/nixpkgs/home.nix";
          lock = "xset s activate";
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
              src = ~/.dotfiles/vim-plugins/vim-gnupg;
            };
            vim-singularity-syntax = pkgs.vimUtils.buildVimPlugin {
              name = "vim-singularity-syntax";
              src = ~/.dotfiles/vim-plugins/vim-singularity-syntax;
              buildPhase = ":";
              configurePhase = ":";
            };
            jonas = pkgs.vimUtils.buildVimPlugin {
              name = "jonas";
              src = ~/.dotfiles/vim-plugins/jonas;
            };
          };
        in
        {
          enable = true;
          plugins = with vimPlugins; [
            jonas
            ctrlp
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
          ltr = "branch --sort=-committerdate";
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
      };

      ssh = {
        enable = true;
        compression = false;
        forwardAgent = true;
        serverAliveInterval = 30;
        extraConfig = "IPQoS throughput";
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
          (tmuxPlugins.mkDerivation {
            pluginName = "statusbar";
            version = "1.0";
            src = ../../tmux-plugins;
          })
          (tmuxPlugins.mkDerivation {
            pluginName = "current-pane-hostname";
            version = "master";
            src = fetchFromGitHub {
              owner = "soyuka";
              repo = "tmux-current-pane-hostname";
              rev = "6bb3c95250f8120d8b072f46a807d2678ecbc97c";
              sha256 = "1w1x8w351v9yppw37kcs985mm5ikpmdnckfjwqyhlqx90lf9sqdy";
            };
          })
          (tmuxPlugins.mkDerivation {
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

      home-manager = {
        enable = true;
        path = "https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz";
      };
    };

    home.keyboard = {
      layout = "us(altgr-intl)";
      model = "pc104";
      options = [
        "eurosign:e"
        "caps:none"
      ];
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      KUBE_EDITOR = "nvim";
      LESS = "-MiScR";
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
      nixpkgs = {
        source = ~/.dotfiles/config/nixpkgs/overlays;
        target = "nixpkgs/overlays";
        recursive = true;
      };
    };

    xdg.dataFile = {
      omf = {
        source = ~/.dotfiles/local/share/omf;
        target = "omf";
        recursive = true;
      };
    };

    xdg.dataFile = {
      j = {
        source = ~/.dotfiles/config/fish/themes/j;
        target = "omf/themes/j";
        recursive = false;
      };
    };

    services.unison = {
      enable = false;
      pairs = {
        docs = [ "/home/$USER/Documents"  "ssh://example/Documents" ];
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

    sshFiles = mkEnableOption "Enable ssh files in ~/.dotfiles/ssh";

    vimDevPlugins = mkEnableOption "Enable vim devel plugins";
  };

  config = mkMerge [
    homeFiles

    (mkIf cfg.sshFiles sshFiles)

    (mkIf cfg.devel.vimDevPlugins vimPlugins)
  ];
}

