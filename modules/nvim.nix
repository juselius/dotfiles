{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.dotfiles;
  nvim = {
    programs.neovim =
      {
        enable = true;
        plugins = with vimPlugins; [
          # nvim-cmp
          # plenary-nvim
          # vim-gnupg
          # vim-nix
          # vim-surround
          # vimtex
          # vim-vsnip
          # vim-helm
          # friendly-snippets
          # luasnip
        ];
    };
    xdg.configFile = {
      nvim = {
        source = ~/.dotfiles/config/nvim;
        target = "nvim";
        recursive = true;
      };
    };
    home.packages = with pkgs; [
      tree-sitter
    ];
  };

  lazyvim = {
    programs.neovim = {
      enable = true;
    };
    xdg.configFile = {
      nvim = {
        source = ~/.dotfiles/config/lazyvim;
        target = "nvim";
        recursive = true;
      };
    };
  };
in
{
  options.dotfiles = {
    lazyvim = mkEnableOption "Enable lazyvim IDE";
  };

  config = mkMerge [
    (mkIf cfg.lazyvim lazyvim)
    (mkIf (!cfg.lazyvim) nvim)
  ];
}
