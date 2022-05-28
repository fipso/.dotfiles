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
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'vimpostor/vim-tpipeline'

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
:set statusline=%f\ %{fugitive#statusline()}\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)

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

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

command! -nargs=0 P :CocCommand prettier.forceFormatDocument
