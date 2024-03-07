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
    event = { "BufReadPre", "BufNewFile" },
    build = ":MasonUpdate" -- :MasonUpdate updates registry contents
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" }
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    }
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip"
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" }
  },
  {
    "folke/tokyonight.nvim",
    lazy = true
  },
  {
    "Shatur/neovim-ayu",
    lazy = true
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy"
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy"
  },
  {
    "tpope/vim-commentary",
    event = { "BufReadPre", "BufNewFile" }
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    }
  },
  {
    "folke/trouble.nvim",
    event = "VeryLazy"
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-CR>";
          }
        },
        panel = { enabled = false },
      })
    end,
  },
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {
      { "<leader>as", desc = "summarize text" },
      { "<leader>ag", desc = "generate git message" },
    },
    config = function()
      require("neoai").setup({
        models = {
          name = "openai",
          model = "gpt-4-32k",
          params = nil,
        }
      })
    end,
  },
  {
    "codethread/qmk.nvim",
    config = function()
      ---@type qmk.UserConfig
      local conf = {
        name = 'LAYOUT_adv360',
        variant = 'zmk',
        auto_format_pattern = '*.keymap',
        layout = {
          'x x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x x',
          'x x x x x x x _ _ _ _ _ _ _ _ _ x x x x x x x',
          'x x x x x x x _ _ _ x _ x _ _ _ x x x x x x x',
          'x x x x x x _ _ _ x x _ x x _ _ _ x x x x x x',
          'x x x x x _ _ _ x x x _ x x x _ _ _ x x x x x',
        }
      }
      require('qmk').setup(conf)
    end
  },
  {
    "lervag/vimtex",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.g.vimtex_view_method = 'zathura'
    end
  }
  -- {
  --   "simrat39/symbols-outline.nvim",
  --   config = function()
  --     require("symbols-outline").setup({
  --       highlight_hovered_item = true,
  --       show_guides = true,
  --       position = "bottom",
  --       auto_preview = true,

  --     })
  --   end,
  -- }
})

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'astro', 'tsx', 'typescript', 'html', 'css', 'vue', 'go', 'python' },
  auto_install = true,
  highlight = {
    enable = true
  }
})

require("complete")
require("lsp")

require("nvim-tree").setup()

vim.wo.number = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.spelllang = 'en_gb'
vim.opt.spell = true
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

vim.cmd [[colorscheme ayu-mirage]]
vim.cmd "hi Normal guibg=NONE ctermbg=NONE"
vim.cmd "syntax sync fromstart"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { silent = true })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { silent = true })
vim.keymap.set('n', '<leader>l', '<Cmd>lua vim.lsp.buf.formatting()<CR>', { silent = true })
vim.keymap.set('n', '<leader>n', '<Cmd>:NvimTreeToggle<CR>', { silent = true })

vim.keymap.set('n', '<leader>c', '<Cmd>:e ~/.config/nvim/<CR>', { silent = true })

vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { silent = true })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { silent = true })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { silent = true })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { silent = true })
