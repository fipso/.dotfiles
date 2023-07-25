#!/bin/bash
kitty @ set-background-opacity -a 0.95
kitty +kitten themes --reload-in=all One Half Light

echo -e 'colorscheme onehalflight\nhi CocMenuSel guibg=#ffffff' > ~/.config/nvim/theme.vim
