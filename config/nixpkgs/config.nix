{
  allowUnfree = true;
  permittedInsecurePackages = [
    "mono-4.6.2.16"
  ];
  packageOverrides = pkgs: with pkgs; {
    myTerraform = terraform.withPlugins (ps: with ps; [
      libvirt
    ]);
  };
}

