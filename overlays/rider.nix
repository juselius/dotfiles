self: super:
let
  rpath = with super; super.lib.makeLibraryPath [ stdenv.cc.cc.lib zlib ];

  patch = attrs:
        attrs.postPatch + ''
        patchelf --set-interpreter $interpreter lib/ReSharperHost/linux-x64/Rider.Backend
        patchelf --set-rpath ${rpath} lib/ReSharperHost/linux-x64/Rider.Backend
        for i in \
            plugins/cidr-debugger-plugin/bin/lldb/linux/x64/bin/LLDBFrontend \
            plugins/cidr-debugger-plugin/bin/lldb/linux/x64/bin/lldb \
            plugins/cidr-debugger-plugin/bin/lldb/linux/x64/bin/lldb-argdumper \
            plugins/cidr-debugger-plugin/bin/lldb/linux/x64/bin/lldb-server \
            plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer \
            plugins/remote-dev-server/selfcontained/bin/Xvfb \
            plugins/remote-dev-server/selfcontained/bin/xkbcomp; \
        do patchelf --set-interpreter $interpreter $i; done
        sed -i 's/runtime\.sh/runtime-dotnet.sh/' lib/ReSharperHost/Rider.Backend.sh

        # NOTE(simkir): Replacing their net6 dotnet with our net7. Wasn't allowed
        # to do this in the postInstall step, so doing it here.
        rm -rf lib/ReSharperHost/linux-x64/dotnet
        ln -sf ${super.dotnet-sdk_7} lib/ReSharperHost/linux-x64/dotnet
        '';

  jetbrainsNix = "/nix/var/nix/profiles/per-user/root/channels/nixos/pkgs/applications/editors/jetbrains";
  jetbrains = super.callPackage jetbrainsNix { };

  eap = "EAP4-232.7295.15.Checked";
  rider-eap = jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2023.2";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download-cdn.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.tar.gz";
        sha256 = "sha256-OVu7QVplfjQSv5E6Tg+kcLzPW4STYlugYU3wFhrsy1A=";
      };

      # postPatch = patch attrs;

      postInstall = ''
        cd $out/rider/lib/ReSharperHost/linux-x64/dotnet
        # ln -sf ${super.dotnet-sdk_6}/dotnet .
        # ln -s ${super.dotnet-sdk_6}/host .
        # ln -s ${super.dotnet-sdk_6}/shared .
      '';
  });

  rider-latest = jetbrains.rider.overrideAttrs (attrs: rec {
    version = "2023.2.2";
    name = "rider-${version}";

    src = super.fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "sha256-oystBoJhPzr6zRHqwaefAiyZ4X75qyP+JsXY00sJOtg=";
    };

    postPatch = patch attrs;
  });
in
{
  rider = rider-latest;
  rider-stable = rider-latest;
  rider-eap = rider-eap;
}
