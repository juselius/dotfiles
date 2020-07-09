{ pkgs, options, ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 43200; # 12 hours
      defaultCacheTtlSsh = 64800; # 18 hours
      maxCacheTtl = 64800;
      maxCacheTtlSsh = 64800;
      pinentryFlavor = "curses";
    };
  };
}
