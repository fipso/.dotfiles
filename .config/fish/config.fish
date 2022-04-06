if status is-interactive
    # Commands to run in interactive sessions can go here

    #if not set -q TMUX
    #    set -g TMUX tmux new-session -d -s base
    #    eval $TMUX
    #    tmux attach-session -d -t base
    #end 

    alias vim="nvim"
    alias gs="git status"
    alias gc="git commit -a"
    alias l="exa --icons"
    alias ls="exa --icons"
    alias ll="exa -l --icons"
    alias la="exa -l -a --icons"
    alias lt="exa --tree --level 2 --icons"
    alias t="tmux"
    alias ts="tmux ls"
    alias ta="tmux a"
    alias config="/usr/bin/git --git-dir=$HOME/.cfg/.git/ --work-tree=$HOME"
    set -gx EDITOR nvim
    set -g fish_handle_reflow 0
end
