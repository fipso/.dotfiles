#!/bin/bash

#cp ~/.config/kitty/onehalf-light.conf ~/.config/kitty/theme.conf
#kitty @ set-colors -a ~/.config/kitty/theme.conf 

kitty @ set-background-opacity -a 0.95
echo 'background_opacity 0.95' >> ~/.config/kitty/theme.conf
kitty +kitten themes --reload-in=all One Half Light

echo -e 'colorscheme onehalflight\nhi CocMenuSel guibg=#ffffff' > ~/.config/nvim/theme.vim
