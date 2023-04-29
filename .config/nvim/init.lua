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

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

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
		--config = function()
		--	-- require("your.null-ls.config") -- require your null-ls config here (example below)
		--end,
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"folke/tokyonight.nvim",
	"ayu-theme/ayu-vim",
	"junegunn/fzf",
	"junegunn/fzf.vim",
	"tpope/vim-fugitive",
	"tpope/vim-commentary"
})

require("complete")
require("lsp")

vim.wo.number = true
vim.opt.termguicolors = true

vim.cmd[[colorscheme ayu]]

vim.keymap.set('n', '<leader>f', '<Cmd>:Files<CR>', {silent = true })
vim.keymap.set('n', '<leader>l', '<Cmd>lua vim.lsp.buf.formatting()<CR>', {silent = true })
