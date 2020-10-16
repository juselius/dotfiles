self: super:
let
  dotnet-sdk-3 =
    with self.pkgs;
    let
      version = "3.1.403";
      netCoreVersion = "3.1.9";
      rpath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc libunwind libuuid icu openssl zlib curl libkrb5
      ];

      dotnet-sdk =
        stdenv.mkDerivation rec {
          inherit version netCoreVersion;
          pname = "dotnet-sdk";

          src = fetchurl {
            url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
            sha512 = "3m8hzlkyd59xw64zg29nly6100mrdny9m82n3bzdw7f3dcaj64bsvpppw46s90dp8rs3w5z0kk40kp4sv112cp8nq2byhlhivp1j0qa";
          };

          sourceRoot = ".";

          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r ./ $out
            runHook postInstall
          '';

          dontPatchelf = true;

          # the dotnet executable cannot be wrapped, must use patchelf.
          # autoPatchelf isn't able to be used as libicu* and other's aren't
          # listed under typical binary section
          postFixup = ''
            for i in \
              dotnet \
              sdk/${version}/AppHostTemplate/apphost \
              packs/Microsoft.NETCore.App.Host.linux-x64/${netCoreVersion}/runtimes/linux-x64/native/apphost
            do
              patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/$i
              patchelf --set-rpath "${rpath}" $out/$i
            done
            find $out -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
          '';

          doInstallCheck = true;
          installCheckPhase = ''
            $out/dotnet --info
          '';

          meta = with stdenv.lib; {
            homepage = https://dotnet.github.io/;
            description = ".NET Core SDK ${version} with .NET Core ${netCoreVersion}";
            platforms = [ "x86_64-linux" ];
            maintainers = with maintainers; [ "jonringer" ];
            license = licenses.mit;
          };
        };

      dotnet-wrapper =
        pkgs.writeScriptBin "dotnet" ''
            #!${pkgs.bash}/bin/bash

            d=/tmp/dotnet-sdk/${version}

            if [ ! -d $d ]; then
              echo "Copying SDK to temporary DOTNET_ROOT=$d"
              mkdir -p $d

              cp -r ${dotnet-sdk}/* $d
              chmod -R u+w $d
            fi

            export DOTNET_ROOT=$d
            exec $d/dotnet $@
        '';
    in
      dotnet-wrapper;
in
{
  dotnet-sdk = dotnet-sdk-3;
  sdk_3_1_403 = dotnet-sdk-3;
}
