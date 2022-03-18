if status is-interactive
    # Commands to run in interactive sessions can go here
    alias vim="nvim"
    alias gs="git status"
    alias gc="git commit -a"
    alias l="ls"
    alias config="/usr/bin/git --git-dir=$HOME/.cfg/.git/ --work-tree=$HOME"
    set -gx EDITOR nvim
    set -g fish_handle_reflow 0
end
