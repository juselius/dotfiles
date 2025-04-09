self: super:
let
  pkgs = super;
  lib = pkgs.lib;
  stdenv = pkgs.stdenv;

  version = "1.0";

  src = pkgs.fetchFromGitHub {
      owner = "Azure";
      repo = "Bridge-To-Kubernetes";
      rev = "main";
      sha256 = "sha256-hjHTEt2VQoqSouK90z044NqxPrsu6EcCAwm+B/6KvqI=";
  };

  rpath = pkgs.lib.makeLibraryPath [
      pkgs.openssl
      pkgs.icu
  ];

in rec {
  dsc = stdenv.mkDerivation {
    name = "bridge-to-kubernetes-${version}";

    src = ~/src/Bridge-To-Kubernetes/src/dsc/dist;

    buildCommand = ''
        mkdir -p $out/lib
        cp -r $src $out/lib/Bridge-To-Kubernetes
        chmod -R u+w $out/lib/Bridge-To-Kubernetes
        mkdir -p $out/lib/Bridge-To-Kubernetes/kubectl/linux
        cp -s ${pkgs.kubectl}/bin/kubectl $out/lib/Bridge-To-Kubernetes/kubectl/linux

        wrapProgram $out/lib/Bridge-To-Kubernetes/dsc --set LD_LIBRARY_PATH ${rpath}
        wrapProgram $out/lib/Bridge-To-Kubernetes/EndpointManager/EndpointManager --set LD_LIBRARY_PATH ${rpath}

        mkdir $out/bin
        cp -s $out/lib/Bridge-To-Kubernetes/dsc $out/bin/dsc
    '';


    buildInputs = with pkgs; [
      powershell
      dotnet-sdk
      openssl
      makeWrapper
      kubectl
    ];

    meta = with lib; {
      description = "Bridge-To-Kubernetes";
      homepage = https://github.com/Azure/Bridge-To-Kubernetes;
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };

  # b2k = pkgs.buildDotnetModule {
  #   pname = "b2k";
  #   baseName = "b2k";
  #   inherit version src;

  #   nugetDeps = ./deps.nix;

  #   executables = [ "dsc" ];

  #   runtimeDeps = [
  #       pkgs.openssl
  #   ];

  #   dotnet-sdk = pkgs.dotnet-sdk_6;
  #   dotnet-runtime = pkgs.dotnet-sdk_6;

  #   projectFile = "src/dsc/dsc.csproj";

  #   patches = [ ./b2k.patch ];

  #   postFixup = ''
  #       mkdir -p $out/lib/b2k/kubectl/linux
  #       cp ${pkgs.kubectl}/bin/kubectl $out/lib/b2k/kubectl/linux/kubectl
  #       mkdir $out/lib/b2k/EndpointManager
  #       cp -r ${endpointManager}/bin/EndpointManager $out/lib/b2k/EndpointManager/EndpointManager
  #       # cd $out/lib/b2k/EndpointManager
  #       # chmod -R u+w $out/lib/b2k/EndpointManager
  #       # mv EndpointManager .EndpointManager
  #       # sed "s|^exec .*/EndpointManager\" .*|exec \"$out/lib/b2k/EndpointManager/.EndpointManager\" \"\$@\"|" ${endpointManager}/bin/EndpointManager > $out/lib/b2k/EndpointManager/EndpointManager
  #       # chmod 755 $out/lib/b2k/EndpointManager/EndpointManager
  #   '';

  #   nativebuildInputs = with pkgs; [
  #     powershell
  #     makeWrapper
  #   ];

  #   buildInputs = with pkgs; [
  #     dotnet-sdk_6
  #     kubectl
  #     endpointManager
  #   ];

  #   meta = with lib; {
  #     description = "Bridge-To-Kubernetes";
  #     homepage = https://github.com/Azure/Bridge-To-Kubernetes;
  #     license = licenses.mit;
  #     platforms = [ "x86_64-linux" ];
  #   };
  # };

  # endpointManager = pkgs.buildDotnetModule {
  #   pname = "b2k-EndpointManager";
  #   baseName = "b2k-EndpointManager";
  #   inherit version;
  #   inherit src;

  #   nugetDeps = ./deps.nix;

  #   executables = [ "EndpointManager" ];

  #   runtimeDeps = [
  #       pkgs.openssl
  #   ];

  #   dotnet-sdk = pkgs.dotnet-sdk_6;
  #   dotnet-runtime = pkgs.dotnet-sdk_6;

  #   projectFile = "src/endpointmanager/endpointmanager.csproj";

  #   patches = [ ./b2k.patch ];

  #   nativebuildInputs = with pkgs; [
  #     powershell
  #     makeWrapper
  #   ];

  #   buildInputs = with pkgs; [
  #     dotnet-sdk_6
  #   ];

  #   meta = with lib; {
  #     description = "Bridge-To-Kubernetes EndpointManager";
  #     homepage = https://github.com/Azure/Bridge-To-Kubernetes;
  #     license = licenses.mit;
  #     platforms = [ "x86_64-linux" ];
  #   };
  # };
}
