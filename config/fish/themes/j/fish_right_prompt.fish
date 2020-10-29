function fish_right_prompt -d "Write out the right prompt"
  set -l _status $status
  if [ $_status -gt 0 ]
    echo -n -s (set_color red) "$_status " (set_color normal)
  end
  if [ ! -z "$SSH_TTY" ]
    set -l h (set_color green)"$hostname"(set_color normal)
    set -l at (set_color white)"@"(set_color normal)
    set -l u (set_color yellow)"$USER"(set_color normal)
    echo -n "$u$at$h"
  end
end

