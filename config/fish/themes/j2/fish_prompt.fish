# name: J2
#

function _git_branch_name
  command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||'
end

function _is_git_dirty
  command git status -s --ignore-submodules=dirty > /dev/null 2>&1
  and echo "true"
end

function _is_git_staged
  command git status -s --ignore-submodules=dirty 2> /dev/null | grep -q '^ A'
  and echo "true"
end

function _is_git_unmerged
  command git status -s --ignore-submodules=dirty 2> /dev/null | grep -q '^ U'
  and echo "true"
end

function _is_git_untracked
  command git status -s --ignore-submodules=dirty 2> /dev/null | grep -q '^\?'
  and echo "true"
end

function _is_git_stashed
  command git rev-parse --verify --quiet refs/stash > /dev/null 2>&1
  and echo "true"
end


function fish_prompt
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l yellow (set_color yellow)
  set -l normal (set_color normal)

  if [ -z "$SSH_TTY" ]
      set -g arrow "λ"
  else
      set -g arrow (set_color bryellow) "λ" (set_color normal)
  end

  set -g fish_prompt_pwd_dir_length 0
  set -l cwd $blue(prompt_pwd)

  if [ (_git_branch_name) ]

    if [ (_is_git_unmerged) ]
        set git_info $red(_git_branch_name)
    else if [ (_is_git_stashed) ]
        set git_info $blue(_git_branch_name)
    else if [ (_is_git_untracked) ]
        set git_info $yellow(_git_branch_name)
    else
        set git_info $green(_git_branch_name)
    end

    if [ (_is_git_staged) ]
      set git_info "$git_info" "+"
    else if [ (_is_git_dirty) ]
      set git_info "$git_info" "*"
    end

  end

  if [ ! -z "$SSH_TTY" ]
    set -l h (set_color green)"$hostname"(set_color normal)
    set -l at (set_color white)"@"(set_color normal)
    set -l u (set_color yellow)"$USER"(set_color normal)
    echo "$u$at$h $cwd"
  else
    echo $cwd
  end

  if [ -z "$IN_NIX_SHELL" ]
      echo -n -s $git_info $normal ' ' $arrow ' '
  else
      echo -n -s [ $git_info $normal ] ' ' $arrow ' '
  end
end

