{ pkgs, cfg, ...}:
{
  programs = {
    git = {
      userEmail = "jonas.juselius@itpartner.no";
      userName = "Jonas Juselius";
      signing = {
        key = "jonas.juselius@gmail.com";
      };
    };

    ssh.matchBlocks = {
      example = {
        user = "demo";
        hostname = "acme.com";
      };
    };
  };
}

