self: super:
let
  patch = attrs:
        attrs.postPatch + ''
        patchelf --set-interpreter $interpreter lib/ReSharperHost/linux-x64/Rider.Backend
        patchelf --set-rpath ${rpath} lib/ReSharperHost/linux-x64/Rider.Backend
        for i in \
            jbr/bin/java \
            jbr/bin/javac \
            jbr/bin/javadoc \
            jbr/bin/jcmd \
            jbr/bin/jdb \
            jbr/bin/jfr \
            jbr/bin/jhsdb \
            jbr/bin/jinfo \
            jbr/bin/jmap \
            jbr/bin/jps \
            jbr/bin/jrunscript \
            jbr/bin/jstack \
            jbr/bin/jstat \
            jbr/bin/keytool \
            jbr/bin/rmiregistry \
            jbr/bin/serialver \
            jbr/lib/chrome-sandbox \
            jbr/lib/jcef_helper \
            jbr/lib/jexec \
            jbr/lib/jspawnhelper; do
          patchelf --set-interpreter $interpreter $i
          patchelf --add-rpath ${rpath} $i
        done
        for i in \
            plugins/cidr-debugger-plugin/bin/lldb/linux/bin/LLDBFrontend \
            plugins/cidr-debugger-plugin/bin/lldb/linux/bin/lldb \
            plugins/cidr-debugger-plugin/bin/lldb/linux/bin/lldb-argdumper \
            plugins/cidr-debugger-plugin/bin/lldb/linux/bin/lldb-server \
            plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer \
            plugins/remote-dev-server/selfcontained/bin/Xvfb \
            plugins/remote-dev-server/selfcontained/bin/xkbcomp; \
        do patchelf --set-interpreter $interpreter $i; done
        sed -i 's/runtime\.sh/runtime-dotnet.sh/' lib/ReSharperHost/Rider.Backend.sh
        '';

  jetbrainsNix = "/nix/var/nix/profiles/per-user/root/channels/nixos/pkgs/applications/editors/jetbrains";
  jetbrains = super.callPackage jetbrainsNix { jdk = super.jdk; };
  eap = "EAP7-223.7401.6";
  rider-eap = jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.3";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-${eap}.Checked.tar.gz";
        sha256 = "sha256-Ujh9Sc3pFXEuRubupcnNFZjPtCYMbib0fXar9gjBmIo=";
      };

      postPatch = patch attrs;

      postInstall = ''
        cd $out/rider/lib/ReSharperHost/linux-x64/dotnet
        ln -sf ${super.dotnet-sdk_6}/dotnet .
        ln -s ${super.dotnet-sdk_6}/host .
        ln -s ${super.dotnet-sdk_6}/shared .
      '';
  });

  rpath = with super; super.lib.makeLibraryPath [ stdenv.cc.cc.lib zlib ];
  rider-latest = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.2.3";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "sha256-L9/4YW/RV0oO97qu2FWqOaElTqFkt00bTdoRJB5Yqy0=";
      };

      postPatch = patch attrs;

      postInstall = ''
        cd $out/rider/lib/ReSharperHost/linux-x64/dotnet
        ln -sf ${super.dotnet-sdk_5}/dotnet .
        ln -s ${super.dotnet-sdk_5}/host .
        ln -s ${super.dotnet-sdk_5}/shared .
      '';
  });
in
{
  rider = rider-latest;
  rider-stable = rider-latest;
  rider-eap = rider-eap;
}
