{pkgs, ...}:
with pkgs.lib;
let
  options = import ./options.nix;

  sshConfig = {
    compression = false;
    forwardAgent = true;
    serverAliveInterval = 30;
    extraConfig = "IPQoS throughput";
    matchBlocks = options.sshHosts;
  };

  privateFiles = if ! options.desktop.enable then {} else {
    ssh = {
      source = ~/.dotfiles/ssh;
      target = ".ssh";
      recursive = true;
    };
    # gnupg = {
    #   source = ~/.dotfiles/gnupg;
    #   target = ".gnupg";
    #   recursive = true;
    # };
  };

  extraDotfiles = [
    # "aliases"
    "bcrc"
    "codex"
    "ghci"
    "haskeline"
  ];

  gitUser = options.gitUser;
in
{
  require = [
    (if options.desktop.enable then
      import ./desktop.nix { inherit pkgs options; }
     else {}
    )
    (if options.wsl.enable then
      import ./wsl.nix { inherit pkgs options; }
     else {}
    )
  ];

  nixpkgs.overlays = [
    (import ./overlays/wavebox.nix)
    (import ./overlays/minio-client.nix)
    (import ./overlays/dotnet-sdk.nix)
    (import ./overlays/vscode.nix)
  ];

  home.file = {
    local-bin = {
      source = ~/.dotfiles/local/bin;
      target = ".local/bin";
      recursive = true;
    };
  }
  // privateFiles
  // builtins.foldl' (a: x:
    let
      mkHomeFile = x: {
        ${x} = {
          source = ~/. + "/.dotfiles/${x}";
          target = ".${x}";
        };
      };
    in
      a // mkHomeFile x) {} extraDotfiles;

  home.packages = import ./packages.nix { inherit pkgs options; };

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
    # LS_COLORS = "no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:";
    GIT_ALLOW_PROTOCOL = "ssh:https:keybase:file";
    # DOTNET_ROOT = pkgs.dotnetCorePackages.sdk_3_1;
    DOTNET_ROOT = pkgs.sdk_3_1_403;
    # SSH_AUTH_SOCK = "$HOME/.gnupg/S.gpg-agent.ssh";
  };

  programs = {
    htop.enable = true;
    man.enable = true;
    lesspipe.enable = false;
    dircolors.enable = true;

    fish = {
      enable = true;
      functions = {
        winpass = "pass $argv | head -1 | clip.exe";
        ssh-add = ''
          if test (count $argv) = 0
            gpg-connect-agent updatestartuptty /bye
          end
          /usr/bin/env ssh-add $argv
        '';
      };
      shellInit = ''
        set -e TMUX_TMPDIR
        set PATH ~/.local/bin $HOME/.nix-profile/bin ~/.dotnet/tools $PATH
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
        tw = "timew";
        vim = "nvim";
        home-manager = "home-manager -f ~/.dotfiles/config/nixpkgs/home.nix";
        lock = "xset s activate";
      };
    };

    neovim =
      let
        vimPlugins = pkgs.vimPlugins // {
          vim-gnupg = pkgs.vimUtils.buildVimPlugin {
            name = "vim-gnupg";
            src = ~/.dotfiles/vim-plugins/vim-gnupg;
          };
          vim-ionide = pkgs.vimUtils.buildVimPlugin {
            name = "vim-ionide";
            src = ~/.dotfiles/vim-plugins/Ionide-vim;
            buildInputs = [ pkgs.curl pkgs.which pkgs.unzip ];
          };
          jonas = pkgs.vimUtils.buildVimPlugin {
            name = "jonas";
            src = ~/.dotfiles/vim-plugins/jonas;
          };
        };
        devPlugins =
          if options.vimDevPlugins then
            with vimPlugins; [
              LanguageClient-neovim
              idris-vim
              neco-ghc
              purescript-vim
              vim-ionide
            ]
          else [];
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
        ] ++ devPlugins;
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
    } // gitUser;

    ssh = {
      enable = true;
    } // sshConfig;

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
        set-option -g default-shell ${pkgs.fish}/bin/fish
      '';
    };

    home-manager = {
      enable = true;
      path = "https://github.com/rycee/home-manager/archive/master.tar.gz";
    };
  };

  systemd.user.startServices = true;
  systemd.user.sessionVariables = {
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
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

  services.unison = {
    enable = false;
    pairs = {
      docs = [ "/home/$USER/Documents"  "ssh://example/Documents" ];
    };
  };
}
