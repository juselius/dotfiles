{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dotfiles.desktop;

  wayland =
    let
      wallpaper = "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";
    in
    {
      home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = 1;
      };

      programs.swaylock = {
        enable = true;
        settings = {
          color = "202020";
          image = wallpaper;
          scaling = "fill";
          font-size = 24;
          indicator-idle-visible = false;
          indicator-radius = 75;
          line-color = "ffffff";
          show-failed-attempts = true;
        };
      };

      home.packages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        wezterm
        wf-recorder
        wev
        wofi
        wofi-pass
        wlr-randr
        wdisplays
        sway-contrib.grimshot
        clipman
        swaybg
        # networkmanager
        networkmanager_dmenu
        networkmanagerapplet
      ];

      services.mako = {
        enable = true;
        settings = {
          border-size = 2;
          default-timeout = 2500;
        };
      };

    };

in
{
  options.dotfiles.desktop = {
    wayland = {
      enable = mkEnableOption "Enable wayland";
    };
  };

  config = mkMerge [
    (mkIf cfg.wayland.enable wayland)
  ];

  imports = [
    ./waybar.nix
    ./noctalia.nix
    ./hyprland.nix
    ./niri.nix
    ./i3-sway.nix
  ];
}
