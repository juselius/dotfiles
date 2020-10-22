pkgs:
{
  desktop = {
    laptop = true;
    enable = true;
    dropbox = false;
  };
  wsl.enable = false;
  dotnet = rec {
    enable = false;
    sdk = pkgs.dotnetCorePackages.sdk_5_0;
    root =
      if enable then
        { DOTNET_ROOT = sdk; }
      else
        {};
  };
  node = false;
  haskell = false;
  python = false;
  proton = false;
  languages = false;
  vimDevPlugins = true;
  eth = "wlp0s20f3";
  gitUser = {
    userEmail = "jonas.juselius@itpartner.no";
    userName = "Jonas Juselius";
    signing = {
      key = "jonas.juselius@gmail.com";
    };
  };
  sshHosts = {
    example = {
      user = "demo";
      hostname = "acme.com";
    };
  };

}

