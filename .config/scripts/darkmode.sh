#!/bin/bash

kitty @ set-background-opacity -a 0.95
#echo 'background_opacity 0.95' >> ~/.config/kitty/theme.conf
kitty +kitten themes --reload-in=all Ayu Mirage

echo -e 'let ayucolor="mirage"\ncolorscheme ayu\nhi Normal guibg=NONE ctermbg=NONE' > ~/.config/nvim/theme.vim
