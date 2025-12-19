function __find_newest_sock
    fd --owner $USER "agent.*" /tmp/ssh-* \
        | xargs ls -lt \
        | head -1 \
        | rev \
        | cut -d' ' -f1 \
        | rev
end

function reset-ssh-authsock
    if test -n "$SSH_AUTH_SOCK"
        if not test -e "$SSH_AUTH_SOCK"
            set -l sock (__find_newest_sock)
            echo "Found $sock"
            set -xg SSH_AUTH_SOCK $sock
        else
            echo "SSH_AUTH_SOCK is not a file: $SSH_AUTH_SOCK"
        end
    else
        echo "SSH_AUTH_SOCK is not set"
    end
end
