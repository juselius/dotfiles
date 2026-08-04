{ lib, pkgs, ... }:
with lib;
let
  fsharp-grammar =
    (pkgs.tree-sitter.buildGrammar {
      language = "fsharp";
      location = "fsharp";
      version = "0.3.11";
      src = pkgs.fetchFromGitHub {
        owner = "ionide";
        repo = "tree-sitter-fsharp";
        rev = "789d8ea1481345d6f3bc1a06985dbf6a6b202744";
        hash = "sha256-bLrzd1s2emzGbrESfZj/kNSEtbUtV5rQbYxCn33dvrY=";
      };
      meta.homepage = "https://github.com/ionide/tree-sitter-fsharp";
    }).overrideAttrs
      {
        # NOTE: We override the installPhase in order to place the queries under
        # queries/fsharp, so we can later add it to the nvim runtimepath.
        installPhase = ''
          runHook preInstall
          mkdir -p $out/queries/fsharp
          if [[ -d ../queries ]]; then
            cp ../queries/*.scm $out/queries/fsharp
          fi
          mv parser $out/
          runHook postInstall
        '';
      };
  configuration = {
    programs.neovim = {
      enable = true;
      # NOTE: We prepend the fsharp-grammar path to the runtimepath here, so its queries
      # (which we correctly placed under queries/fsharp earlier) take precedence over
      # the default nvim-treesitter queries, which are outdated.
      initLua = "vim.opt.rtp:prepend('${fsharp-grammar}')";
      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          fsharp-grammar
        ]))
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
      nixd
      fsautocomplete
      lua-language-server
      statix
      nixfmt
      tinymist
      vscode-json-languageserver
      hadolint
    ];
  };
in
{
  options.dotfiles = { };

  config = mkMerge [ configuration ];
}
