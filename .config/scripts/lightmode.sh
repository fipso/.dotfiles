#!/bin/bash

cp ~/.config/kitty/onehalf-light.conf ~/.config/kitty/theme.conf
kitty @ set-background-opacity -a 1
echo 'background_opacity 0.95' >> ~/.config/kitty/theme.conf
kitty @ set-colors -a ~/.config/kitty/theme.conf 

echo -e 'colorscheme onehalflight' > ~/.config/nvim/theme.vim
