local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazy").setup({
	"nvim-lua/plenary.nvim",
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate" -- :MasonUpdate updates registry contents
	},
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		}
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
        {
          "nvim-treesitter/nvim-treesitter",
          build = ":TSUpdate"
        },
	"folke/tokyonight.nvim",
	"Shatur/neovim-ayu",
	"junegunn/fzf",
	"junegunn/fzf.vim",
	"tpope/vim-fugitive",
	"tpope/vim-commentary",
	"nvim-tree/nvim-web-devicons",
	"nvim-tree/nvim-tree.lua",
	"folke/trouble.nvim",
})

require("complete")
require("lsp")

require("nvim-tree").setup()

vim.wo.number = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.spelllang = 'en-gb'
vim.o.mouse = 'a'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.expandtab = true
vim.o.softtabstop = 2
vim.o.hidden = true
vim.o.smartindent = true
vim.o.cmdheight = 1
vim.o.signcolumn = 'number'
vim.o.equalalways = false
vim.o.shiftwidth = 2

vim.cmd[[colorscheme ayu-dark]]

vim.keymap.set('n', '<leader>f', '<Cmd>:Files<CR>', {silent = true})
vim.keymap.set('n', '<leader>g', '<Cmd>:Rg<CR>', {silent = true})
vim.keymap.set('n', '<leader>l', '<Cmd>lua vim.lsp.buf.formatting()<CR>', {silent = true})

vim.keymap.set('n', '<leader>c', '<Cmd>:e ~/.config/nvim/<CR>', {silent = true})

vim.keymap.set('n', '<C-H>', '<C-W><C-H>', {silent = true})
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', {silent = true})
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', {silent = true})
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', {silent = true})
