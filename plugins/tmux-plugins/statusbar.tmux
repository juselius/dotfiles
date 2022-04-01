#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux set-option -g status-style fg=white,bg=colour234 # colour24
tmux set-option -g status-justify centre
tmux set-option -g status-left-length 80
tmux set-option -g status-right-length 32
tmux set-option -g status-left "[#S] #[fg=yellow]#U#[default]@#[fg=green]#{hostname_short}#[default]:#[fg=white]#{pane_current_path}#[default] "
tmux set-option -g status-right "#[bg=colour235]#{simple_git_status}#[default] #[fg=colour248]%H:%M %d-%b-%y#[default]"
