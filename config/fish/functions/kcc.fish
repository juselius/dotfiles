function kcc --wraps='kubectl config use-context' --description 'alias kcc=kubectl config use-context'
   kubectl config use-context $argv;
end
