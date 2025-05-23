-- let g:coq_settings = { 'auto_start': 'shut-up', 'keymap.bigger_preview': '', 'keymap.jump_to_mark': '', 'keymap.recommended': v:false }
-- 
-- " Keybindings
-- ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
-- ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
-- ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
-- ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
-- " ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
-- " ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
-- 
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   -- Enable completion triggered by <c-x><c-o>

--   -- Mappings.
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
-- end

--vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>l', function() vim.lsp.buf.format { async = true } end, bufopts)

require("mason").setup()
require("mason-null-ls").setup({
    automatic_setup = true,
    automatic_installation = true,
    handlers = {},
})

-- vim.lsp.config('rust_analyzer', {
--   -- Server-specific settings. See `:help lsp-quickstart`
--   settings = {
--     ['rust-analyzer'] = {},
--   },
-- })

require("null-ls").setup({
	sources = {}
})
--require("mason-null-ls").setup_handlers()
require("mason-lspconfig").setup({
    automatic_enable = true
})
-- require("mason-lspconfig").setup_handlers {
-- 	-- The first entry (without a key) will be the default handler
-- 	-- and will be called for each installed server that doesn't have
-- 	-- a dedicated handler.
-- 	function (server_name) -- default handler (optional)
-- 		local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- 		require("lspconfig")[server_name].setup {
-- 			on_attach = on_attach,
-- 			capabilities = capabilities
-- 		}
-- 		end
-- }

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  --underline = true,
  --update_in_insert = false,
  --severity_sort = false,
})
