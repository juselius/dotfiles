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

function git_ahead -a ahead behind diverged none
  not git_is_repo; and return

  set -l commit_count (command git rev-list --count --left-right "@{upstream}...HEAD" 2> /dev/null)

  switch "$commit_count"
  case ""
    # no upstream
  case "0"\t"0"
    test -n "$none"; and echo "$none"; or echo ""
  case "*"\t"0"
    test -n "$behind"; and echo "$behind"; or echo "-"
  case "0"\t"*"
    test -n "$ahead"; and echo "$ahead"; or echo "+"
  case "*"
    test -n "$diverged"; and echo "$diverged"; or echo "±"
  end
end

function fish_mode_prompt
end

function fish_custom_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold red
      echo '[N] '
    case insert
      set_color --bold green
      echo '[I] '
    case replace_one
      set_color --bold green
      echo '[R] '
    case visual
      set_color --bold brmagenta
      echo '[V] '
    case '*'
      set_color --bold red
      echo '[?] '
  end
  set_color normal
end

function fish_prompt
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l yellow (set_color yellow)
  set -l cyan (set_color cyan)
  set -l magenta (set_color magenta)
  set -l normal (set_color normal)

  set -l ahead    " (ahead)"
  set -l behind   " (behind)"
  set -l diverged " (diverged)"
  set -l dirty    " (modified)"
  set -l none     ""

  set -l arrow

  if [ -z "$SSH_TTY" ]
      set arrow "λ"
  else
      set arrow $yellow "λ" $normal
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
      set git_info $git_info "#" (git_ahead)
    else if [ (_is_git_dirty) ]
      set git_info $git_info "*" (git_ahead)
    end

  end

  # set -l xu '╭'
  # set -l xl '╰'
  set -l xu ''
  set -l xl ''
  set -l xd ' '
  # set -l xd '─'

  if [ ! -z "$IN_NIX_SHELL" ]
     set arrow ">"
  end

  if [ ! -z "$SSH_TTY" ]
    set -l u $yellow $USER $normal
    set -l at $yellow @ $normal
    set -l h $yellow $hostname $normal
    echo -s $xu ' ' $u $at $h : $blue $cwd $normal
  else
     echo -s $red $xu $USER '@' $hostname ':' $blue $cwd $normal
  end

  if [ -z "$git_info" ]
      echo -n -s $xl '' (fish_custom_mode_prompt) $arrow ' '
  else
      echo -n -s $xl '' (fish_custom_mode_prompt) $git_info $normal $xd $arrow ' '
  end
end

