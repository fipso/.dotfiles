" Auto install plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	" Standard Stuff
	Plug 'sheerun/vim-polyglot'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'kyazdani42/nvim-tree.lua'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/nvim-treesitter-context'
	Plug 'norcalli/nvim-colorizer.lua'
	Plug 'folke/todo-comments.nvim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-commentary'
	Plug 'pantharshit00/vim-prisma'
	Plug 'rcarriga/nvim-notify'
	" Plug 'romgrk/barbar.nvim'
	" LSP
	Plug 'williamboman/mason.nvim'
	Plug 'jose-elias-alvarez/null-ls.nvim'
	Plug 'jayp0521/mason-null-ls.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'onsails/diaglist.nvim'
	Plug 'Olical/conjure'
	" Plug 'MunifTanjim/prettier.nvim'
	" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
	" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  " Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}'

	" Complete
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'onsails/lspkind.nvim'

	" Git
	Plug 'tpope/vim-fugitive'
	Plug 'sindrets/diffview.nvim'
	Plug 'pwntester/octo.nvim'
	" Theme
	Plug 'ayu-theme/ayu-vim'
	Plug 'sonph/onehalf', { 'rtp': 'vim' }
	" Learn Vim
	Plug 'ThePrimeagen/vim-be-good'
	" Debugging
	Plug 'mfussenegger/nvim-dap'
	Plug 'rcarriga/nvim-dap-ui'
	Plug 'fipso/nvim-dap-go'
	Plug 'nvim-telescope/telescope-dap.nvim'
	Plug 'theHamsta/nvim-dap-virtual-text'
	" Spyware
	Plug 'wakatime/vim-wakatime'
	" AI
	Plug 'github/copilot.vim'
	" Disabled
	"Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()

set completeopt=menu,menuone,noselect

runtime cmp.vim
runtime tree.vim
runtime lsp.vim

set termguicolors 
hi Normal guibg=None ctermbg=NONE

runtime theme.vim

lua require'colorizer'.setup()
lua	require'todo-comments'.setup()
lua require'dap-go'.setup()
lua require'telescope'.load_extension('dap')
lua require'nvim-dap-virtual-text'.setup()
lua require'octo'.setup()
lua require'diaglist'.init()
runtime dapui.vim

"let g:gruvbox_italic=1
"colorscheme gruvbox

set number
set mouse=a
set splitbelow
set splitright
set clipboard+=unnamedplus
set hidden
set cmdheight=1
" set statusline=%f\ %{coc#status()}%{get(b:,'coc_current_function','')}\ %{fugitive#statusline()}\ %h%w%m%r\ %=\ %(%l,%c%V\ %=\ %P%)
set so=2
set noea
set spelllang=en-gb
set signcolumn=number
" set signcolumn=no
" set foldmethod=indent

nnoremap <SPACE> <Nop>
map <Space> <Leader>
tnoremap <Esc> <C-\><C-n>

nnoremap <leader>hs <C-w>s
nnoremap <leader>vs <C-w>v

" Find files using Telescope command-line sugar.
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>t <cmd>TodoTelescope<cr>
nnoremap <leader>r <cmd>Telescope git_branches<cr>
nnoremap <leader>n <cmd>NvimTreeToggle<cr>

" Numbers
function! NumberToggle()
  if(&rnu == 1)
    set nornu
  else
    set rnu
  endif
endfunc
nnoremap <leader>o :call NumberToggle()<cr>

" Wrap Toggle
set nowrap
function! WrapToggle()
  if(&wrap == 1)
    set nowrap
  else
    set wrap
  endif
endfunc
nnoremap <leader>w :call WrapToggle()<cr>

" Movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Diaglist
nmap <space>q <cmd>lua require('diaglist').open_all_diagnostics()<cr>
nmap <space>qq <cmd>lua require('diaglist').open_buffer_diagnostics()<cr>

" DAP Keymaps
" nnoremap <leader>d <cmd>lua require'dapui'.toggle()<cr>
" nnoremap <leader>c <cmd>DapContinue<cr>
" nnoremap <leader>i <cmd>DapStepInto<cr>
" nnoremap <C-N> <cmd>DapStepOver<cr>
" nnoremap <C-B> <cmd>DapToggleBreakpoint<cr>

" VimRC Shortcuts
nnoremap <Leader>c :e ~/.config/nvim/<CR>
nnoremap <Leader>cc :source $MYVIMRC<CR>

command! -nargs=0 P :Prettier

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif


highlight LineNr guifg=darkyellow gui=bold
highlight LineNrBelow guifg=gray 
highlight LineNrAbove guifg=gray 

" Cmp Colors
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! link CmpItemKindInterface CmpItemKindVariable
highlight! link CmpItemKindText CmpItemKindVariable
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! link CmpItemKindMethod CmpItemKindFunction
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! link CmpItemKindProperty CmpItemKindKeyword
highlight! link CmpItemKindUnit CmpItemKindKeyword

lua << EOF
require("notify").setup({
  background_colour = "#000000",
})
EOF
