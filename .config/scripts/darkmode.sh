#!/bin/bash

cp ~/.config/kitty/ayu-mirage.conf ~/.config/kitty/theme.conf
kitty @ set-background-opacity -a 0.9
echo 'background_opacity 0.9' >> ~/.config/kitty/theme.conf
kitty @ set-colors -a ~/.config/kitty/theme.conf 

echo -e 'let ayucolor="mirage"\ncolorscheme ayu\nhi Normal guibg=NONE ctermbg=NONE' > ~/.config/nvim/theme.vim
