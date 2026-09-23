{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dotfiles.desktop.niri;

  niri = {
    home.packages = with pkgs; [
      wev
      wl-clipboard
      wofi
      wofi-pass
    ];

    xdg.configFile = {
      "niri/config.kdl" = {
        source =
          (pkgs.replaceVars ../config/niri/config.kdl { monitor = builtins.elemAt cfg.monitor 0; }).outPath;
      };
    };

    services = {
      # Notification engine using gnome
      swaync.enable = false;
      hyprpolkitagent.enable = true;

      # For sleeping Zzz
      hypridle = {
        enable = true;
        settings = {
          general = {
            ignore_dbus_inhibit = false;
            lock_cmd = "~/.nix-profile/bin/noctalia msg session lock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 900;
              on-timeout = "loginctl lock-session";
            }

            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

    };
  };
in
{
  options.dotfiles.desktop = {
    niri = {
      enable = mkEnableOption "Enable Niri";
      monitor = mkOption {
        type = types.listOf types.str;
        default = [ "eDP-1" ];
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable niri)
  ];
}
