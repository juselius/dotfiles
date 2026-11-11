function headscale
    if test (count $argv) = 0
        echo "usage: headscale <context> [args]"
    else
        kubectl --context $argv[1] exec -ti -n headscale svc/headscale -- headscale $argv[2..]
    end
end
