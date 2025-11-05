{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dotfiles;
  configuration = {
    programs.neovim = {
      enable = true;
      plugins = with vimPlugins;
        [
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
      fish-lsp
      nil
      fsautocomplete
      lua-language-server
      statix
      nixfmt
    ];
  };
in {
  options.dotfiles = { };

  config = mkMerge [ configuration ];
}
