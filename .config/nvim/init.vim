call plug#begin()

Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'morhetz/gruvbox'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'norcalli/nvim-colorizer.lua'
Plug 'pantharshit00/vim-prisma'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'sindrets/diffview.nvim'
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'

call plug#end()

runtime coc.vim
runtime tree.vim

set termguicolors 
let ayucolor="mirage"
colorscheme ayu

lua require'colorizer'.setup()

"let g:gruvbox_italic=1
"colorscheme gruvbox

hi Normal guibg=None ctermbg=NONE

"let g:move_diagnostics_airline = 1
"set laststatus=0 ruler
"set statusline=
"set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
"set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
"set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
"set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
"set statusline+=\ %n\           " buffer number
"set statusline+=%#Visual#       " colour
"set statusline+=%{&paste?'\ PASTE\ ':''}
"set statusline+=%{&spell?'\ SPELL\ ':''}
"set statusline+=%#CursorIM#     " colour
"set statusline+=%R                        " readonly flag
"set statusline+=%M                        " modified [+] flag
"set statusline+=%#Cursor#               " colour
"set statusline+=%#CursorLine#     " colour
"set statusline+=\ %t\                   " short file name
"set statusline+=%=                          " right align
"set statusline+=%#CursorLine#   " colour
"set statusline+=\ %Y\                   " file type
"set statusline+=%#CursorIM#     " colour
"set statusline+=\ %3l:%-2c\         " line + column
"set statusline+=%#Cursor#       " colour
"set statusline+=\ %3p%%\                " percentage

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
nnoremap <leader>h <cmd>Telescope help_tags<cr>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
