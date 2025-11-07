{ lib, pkgs, ... }:
with lib;
let
  configuration = {
    programs.neovim = {
      enable = true;
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
      nixd
      fsautocomplete
      lua-language-server
      statix
      nixfmt-rfc-style
      tinymist
      nodePackages.vscode-json-languageserver
    ];
  };
in
{
  options.dotfiles = { };

  config = mkMerge [ configuration ];
}
