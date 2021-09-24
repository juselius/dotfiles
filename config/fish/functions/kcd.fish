function kcd --wraps='kubectl config set-context --current -n' --description 'alias kcd=kubectl config set-context --current --namespace='
  if test (count $argv) = 0;
      kubectl config set-context --current --namespace=default;
  else
      kubectl config set-context --current --namespace=$argv;
  end
end
