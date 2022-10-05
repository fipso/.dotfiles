call plug#begin()
	Plug 'sheerun/vim-polyglot'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'kyazdani42/nvim-tree.lua'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/nvim-treesitter-context'
	Plug 'norcalli/nvim-colorizer.lua'
	Plug 'pantharshit00/vim-prisma'
	Plug 'tpope/vim-fugitive'
	Plug 'sindrets/diffview.nvim'
	Plug 'ayu-theme/ayu-vim'
	"Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'folke/todo-comments.nvim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-commentary'
	Plug 'sonph/onehalf', { 'rtp': 'vim' }
	"Plug 'github/copilot.vim'
	Plug 'ThePrimeagen/vim-be-good'
call plug#end()

runtime coc.vim
runtime tree.vim

set termguicolors 
hi Normal guibg=None ctermbg=NONE

runtime theme.vim

lua require'colorizer'.setup()
lua	require'todo-comments'.setup()

"let g:gruvbox_italic=1
"colorscheme gruvbox

set rnu
set number
set mouse=a
set splitbelow
set splitright
set clipboard+=unnamedplus
set hidden
set cmdheight=1
set statusline=%f\ %{coc#status()}%{get(b:,'coc_current_function','')}\ %{fugitive#statusline()}\ %h%w%m%r\ %=\ %(%l,%c%V\ %=\ %P%)
set so=2
set noea
set spelllang=en-gb
set signcolumn=no
" set foldmethod=indent

nnoremap <SPACE> <Nop>
map <Space> <Leader>
tnoremap <Esc> <C-\><C-n>

nnoremap <leader>hs <C-w>s
nnoremap <leader>vs <C-w>v

" Find files using Telescope command-line sugar.
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>u <cmd>Telescope buffers<cr>
nnoremap <leader>t <cmd>TodoTelescope<cr>
nnoremap <leader>r <cmd>Telescope git_branches<cr>
nnoremap <leader>s <cmd>Telescope session-lens search_session<cr>

function! NumberToggle()
  if(&rnu == 1)
    set nornu
  else
    set rnu
  endif
endfunc

nnoremap <leader>l :call NumberToggle()<cr>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

command! -nargs=0 P :CocCommand prettier.forceFormatDocument

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif


highlight LineNr guifg=yellow gui=bold
highlight LineNrBelow guifg=gray 
highlight LineNrAbove guifg=gray 
