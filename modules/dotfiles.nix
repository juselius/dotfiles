{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.dotfiles;

  k8s-aliases =
    if cfg.packages.kubernetes then
      {
        ctr = "ctr --namespace k8s.io";
        k = "kubectl";
        kc = "kubectl";
        kcc = "kubectl config use-context";
        kcn = "kubectl config set-context --current --namespace";
        ked = "kubectl edit";
        kex = "kubectl exec -ti";
        kl = "kubectl logs";
        kg = "kubectl get";
        kgp = "kubectl get pods";
        kgd = "kubectl get deployments";
        kgs = "kubectl get secrets";
        kgc = "kubectl get configmaps";
        kgi = "kubectl get ingress";
        kgn = "kubectl get nodes";
        kd = "kubectl describe";
        kdp = "kubectl describe pod";
        kdd = "kubectl describe deployment";
        kdn = "kubectl describe node";
      }
    else
      { };

  shellAliases = {
    ls = "eza";
    la = "ls -a";
    lla = "ls -la";
    ltr = "ls -l --sort newest";
    nix-fish = "nix-shell --run fish";
    cat = "bat -p";
    diff = "diff -u";
    du = "dust";
    df = "duf --only local,network";
    top = "btop";
    vimdiff = "nvim -d";
    pssh = "parallel-ssh -t 0";
    xopen = "xdg-open";
    lmod = "module";
    unhist = "unset HISTFILE";
    halt = "halt -p";
    vim = "nvim";
    home-manager = "home-manager -f ~/.dotfiles";
    lock = "xset s activate";
    dig = "dog";
    # ps = "procs";
    # sed = "sed -r";
  }
  // k8s-aliases;

  configuration = {
    manual.manpages.enable = false;

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
        ''
        + (if cfg.fish.vi-mode then "fish_vi_key_bindings" else "");
        interactiveShellInit = ''
          omf theme j2
        '';
        inherit shellAliases;
        functions = {
          push-line = ''
            commandline -f kill-whole-line
            function restore_line -e fish_postexec
              commandline -f yank
              functions -e restore_line
            end'';
        };
      };

      atuin = {
        enable = cfg.atuin;
        enableFishIntegration = true;
        settings = {
          workspace = true;
          # TODO: auto_sync etc
          update_check = false;
          exit_mode = "return-query";
          enter_accept = true;
          filter_mode = "directory";
        };
      };

      git = {
        enable = true;
        lfs.enable = true;
        settings = {
          alias = {
            ll = "log --stat --abbrev-commit --decorate";
            history = "log --graph --abbrev-commit --decorate --all";
            co = "checkout";
            ci = "commit";
            st = "status";
            unstage = "reset HEAD";
            pick = "cherry-pick";
            ltr = "branch --sort=-committerdate";
          };
          init = {
            defaultBranch = "main";
          };
          core = {
            editor = "vim";
            pager = "${pkgs.delta}/bin/delta";
            # excludesfile = "~/.gitignore";
          };
          column = {
            ui = "auto";
          };
          branch = {
            sort = "-committerdate";
          };
          tag = {
            sort = "version:refname";
          };
          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            renames = true;
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
            default = "simple";
            autoSetupRemote = true;
            followTags = true;
          };
          fetch = {
            prune = true;
            pruneTags = true;
            all = true;
          };
          pull = {
            rebase = false;
          };
          commit = {
            verbose = true;
          };
          rerere = {
            enabled = true;
            autoupdate = true;
          };
          rebase = {
            autoSquash = true;
            autoStash = true;
            updateRefs = true;
          };
          help = {
            autocorrect = "prompt";
          };
          http = {
            sslVerify = false;
          };
        };
        ignores = [
          "*~"
          "*.o"
          "*.a"
          "*.dll"
          "*.bak"
          "*.old"
        ];
      };

      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
          compression = false;
          forwardAgent = true;
          serverAliveInterval = 30;
          extraOptions = {
            IPQoS = "throughput";
            UpdateHostKeys = "no";
          };
        };
      };

      zellij = {
        enable = true;
        settings = {
          simplified_ui = lib.mkDefault false;
          default_shell = "fish";
          pane_frames = false;
          layout_dir = "${config.xdg.configHome}/zellij/layouts";
          default_layout = lib.mkDefault "compact-top";
          show_startup_tips = false;
          theme = lib.mkDefault "nord";

          ui = {
            pane_frames = {
              hide_session_name = true;
            };
          };
        };
      };

      tmux = {
        enable = lib.mkDefault false;
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

      # htop = {
      #   enable = true;
      #   settings.left_meter_modes = [ "AllCPUs4" "Memory" "Swap" ];
      #   settings.right_meter_modes = [ "Tasks" "LoadAverage" "Uptime" ];
      # };

      btop = {
        enable = true;
      };

      # k9s = {
      #     enable = true;
      #     plugin = {
      #       debug = {
      #         shortCut = "Shit-D";
      #         confirm = true;
      #         description = "Add debug container";
      #         scopes = [ "containers" ];
      #         command = "kubectl";
      #         background = false;
      #         args = [
      #             "debug -it --context $CONTEXT -n=$NAMESPACE $POD --target=$NAME"
      #             "--image=nicolaka/netshoot:v0.12 --share-processes -- bash"
      #         ];
      #       };
      #       stern = {
      #         shortCut = "Ctrl-L";
      #         confirm = false;
      #         description = "Logs <Stern>";
      #         scopes = [ "pods" ];
      #         command = "stern";
      #         background = false;
      #         args = [
      #             "--tail"
      #             "50"
      #             "$FILTER"
      #             "-n"
      #             "$NAMESPACE"
      #             "--context"
      #             "$CONTEXT"
      #         ];
      #       };
      #     };
      # };

      home-manager = {
        enable = true;
        path = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
      };
    };

    xdg.configFile."zellij/layouts/compact-top.kdl".text = ''
      layout {
           pane size=1 borderless=true {
             plugin location="compact-bar"
           }
           pane
      }
    '';

    home.stateVersion = "24.11";

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

    # home.activation = {
    # linkOverlays = "cp -srf ~/.dotfiles/overlays ~/.config/nixpkgs";
    # };

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
        docs = [
          "/home/$USER/Documents"
          "ssh://example/Documents"
        ];
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
    };
  };

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
        pinentryPackage = pkgs.pinentry-curses;
      };
    };
  };
in
{
  options.dotfiles = {
    plainNix = mkEnableOption "Tweaks for non-NixOS systems";

    atuin = mkEnableOption "Enable atuin";

    fish.vi-mode = mkEnableOption "Enable vi-mode for fish";
  };

  config = mkMerge [
    configuration
    extraHomeFiles
  ];
}
