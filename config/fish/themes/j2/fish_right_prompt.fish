function fish_right_prompt -d "Write out the right prompt"
  set -l _status $status
  if [ $_status -gt 0 ]
    echo -n -s (set_color red) "$_status " (set_color normal)
  end
end

