{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.wsl;

  configuration = {
    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 43200; # 12 hours
        defaultCacheTtlSsh = 64800; # 18 hours
        maxCacheTtl = 64800;
        maxCacheTtlSsh = 64800;
        pinentryPackage = pkgs.pinentry-curses;
        extraConfig = ''
          pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
        '';
      };
    };
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
    programs.gpg = {
      enable = true;
      settings = {
        use-agent = true;
      };
    };
    dotfiles.plainNix = true;
    home.packages = [
      pkgs.pass
    ];
  };
in {
  options.dotfiles.wsl = {
    enable = mkEnableOption "Enable WSL2 tweaks";
  };

  config = mkIf cfg.enable configuration;
}
