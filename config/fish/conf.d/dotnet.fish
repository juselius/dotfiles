if which dotnet ^ /dev/null > /dev/null
    complete --command dotnet --arguments '(dotnet complete (commandline -cp))'
end
