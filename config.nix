{
  allowUnfree = true;

  permittedInsecurePackages = [
    "dotnet-sdk-wrapped-7.0.410"
  ];

  packageOverrides = pkgs: with pkgs; {
  };
}

