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
          enabled = false,
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
    "codethread/qmk.nvim",
    config = function()
      ---@type qmk.UserConfig
      local conf = {
        name = 'LAYOUT_adv360',
        variant = 'zmk',
        auto_format_pattern = '*.keymap',
        layout = {
          'x x x x x x x _ _ _ _ _ _ _ _ _ _ x x x x x x x',
          'x x x x x x x _ _ _ _ _ _ _ _ _ _ x x x x x x x',
          'x x x x x x x _ _ x x x x x x _ _ x x x x x x x',
          'x x x x x x _ _ _ x x x x x x _ _ _ x x x x x x',
          'x x x x x _ _ _ _ x x x x x x _ _ _ _ x x x x x',
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
  },
  { 'wakatime/vim-wakatime', lazy = false },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "mfussenegger/nvim-dap"
  },
  { 
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      require("dapui").setup()
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      -- add any opts here
    },
    -- if you want to download pre-built binary, then pass source=false. Make sure to follow instruction above.
    -- Also note that downloading prebuilt binary is a lot faster comparing to compiling from source.
    build = ":AvanteBuild source=false",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    config = function()
      require("dap-vscode-js").setup({
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        debugger_path = "/home/fipso/code/vscode-js-debug"
      })

      require("dap").configurations["javascript"] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        }
      }
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
vim.keymap.set('n', '<leader>l', "<Cmd>:lua vim.lsp.buf.formatting()<CR>", { silent = true })
vim.keymap.set('n', '<leader>n', '<Cmd>:NvimTreeToggle<CR>', { silent = true })

vim.keymap.set('n', '<leader>c', '<Cmd>:e ~/.config/nvim/<CR>', { silent = true })

vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { silent = true })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { silent = true })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { silent = true })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { silent = true })

vim.keymap.set('n', '<leader>b', require'dap'.toggle_breakpoint, { silent = true })
vim.keymap.set('n', '<leader>e', require'dap'.continue, { silent = true })
vim.keymap.set('n', '<leader>s', require'dap'.step_into, { silent = true })
vim.keymap.set('n', '<leader>d', require'dapui'.toggle, { silent = true })
