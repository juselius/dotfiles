{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.packages.desktop;

  configuration = {
    dotfiles.packages.desktop = {
      media = mkDefault true;
      x11 = mkDefault true;
      gnome = mkDefault true;
      chat = mkDefault true;
      graphics = mkDefault true;
    };

    home.packages = enabledPackages;
  };

  media = with pkgs; [
    # guvcview # webcam
    # shotcut
    inkscape
    obs-studio
    audacity
    xf86_input_wacom
    mpv
  ];

  x11 = with pkgs.xorg; [
    appres
    editres
    listres
    viewres
    luit
    xdpyinfo
    xdriinfo
    xev
    xfd
    xfontsel
    xkill
    xlsatoms
    xlsclients
    xlsfonts
    xmessage
    xprop
    xvinfo
    xwininfo
    xmessage
    xvinfo
    xmodmap
    pkgs.glxinfo
    pkgs.xclip
    pkgs.xsel
    pkgs.arandr
  ];

  gnome = with pkgs.gnome3; [
    gnome-settings-daemon
    gnome-font-viewer
    adwaita-icon-theme
    gnome-themes-extra
    evince
    gnome-calendar
    gnome-bluetooth
    seahorse
    nautilus
    gnome-disk-utility
    gnome-tweaks
    eog
    networkmanager-fortisslvpn
    gnome-keyring
    dconf-editor
    pkgs.desktop-file-utils
    pkgs.gcolor3
    pkgs.lxappearance
  ];

  graphics = with pkgs; [
    imagemagick
    scrot
    krita
    # inkscape
  ];

  desktop = with pkgs; [
    #wireshark-qt
    google-chrome
    firefox
    drive
    rdesktop
    remmina
    # googleearth
    # taskwarrior
    # timewarrior
    pass
    pavucontrol
    # spotify
    # ledger
    # browserpass
    blueman
    gparted
    # calibre
    fira-code
    keybase
    keybase-gui
    pandoc
    pinentry
    polkit_gnome
    # cdrtools
    innoextract
    tectonic
    unrtf
    # virt-manager
    qrencode
    zbar
    yubikey-personalization
    dconf
  ];

  chat = with pkgs; [
    # teams
    signal-desktop
    # discord
    # slack
    # pidgin
    # pidginsipe
  ];

  devel = with pkgs; [
      sqlitebrowser
  ];

  useIf = x: y: if x then y else [];

  enabledPackages =
    desktop ++
    useIf cfg.gnome gnome ++
    useIf cfg.x11 x11 ++
    useIf cfg.media media ++
    useIf cfg.chat chat ++
    useIf cfg.graphics graphics ++
    useIf config.dotfiles.packages.devel.enable devel;


in {
  options.dotfiles.packages.desktop = {
    media = mkEnableOption "Enable media packages";
    chat = mkEnableOption "Enable chat clients";
    x11 = mkEnableOption "Enable x11 packages";
    gnome = mkEnableOption "Enable gnome packages";
    graphics = mkEnableOption "Enable graphics packages";
  };

  config = mkIf config.dotfiles.desktop.enable (mkMerge [ configuration ]);


}
