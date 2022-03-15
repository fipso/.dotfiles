if status is-interactive
    # Commands to run in interactive sessions can go here
    alias vim="nvim"
    alias config="/usr/bin/git --git-dir=$HOME/.cfg/.git/ --work-tree=$HOME"
    set -gx EDITOR nvim
end
