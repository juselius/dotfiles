# if [ -d ~/.kube/config.d ]
#     set -x --path KUBECONFIG ~/.kube/config ~/.kube/config.d/*.yaml
# end

if [ -d ~/.krew ]
    set -gx PATH $PATH ~/.krew/bin
end

