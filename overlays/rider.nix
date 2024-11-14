self: super:
let
  rpath = with super; super.lib.makeLibraryPath [ stdenv.cc.cc.lib zlib ];

  loName = super.lib.toLower "Rider";
  hiName = super.lib.toUpper "Rider";
  vmoptsName = loName
    + super.lib.optionalString super.stdenv.hostPlatform.is64bit "64"
    + ".vmoptions";

  postPatch = with super; ''
    get_file_size() {
      local fname="$1"
      echo $(ls -l $fname | cut -d ' ' -f5)
    }

    munge_size_hack() {
      local fname="$1"
      local size="$2"
      strip $fname
      truncate --size=$size $fname
    }

    rm -rf jbr
    # When using the IDE as a remote backend using gateway, it expects the jbr directory to contain the jdk
    ln -s ${jdk.home} jbr

    interpreter=$(echo ${stdenv.cc.libc}/lib/ld-linux*.so.2)
    if [[ "${stdenv.hostPlatform.system}" == "x86_64-linux" && -e bin/fsnotifier64 ]]; then
      target_size=$(get_file_size bin/fsnotifier64)
      patchelf --set-interpreter "$interpreter" bin/fsnotifier64
      munge_size_hack bin/fsnotifier64 $target_size
    else
      target_size=$(get_file_size bin/fsnotifier)
      patchelf --set-interpreter "$interpreter" bin/fsnotifier
      munge_size_hack bin/fsnotifier $target_size
    fi

    if [ -d "plugins/remote-dev-server" ]; then
      patch -p1 < ${./JetbrainsRemoteDev.patch}
    fi

    vmopts_file=bin/linux/${vmoptsName}
    if [[ ! -f $vmopts_file ]]; then
      vmopts_file=bin/${vmoptsName}
      if [[ ! -f $vmopts_file ]]; then
        echo "ERROR: $vmopts_file not found"
        exit 1
      fi
    fi
    echo -Djna.library.path=${lib.makeLibraryPath ([
      libsecret e2fsprogs libnotify
      # Required for Help -> Collect Logs
      # in at least rider and goland
      udev
    ])} >> $vmopts_file
  '';

  patch = attrs:
        postPatch + ''
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

        # NOTE(simkir): Replacing their net7 dotnet with our net8. Wasn't allowed
        # to do this in the postInstall step, so doing it here.
        rm -rf lib/ReSharperHost/linux-x64/dotnet
        ln -sf ${super.dotnet-sdk_8} lib/ReSharperHost/linux-x64/dotnet
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
    version = "2024.3";
    name = "rider-${version}";

    src = super.fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "sha256-75thwYhRtvPvK/o/4UezSsGRYi9lpB8rU7OmCfm/82A=";
    };

    postPatch = patch attrs;
  });
in
{
  rider = rider-latest;
  rider-stable = rider-latest;
  rider-eap = rider-eap;
}
