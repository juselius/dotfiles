#!/usr/bin/env fish

function fixup
    if test ! -f wsfsc.exe
        echo "no wsfsc.exe in cwd"
        return 1
    end

    if test -f wsfsc.exe.wrapped
        return 0
    end

    mv wsfsc.exe wsfsc.exe.wrapped
    mv wsfsc.exe.config wsfsc.exe.wrapped.config

    echo '#!/bin/sh
    exec mono `readlink -f $0`.wrapped "$@"' >wsfsc.exe

    chmod 755 wsfsc.exe
end

for i in ~/.nuget/packages/websharper.fsharp/*/tools
    cd $i
    pwd
    fixup
end
