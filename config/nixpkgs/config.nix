{
  allowUnfree = true;
  permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];
  packageOverrides = pkgs: with pkgs; {
    myTerraform = terraform.withPlugins (ps: with ps; [
      libvirt
    ]);
  };
}

