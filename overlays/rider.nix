self: super:
let
  rpath =
    with super;
    super.lib.makeLibraryPath [
      stdenv.cc.cc.lib
      zlib
    ];

  vmoptsName =
    "rider" + super.lib.optionalString super.stdenv.hostPlatform.is64bit "64" + ".vmoptions";

  rider-latest = super.jetbrains.rider.overrideAttrs (attrs: rec {
    version = "2026.2.5.1";
    name = "rider-${version}";

    src = super.fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "sha256-VJ5iE9NoJUp+HYc017wg6ufuBSqJj1OiV+DGDuuJvK8=";
    };

    # postInstall =
    #   with super;
    #   let
    #     WLlibs = lib.makeLibraryPath ([
    #       stdenv.cc.cc.lib
    #       zlib
    #       wayland
    #       freetype
    #       fontconfig
    #     ]);
    #   in
    #   ''
    #     cd $out/rider
    #
    #     sed -i 's|-Djna\.library.path=.*|&:${WLlibs}|' bin/${vmoptsName}
    #     echo "-Dawt.toolkit.name=WLToolkit" >> bin/${vmoptsName}
    #     echo "-Dsun.java2d.vulkan=true" >> bin/${vmoptsName}
    #
    #     ls -d $PWD/plugins/cidr-debugger-plugin/bin/lldb/linux/*/lib/python3.8/lib-dynload/* |
    #     xargs patchelf \
    #       --replace-needed libssl.so.10 libssl.so \
    #       --replace-needed libcrypto.so.10 libcrypto.so \
    #       --replace-needed libcrypt.so.1 libcrypt.so
    #
    #     for dir in lib/ReSharperHost/linux-*; do
    #       rm -rf $dir/dotnet
    #       ln -s ${super.dotnetCorePackages.dotnet_9.sdk.unwrapped}/share/dotnet $dir/dotnet
    #     done
    #   '';

    buildInputs = attrs.buildInputs ++ [
      super.kubelogin
      super.libGL
    ];
  });
in
{
  inherit rider-latest;
  # rider = jetbrains.rider;
  # rider-stable = rider-latest;
}
