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

    #if [ -d "plugins/remote-dev-server" ]; then
    #  patch -p1 < ${./JetbrainsRemoteDev.patch}
    #fi

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
        # rm -rf lib/ReSharperHost/linux-x64/dotnet
        # ln -sf ${super.dotnet_9.sdk} lib/ReSharperHost/linux-x64/dotnet
        '';

  rider-latest = super.jetbrains.rider.overrideAttrs (attrs: rec {
    version = "2025.1.7";
    name = "rider-${version}";

    src = super.fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "sha256-YmW5aInJBkxP03rv6hxQBG7/yOt1YJ5wek36qRzXEoA=";
    };

    postInstall =
      with super;
      let
        WLlibs = lib.makeLibraryPath ([
          stdenv.cc.cc.lib
          zlib
          wayland
          freetype
          fontconfig
        ]);
      in
    ''
      cd $out/rider

      sed -i 's|-Djna\.library.path=.*|&:${WLlibs}|' bin/${vmoptsName}
      echo "-Dawt.toolkit.name=WLToolkit" >> bin/${vmoptsName}
      echo "-Dsun.java2d.vulkan=true" >> bin/${vmoptsName}

      ls -d $PWD/plugins/cidr-debugger-plugin/bin/lldb/linux/*/lib/python3.8/lib-dynload/* |
      xargs patchelf \
        --replace-needed libssl.so.10 libssl.so \
        --replace-needed libcrypto.so.10 libcrypto.so \
        --replace-needed libcrypt.so.1 libcrypt.so

      for dir in lib/ReSharperHost/linux-*; do
        rm -rf $dir/dotnet
        ln -s ${super.dotnetCorePackages.dotnet_9.sdk.unwrapped}/share/dotnet $dir/dotnet
      done
    '';

    buildInputs = attrs.buildInputs ++ [
      super.kubelogin
      super.libGL
      super.xorg.libX11
    ];
  });
  jetbrains = super.callPackage ../../src/nixpkgs/pkgs/applications/editors/jetbrains/default.nix {};
in
{
  rider = rider-latest;
  # rider = jetbrains.rider;
  # rider-stable = rider-latest;
}
