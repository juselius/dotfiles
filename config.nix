{
  allowUnfree = true;

  permittedInsecurePackages = [
    "dotnet-sdk-wrapped-7.0.410"
  ];

  packageOverrides = pkgs: with pkgs; {
    myTerraform = terraform.withPlugins (ps: with ps; [
      libvirt
    ]);
  };
}

