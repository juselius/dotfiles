{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dotfiles.desktop;
  sources = import ../npins;
  noctalia = pkgs.callPackage "${sources.noctalia-shell}/nix/package.nix" { };
  noctalia-shell = {

    programs.noctalia-shell = {
      enable = true;
      package = noctalia;
      # settings = {
      #   # configure noctalia here
      #   bar = {
      #     # density = "compact";
      #     # position = "right";
      #     showCapsule = false;
      #     widgets = {
      #       left = [
      #         {
      #           id = "ControlCenter";
      #           useDistroLogo = true;
      #         }
      #         {
      #           id = "WiFi";
      #         }
      #         {
      #           id = "Bluetooth";
      #         }
      #       ];
      #       center = [
      #         {
      #           hideUnoccupied = false;
      #           id = "Workspace";
      #           labelMode = "none";
      #         }
      #       ];
      #       right = [
      #         {
      #           alwaysShowPercentage = false;
      #           id = "Battery";
      #           warningThreshold = 30;
      #         }
      #         {
      #           formatHorizontal = "HH:mm";
      #           formatVertical = "HH mm";
      #           id = "Clock";
      #           useMonospacedFont = true;
      #           usePrimaryColor = true;
      #         }
      #       ];
      #     };
      #   };
      #   # colorSchemes.predefinedScheme = "Monochrome";
      #   general = {
      #     # avatarImage = "/home/drfoobar/.face";
      #     radiusRatio = 0.2;
      #   };
      #   location = {
      #     monthBeforeDay = true;
      #     name = "Marseille, France";
      #   };
      # };
      # this may also be a string or a path to a JSON file,
      # but in this case must include *all* settings.
    };
  };
in
{
  options.dotfiles.desktop = {
    noctalia-shell = {
      enable = mkEnableOption "Enable noctalia-shell";
    };
  };

  config = mkMerge [
    (mkIf (cfg.wayland.enable && cfg.noctalia-shell.enable) noctalia-shell)
  ];

  imports = [
    (import "${sources.noctalia-shell}/nix/home-module.nix")
  ];
}
