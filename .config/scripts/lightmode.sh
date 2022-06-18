#!/bin/bash

cp ~/.config/kitty/onehalf-light.conf ~/.config/kitty/theme.conf
kitty @ set-background-opacity 1
echo 'background_opacity 1' >> ~/.config/kitty/theme.conf
kitty @ set-colors -a ~/.config/kitty/theme.conf 

echo -e 'colorscheme onehalflight' > ~/.config/nvim/theme.vim
