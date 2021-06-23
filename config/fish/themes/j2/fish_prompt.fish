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

function _git_ahead -a ahead behind diverged none
  not git_is_repo; and return

  set -l ahead    "ahead"
  set -l behind   "behind"
  set -l diverged "diverged"
  set -l unmerged "unmerged"
  set -l stashed  "stash"
  set -l none     ""

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
  set -l arrow
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l yellow (set_color yellow)
  set -l cyan (set_color cyan)
  set -l magenta (set_color magenta)
  set -l normal (set_color normal)

  if [ -z "$SSH_TTY" ]
      set arrow "λ"
  else
      set arrow $yellow "λ" $normal
  end

  set -g fish_prompt_pwd_dir_length 0
  set -l cwd $blue(prompt_pwd)

  set -l git_info
  set -l git_branch (_git_branch_name)
  set -l git_status
  if [ "$git_branch" ]
    set git_info " on "
    if [ (_is_git_untracked) ]
        set git_info $git_info$yellow$git_branch
    else
        set git_info $git_info$green$git_branch
    end

    set -l ahead_status (_git_ahead)
    [ (_is_git_unmerged) ] && set git_status $git_status $unmerged ','
    [ (_is_git_stashed) ] && set git_status $git_status $stashed ','
    [ ! -z $ahead_status ] && set git_status $git_status $ahead_status ','

    if [ (_is_git_staged) ]
      set git_info "$git_info#"$normal
    else if [ (_is_git_dirty) ]
      set git_info "$git_info*"$normal
    end

    if [ ! -z "$git_status" ]
        set git_info $git_info '('
        for i in $git_status[1..-2]
            set git_info "$git_info$i"
        end
        set git_info "$git_info)"
    end
  end

  if [ ! -z "$IN_NIX_SHELL" ]
     set arrow ">"
  end

  set -l cc (set_color brblack)
  [ ! -z "$SSH_TTY" ] && set cc $red

  # set -l xu '╭'
  # set -l xl '╰'
  # set -l xd '─'

  echo -s $cc $USER '@' $hostname ':' $blue $cwd $normal $git_info $normal
  echo -n -s (fish_custom_mode_prompt) $normal $arrow ' '
end

