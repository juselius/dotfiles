{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.dotfiles;
  nvim = {
    programs.neovim =
      let
        fsharp-grammar =
          let
            drv = pkgs.tree-sitter.buildGrammar {
              language = "fsharp";
              version = "0.1.x";
              location = "fsharp";
              src = pkgs.fetchFromGitHub {
                owner = "ionide";
                repo = "tree-sitter-fsharp";
                rev = "f29605148f24199cf4d9c4a203a5debc0cbcc648";
                hash = "sha256-xcejOUhJvECH9taGV0BR5TmTVluF6FSaO68Lg9wlTEc=";
              };
              meta.homepage = "https://github.com/ionide/tree-sitter-fsharp";
            };
          in
          drv.overrideAttrs (attrs: {
            installPhase = ''
              runHook preInstall
              mkdir $out
              mv parser $out/
              if [[ -d ../queries ]]; then
                cp -r ../queries $out
              fi
              runHook postInstall
            '';
          });

        vimPlugins = pkgs.vimPlugins // {
          copilot = pkgs.vimUtils.buildVimPlugin {
            name = "copilot.vim";
            src = pkgs.fetchFromGitHub {
                owner = "github";
                repo = "copilot.vim";
                rev = "main";
                hash = "sha256-dL+yxTPSjX5PDJ4LgqFoS1HtkZV9G1S6VD+w+CPhil8=";
              };
          };
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
          treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
            # NOTE: Recommended to be in "ensure_installed"
            p.c
            p.lua
            p.vim
            p.vimdoc
            p.query
            p.typst

            fsharp-grammar
            p.bash
            p.bibtex
            p.c_sharp
            p.cue
            p.cpp
            p.css
            p.dhall
            p.dockerfile
            p.fish
            p.git_rebase
            p.gitattributes
            p.gitignore
            p.glsl
            p.go
            p.html
            p.javascript
            p.latex
            p.markdown
            p.markdown_inline
            p.nix
            p.python
            p.rust
            p.sql
            p.typescript
            p.yaml
            p.zig
          ]);
          jonas = pkgs.vimUtils.buildVimPlugin {
            name = "jonas";
            src = ~/.dotfiles/plugins/vim-plugins/jonas;
          };
        };
      in {
        enable = true;
        plugins = with vimPlugins; [
          jonas
          lazy-nvim
          copilot
          vim-airline
          vim-airline-themes
          cmp-buffer
          cmp_luasnip
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          commentary
          fugitive
          Ionide-vim
          lsp-zero-nvim
          # friendly-snippets
          # luasnip
          # markdown-preview-nvim
          # NeoSolarized
          nvim-cmp
          nvim-dap
          nvim-lspconfig
          plenary-nvim
          telescope-nvim
          treesitter
          vim-gnupg
          vim-nix
        # vim-singularity-syntax
          vim-surround
          vimtex
          vim-vsnip
          zephyr-nvim
          vim-helm
        ];
    };
    xdg.configFile = {
      nvim = {
        source = ~/.dotfiles/config/nvim;
        target = "nvim";
        recursive = true;
      };
    };
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
