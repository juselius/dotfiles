# name: J2
#

function _git_branch_name
  command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||'
end

function _is_git_dirty
  command git status -s --ignore-submodules=dirty 2> /dev/null | grep -q '^.'
  and echo "true"
end

function _is_git_staged
  command git status -s --ignore-submodules=dirty 2> /dev/null | grep -q '^[AMDR]'
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

function fish_mode_prompt
end

function fish_prompt
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l yellow (set_color yellow)
  set -l cyan (set_color cyan)
  set -l magenta (set_color magenta)
  set -l normal (set_color normal)

  if [ -z "$SSH_TTY" ]
      set -g arrow "λ"
  else
      set -g arrow $yellow "λ" $normal
  end

  set -g fish_prompt_pwd_dir_length 0
  set -l cwd $blue(prompt_pwd)

  set -l git_info
  set -l git_branch (_git_branch_name)
  if [ "$git_branch" ]

    if [ (_is_git_unmerged) ]
        set git_info $red $git_branch
    else if [ (_is_git_stashed) ]
        set git_info $blue $git_branch
    else if [ (_is_git_untracked) ]
        set git_info $yellow $git_branch
    else
        set git_info $green $git_branch
    end

    if [ (_is_git_staged) ]
      set git_info $git_info "+"
    else if [ (_is_git_dirty) ]
      set git_info $git_info "*"
    end

  end

  set -l xu '╭'
  set -l xl '╰'
  set -l xd ' '
  # set -l xd '─'
  if [ "$IN_NIX_SHELL" ]
     set -l xu $magenta $xu $normal
     set -l xl $magenta $xl $normal
     set -l xd $magenta $xd $normal
  end

  if [ ! -z "$SSH_TTY" ]
    set -l u $yellow $USER $normal
    set -l at $white @ $normal
    set -l h $green $hostname $normal
    echo -s $xu ' ' $u $at $h : $blue $cwd $normal
  else
    echo -s $xu ' ' $cwd $normal
  end

  if [ -z "$git_info" ]
      echo -n -s $xl ' ' (fish_default_mode_prompt) $arrow ' '
  else
      echo -n -s $xl ' ' (fish_default_mode_prompt) $git_info $normal $xd $arrow ' '
  end
end

