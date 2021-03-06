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
    alias wttr="curl wttr.in/Potsdam"
    alias b="bat"
    alias c="cd"
    alias icat="kitty +kitten icat"
    alias kssh="kitty +kitten ssh"
    set -gx EDITOR nvim
    set -gx TERMINAL /usr/bin/kitty
    set -gx PATH "$HOME/.cargo/bin" $PATH;
    set -gx PATH "$HOME/.config/scripts" $PATH;
    set -gx NNN_PLUG "p:preview-tui"
    set -gx NNN_FIFO "/tmp/nnn.fifo"

    set -g fish_handle_reflow 0

    fish_vi_key_bindings
end

# Created by `userpath` on 2022-04-29 20:37:44
set PATH $PATH /home/fipso/.local/bin
fish_add_path /home/fipso/.spicetify
