{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.dotfiles;
  homeFiles =
    {
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
        ];
    in { programs.neovim.plugins = devPlugins; };
  dotnet = {
    home.packages = [ cfg.devel.dotnet.sdk ];
    home.sessionVariables.DOTNET_ROOT = cfg.devel.dotnet.sdk;
  };
in
{
  options.dotfiles = {
    desktop = {
      enable = mkEnableOption "Enable desktop features";
      laptop.enable = mkEnableOption "Enable laptop customizations";
      dropbox.enable = mkEnableOption "Enable dropbox";
      eth = mkOption {
        type = types.str;
        default = "eth0";
        description = "Default net device for polybar";
      };
    };

    wsl2.enable = mkEnableOption "Enable WSL2 features";

    devel = {
      dotnet = {
        enable = mkEnableOption "Enable dotnet sdk";
        sdk = mkOption {
          type = types.package;
          default = pkgs.dotnetCorePackages.sdk_5_0;
        };
      };
      node.enable = mkEnableOption "Enable Node.js";
      haskell.enable = mkEnableOption "Enable Haskell";
      python.enable = mkEnableOption "Enable Python";
      extraLanguages.enable = mkEnableOption "Enable extra programming languages";
      vimDevPlugins.enable = mkEnableOption "Enable vim devel plugins";
    };

    proton.enable = mkEnableOption "Enable Proton VPN";

    extraDotfiles = mkOption {
      type = types.listOf types.str;
      default = [];
    };

    sshFiles.enable = mkEnableOption "Enable ssh files in ~/.dotfiles/ssh";
  };

  config = mkMerge [
    homeFiles

    (mkIf cfg.sshFiles.enable sshFiles)

    (mkIf cfg.devel.dotnet.enable dotnet)

    (mkIf cfg.devel.vimDevPlugins.enable vimPlugins)

    (mkIf cfg.desktop.enable  (import ./desktop.nix { inherit pkgs cfg; }))

    (mkIf cfg.wsl2.enable  (import ./wsl.nix { inherit pkgs cfg; }))

    { home.packages = import ./packages.nix { inherit pkgs cfg; }; }
  ];
}

