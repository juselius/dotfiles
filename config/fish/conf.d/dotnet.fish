which dotnet &> /dev/null
if test "$status" = 0
    complete --command dotnet --arguments '(dotnet complete (commandline -cp))'
end
