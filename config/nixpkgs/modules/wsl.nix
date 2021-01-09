{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.wsl;

  configuration = {
    programs.fish = {
      functions = {
        winpass = "pass $argv | head -1 | clip.exe";
        ssh-add = ''
          if test (count $argv) = 0
            gpg-connect-agent updatestartuptty /bye
          end
          /usr/bin/env ssh-add $argv
        '';
      };
    };
    dotfiles.plainNix = true;
  };
in {
  options.dotfiles.wsl = {
    enable = mkEnableOption "Enable WSL2 tweaks";
  };

  config = mkIf cfg.enable configuration;
}
