function reset-ssh-authsock
    if test (fd --owner $USER --max-depth 1 . /tmp |grep ssh- |count) -gt 0
        set -x SSH_AUTH_SOCK (fd --owner $USER agent. /tmp/ssh-* | head -1)
    end
end
