call plug#begin()

Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'norcalli/nvim-colorizer.lua'
Plug 'pantharshit00/vim-prisma'
Plug 'tpope/vim-fugitive'
Plug 'sindrets/diffview.nvim'
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'

call plug#end()

runtime coc.vim
runtime tree.vim

set termguicolors 
let ayucolor="mirage"
colorscheme ayu
hi Normal guibg=None ctermbg=NONE

lua require'colorizer'.setup()
lua require'todo-comments'.setup()

"let g:gruvbox_italic=1
"colorscheme gruvbox


set rnu
set mouse=a
set splitbelow
set splitright
set clipboard+=unnamedplus
set hidden
set cmdheight=1

nnoremap <SPACE> <Nop>
map <Space> <Leader>
tnoremap <Esc> <C-\><C-n>

" Find files using Telescope command-line sugar.
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>n <cmd>Telescope frecency<cr>
nnoremap <leader>t <cmd>TodoTelescope<cr>
nnoremap <leader>b <cmd>Telescope git_branches<cr>

" Harpoon for quick file navigation
nnoremap <leader>m <cmd>lua require("harpoon.mark").add_file()<cr>
nnoremap <leader>h <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <leader>u <cmd>lua require("harpoon.ui").nav_file(1)<cr>
nnoremap <leader>i <cmd>lua require("harpoon.ui").nav_file(2)<cr>
nnoremap <leader>o <cmd>lua require("harpoon.ui").nav_file(3)<cr>
nnoremap <leader>p <cmd>lua require("harpoon.ui").nav_file(4)<cr>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

command! -nargs=0 P :CocCommand prettier.forceFormatDocument
