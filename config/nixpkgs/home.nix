{pkgs, lib, ...}:
{
  dotfiles = {
    desktop = {
      enable = false;
      dropbox.enable = false;
    };
    packages = {
      devel = {
        enable = true;
        dotnet = true;
        node = true;
        rust = true;
        db = true;
      };
      desktop = {
        wavebox = true;
        zoom = true;
      };
      kubernetes = true;
      cloud = true;
      geo = true;
    };
    extraDotfiles = [
      "bcrc"
      "codex"
      "ghci"
      "haskeline"
      "taskrc"
    ];
    sshFiles = true;
    vimDevPlugins = true;
  };

  home.packages = with pkgs; [
    openfortivpn
  ];

  imports = [ ./modules ];
}
