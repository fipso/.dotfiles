#!/bin/bash

cp ~/.config/kitty/kitty-themes/themes/ayu_mirage.conf ~/.config/kitty/theme.conf
kitty @ set-background-opacity -a 0.8
echo 'background_opacity 0.8' >> ~/.config/kitty/theme.conf
kitty @ set-colors -a ~/.config/kitty/theme.conf 

echo -e 'let ayucolor="mirage"\ncolorscheme ayu' > ~/.config/nvim/theme.vim
