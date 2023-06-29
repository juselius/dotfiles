if [ -d ~/.kube/config.d ]
    set -x --path KUBECONFIG ~/.kube/config ~/.kube/config.d/*.yaml
end

