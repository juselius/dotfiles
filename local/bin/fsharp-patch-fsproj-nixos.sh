#!/usr/bin/env bash

read -r -d '' TARGET << EOM
\  <PropertyGroup Condition="Exists('/run/current-system/sw/lib/mono/fsharp/Microsoft.FSharp.Targets')">\n\
    <FSharpTargetsPath>/run/current-system/sw/lib/mono/fsharp/Microsoft.FSharp.Targets</FSharpTargetsPath>\n\
  </PropertyGroup>
EOM

sed -i "/<Import Project=\"\$(FSharpTargetsPath)/i $TARGET" $1

