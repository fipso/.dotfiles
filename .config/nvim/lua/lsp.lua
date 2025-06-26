vim.diagnostic.config({
  virtual_text = true,
  signs = true,
})

-- Global LSP keymaps
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Buffer-local LSP keymaps
local bufopts = { noremap=true, silent=true }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
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

-- Setup Mason for tool installation
require("mason").setup()
require("mason-null-ls").setup({
    automatic_setup = true,
    automatic_installation = true,
    handlers = {},
})

require("null-ls").setup({
	sources = {}
})

-- Auto-install required language servers
local mason_registry = require("mason-registry")
local required_servers = {
  "gopls",
  "vtsls", 
  "vue-language-server",
  "python-lsp-server",
  "bash-language-server",
  "html-lsp",
  "css-lsp",
  "dockerfile-language-server",
  "lua-language-server"
}

local function ensure_installed(servers)
  for _, server in ipairs(servers) do
    local p = mason_registry.get_package(server)
    if not p:is_installed() then
      vim.notify("Installing " .. server .. "...", vim.log.levels.INFO)
      p:install()
    end
  end
end

-- Ensure servers are installed when Mason registry is ready
if mason_registry.refresh then
  mason_registry.refresh(function()
    ensure_installed(required_servers)
  end)
else
  ensure_installed(required_servers)
end

-- Helper function to get Mason executable path
local function get_mason_cmd(package_name)
  local mason_registry = require("mason-registry")
  if mason_registry.is_installed(package_name) then
    local package = mason_registry.get_package(package_name)
    return package:get_install_path()
  end
  return nil
end

-- LSP Server Configurations using built-in vim.lsp.config

-- Go Language Server (Mason: gopls)
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- TypeScript/JavaScript with vtsls (Mason: vtsls) + Vue plugin
local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

vim.lsp.config('vtsls', {
  cmd = { 'vtsls', '--stdio' },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  settings = {
    typescript = {
      preferences = {
        includePackageJsonAutoImports = 'auto',
      },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    javascript = {
      preferences = {
        includePackageJsonAutoImports = 'auto',
      },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
})

-- Vue Language Server (Mason: vue-language-server) - Works with vtsls
vim.lsp.config('vue_ls', {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  init_options = {
    typescript = {
      tsdk = '/usr/lib/node_modules/typescript/lib'
    }
  },
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
      if #clients == 0 then
        vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
          local response_data = { { id, r.body } }
          client:notify('tsserver/response', response_data)
        end)
    end
  end,
})

-- Python Language Server (Mason: python-lsp-server)
vim.lsp.config('pylsp', {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
})

-- Bash Language Server (Mason: bash-language-server)
vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash' },
})

-- HTML Language Server (Mason: html-lsp)
vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    },
    provideFormatter = true
  }
})

-- CSS Language Server (Mason: css-lsp)
vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  settings = {
    css = {
      validate = true
    },
    less = {
      validate = true
    },
    scss = {
      validate = true
    }
  }
})

-- Dockerfile Language Server (Mason: dockerfile-language-server)
vim.lsp.config('dockerls', {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    }
  }
})

-- Lua Language Server (Mason: lua-language-server)
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
    },
  },
})

-- Enable all configured LSP servers
vim.lsp.enable({
  'gopls',
  'vtsls',
  'vue_ls',
  'pylsp',
  'bashls',
  'html',
  'cssls',
  'dockerls',
  'lua_ls'
})
