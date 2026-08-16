-- Wrap `msg` to at most `max_lines` lines of `width` columns, ellipsizing if it
-- still doesn't fit. Returns a list of lines.
local function wrap_diagnostic(msg, width, max_lines)
  msg = msg:gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
  if width < 20 then
    return { msg }
  end

  local lines, line = {}, ''
  for word in msg:gmatch('%S+') do
    local candidate = (line == '') and word or (line .. ' ' .. word)
    if vim.fn.strdisplaywidth(candidate) > width and line ~= '' then
      table.insert(lines, line)
      line = word
      if #lines == max_lines then
        break
      end
    else
      line = candidate
    end
  end

  if #lines < max_lines then
    table.insert(lines, line)
    return lines
  end

  -- Out of room: mark the last line as truncated.
  local last = lines[max_lines]
  while vim.fn.strdisplaywidth(last) > width - 1 do
    last = last:sub(1, -2)
  end
  lines[max_lines] = last .. '…'
  return lines
end

-- Space available for a diagnostic, minus the gutter and a little breathing room.
local function diagnostic_width()
  local win = vim.api.nvim_get_current_win()
  local info = vim.fn.getwininfo(win)[1]
  local textoff = info and info.textoff or 0
  return math.max(20, vim.api.nvim_win_get_width(win) - textoff - 6)
end

vim.diagnostic.config({
  signs = true,
  -- virt_text extmarks are single-screen-line by construction, so virtual_text can
  -- never wrap. Keep the compact one-liner everywhere *except* the cursor line, and
  -- let virtual_lines render the full message where you're actually looking.
  virtual_text = {
    current_line = false,
    format = function(d)
      return wrap_diagnostic(d.message, diagnostic_width(), 1)[1]
    end,
  },
  virtual_lines = {
    current_line = true,
    format = function(d)
      return table.concat(wrap_diagnostic(d.message, diagnostic_width(), 2), '\n')
    end,
  },
  float = {
    border = 'rounded',
    max_width = 90,
    source = true,
  },
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
  -- "lua-language-server",  -- installed via Nix (Mason binary doesn't work on NixOS)
  "clangd"
}

local function ensure_installed(servers)
  for _, server in ipairs(servers) do
    local p = mason_registry.get_package(server)
    if not p:is_installed() then
      -- vim.notify("Installing " .. server .. "...", vim.log.levels.INFO)
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
        -- vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
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
          if r and r.body then
            local response_data = { { id, r.body } }
            client:notify('tsserver/response', response_data)
          end
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

-- Loud popups for silent LSP failures (project-load errors, server crashes).
local lsp_alert = require('lsp_alert')
lsp_alert.setup()

-- nvim's built-in defaults already cover snippetSupport; capabilities here only adds
-- cmp's extras on top: preselectSupport, plus insertTextFormat/insertTextMode in
-- resolveSupport. Minor quality-of-life, not required for completion to work.
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_exit = lsp_alert.on_exit,
})

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  --root_dir = vim.lsp.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git'),
  settings = {
    clangd = {
      semanticHighlighting = true,
      diagnostics = {
        enable = true,
        clazy = true,
      },
    },
  },
})

vim.lsp.config("roslyn", {
    -- roslyn.nvim defaults to mason's `roslyn-language-server` bin, which is the
    -- native apphost -- NixOS can't exec generic dynamically linked binaries.
    -- Mason also ships a `roslyn` bin that is a `dotnet <dll>` wrapper; use that.
    cmd = { vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "roslyn"), "--stdio" },
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
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
  'lua_ls',
  'clangd',
  'roslyn'
})
