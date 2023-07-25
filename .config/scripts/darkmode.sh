#!/bin/bash
kitty @ set-background-opacity -a 0.95
kitty +kitten themes --reload-in=all Ayu

echo -e 'let ayucolor="mirage"\ncolorscheme ayu\nhi Normal guibg=NONE ctermbg=NONE' > ~/.config/nvim/theme.vim
