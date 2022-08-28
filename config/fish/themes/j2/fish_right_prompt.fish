function fish_right_prompt -d "Write out the right prompt"
  set -l _status $status
  # set -l _ctx (kubectl config current-context 2> /dev/null)
  set -l _ctx (kubectl config get-contexts |grep '^*' | choose 1 4 |sed -r 's, ,/,' 2> /dev/null)
  if [ -n "$_ctx" ]
      set _ctx "#$_ctx"
  end
  if [ $_status -gt 0 ]
    echo -n -s (set_color red) "$_status " (set_color normal)
  else
    echo -n -s (set_color green) "$_ctx"  (set_color normal)
  end
end

