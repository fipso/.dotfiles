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
 {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for roslyn
        'tris203/rzls.nvim',
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require('rzls').setup {}
        end,
      },
    },
    config = function()
      require('roslyn').setup {
        args = {
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator='
            .. vim.fs.joinpath(vim.fn.stdpath 'data' --[[@as string]], 'mason', 'packages', 'roslyn', 'libexec', 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(
            vim.fn.stdpath 'data' --[[@as string]],
            'mason',
            'packages',
            'rzls',
            'libexec',
            'Targets',
            'Microsoft.NET.Sdk.Razor.DesignTime.targets'
          ),
        },
        ---@diagnostic disable-next-line: missing-fields
        config = {
          handlers = require 'rzls.roslyn_handlers',
          settings = {
            ['csharp|inlay_hints'] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,

              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ['csharp|code_lens'] = {
              dotnet_enable_references_code_lens = true,
            },
          },
        },
      }
    end,
    init = function()
      -- we add the razor filetypes before the plugin loads
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
  },
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
  "nvim-lua/plenary.nvim",
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function()
      require("mason").setup({
        registries = {
            'github:mason-org/mason-registry',
            'github:Crashdummyy/mason-registry'
        }
      })
    end,
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
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
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
    "leoluz/nvim-dap-go"
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },
  {
    --"fipso/avante.nvim",
    "yetone/avante.nvim",
    version = "*",
    event = "VeryLazy",
    lazy = false,
    opts = {
      cursor_applying_provider = "claude",
      provider = "claude",
      behaviour = {
        auto_apply_diff_after_generation = false
      },
      claude = {
        timeout = 0
        --model = "claude-3-7-sonnet-20250219",
      },
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
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     require("codecompanion").setup({
  --       adapters = {
  --         deepseek = function()
  --           return require("codecompanion.adapters").extend("openai_compatible", {
  --             env = {
  --               url = "https://integrate.api.nvidia.com",
  --               api_key = "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",
  --               chat_url = "/v1/chat/completions",
  --               model = "deepseek-ai/deepseek-r1"
  --             }
  --           })
  --         end
  --       },
  --       strategies = {
  --         chat = {
  --           adapter = "deepseek",
  --         }
  --       }
  --     })
  --   end,
  -- },
  {
    "mxsdev/nvim-dap-vscode-js",
    config = function()
      require("dap-vscode-js").setup({
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        debugger_path = "/home/fipso/code/vscode-js-debug"
      })

      require("dap-go").setup{
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
          {
            type = "go",
            name = "Debug Benchmark",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
            args = { "-test.run=^$", "-test.bench=." },
          },
        },
      }

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
  },
  {
    'topaxi/gh-actions.nvim',
    keys = {
      { '<leader>gh', '<cmd>GhActions<cr>', desc = 'Open Github Actions' },
    },
    -- optional, you can also install and use `yq` instead.
    -- build = 'make',
    ---@type GhActionsConfig
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context"
  },
  {
    "sindrets/diffview.nvim"
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
      require"gitsigns".setup()
    end
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function ()
        require"alpha".setup(require"alpha.themes.startify".config)
    end
  },
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
  {
    "nyoom-engineering/oxocarbon.nvim"
  }
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
--vim.o.signcolumn = 'number'
vim.o.equalalways = false
vim.o.shiftwidth = 2
vim.opt.laststatus = 3

vim.opt.background = "dark"
vim.cmd [[colorscheme oxocarbon]]

--vim.cmd [[colorscheme gruvbox]]
--vim.cmd "hi Normal guibg=NONE ctermbg=NONE"

-- vim.cmd "syntax sync fromstart"

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
vim.keymap.set('n', '<C-S>', require'dap'.step_over, { silent = true })
vim.keymap.set('n', '<S-S>', require'dap'.step_into, { silent = true })
vim.keymap.set('n', '<leader>d', require'dapui'.toggle, { silent = true })

vim.api.nvim_set_hl(0, "DiffAdd", {bg = "#20303b"})
vim.api.nvim_set_hl(0, "DiffDelete", {bg = "#37222c"})
vim.api.nvim_set_hl(0, "DiffChange", {bg = "#1f2231"})
vim.api.nvim_set_hl(0, "DiffText", {bg = "#394b70"})
