-- Loud, dismissable alerts for LSP failures that are otherwise completely silent.
--
-- Roslyn is the motivating case: when its design-time build breaks (an inline
-- PackageReference Version under CPM, a <Protobuf Include> pointing at a renamed
-- file, a .proto that does not compile) it logs "Error while loading <proj>.csproj",
-- drops the project, and quietly falls back to a miscellaneous-files workspace.
-- Hover and completion stop working with nothing whatsoever shown in the editor --
-- the only evidence is a line in :LspLog. These alerts surface that moment.

local M = {}

-- Don't re-alert the same failure for this long. Roslyn repeats project-load errors
-- on every restart and on some file saves.
local COOLDOWN_MS = 15000

local state = {
  win = nil,
  buf = nil,
  seen = {},
  pending = nil,
}

local ns = vim.api.nvim_create_namespace("lsp_alert")

---@type { pat: string, title: string, hint: string }[]
local LOG_PATTERNS = {
  {
    pat = "Error while loading",
    title = "ROSLYN: PROJECT FAILED TO LOAD",
    hint = "Design-time build broke. Hover and completion are now dead for every file in this project.",
  },
  {
    pat = "has unresolved dependencies",
    title = "ROSLYN: FELL BACK TO MISC-FILES MODE",
    hint = "No project is loaded, so symbols resolve against nothing.",
  },
}

local function wrap(text, width)
  local out, line = {}, ""
  for word in tostring(text):gmatch("%S+") do
    if #line + #word + 1 > width then
      table.insert(out, line)
      line = word
    else
      line = (line == "") and word or (line .. " " .. word)
    end
  end
  if line ~= "" then
    table.insert(out, line)
  end
  return out
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.win, state.buf = nil, nil
end

local function render(title, hint, detail)
  M.close()

  local width = math.min(96, math.max(60, math.floor(vim.o.columns * 0.8)))
  local inner = width - 4

  local lines = { "", "  " .. title, "" }
  local title_row = 1

  for _, l in ipairs(wrap(hint, inner)) do
    table.insert(lines, "  " .. l)
  end
  if detail and detail ~= "" then
    table.insert(lines, "")
    for _, l in ipairs(wrap(detail, inner)) do
      table.insert(lines, "  " .. l)
    end
  end
  table.insert(lines, "")
  table.insert(lines, "  q / <Esc> dismiss     :LspLog detail     :LspRestart retry")
  table.insert(lines, "")

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_extmark(buf, ns, title_row, 0, {
    end_row = title_row + 1,
    hl_group = "ErrorMsg",
  })
  vim.bo[buf].modifiable = false

  local height = #lines
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "double",
    title = " LSP ALERT ",
    title_pos = "center",
    zindex = 300,
  })
  vim.wo[win].winhl = "NormalFloat:NormalFloat,FloatBorder:DiagnosticError,FloatTitle:ErrorMsg"

  state.win, state.buf = win, buf

  for _, key in ipairs({ "q", "<Esc>", "<CR>" }) do
    vim.keymap.set("n", key, M.close, { buffer = buf, nowait = true, silent = true })
  end
end

--- Show the alert. Defers while in insert mode so it never yanks the cursor
--- mid-keystroke -- it lands as soon as you are back in normal mode.
function M.show(title, hint, detail)
  local key = title .. "|" .. tostring(detail)
  local now = vim.uv.now()
  if state.seen[key] and (now - state.seen[key]) < COOLDOWN_MS then
    return
  end
  state.seen[key] = now

  if vim.fn.mode():match("^[ivRs\22\19]") then
    state.pending = { title, hint, detail }
    vim.api.nvim_create_autocmd({ "InsertLeave", "ModeChanged" }, {
      once = true,
      callback = function()
        local p = state.pending
        state.pending = nil
        if p then
          vim.schedule(function()
            render(p[1], p[2], p[3])
          end)
        end
      end,
    })
    return
  end

  render(title, hint, detail)
end

function M.setup()
  -- Chain onto whatever window/logMessage handler is already installed rather than
  -- replacing it, so normal :LspLog output is preserved.
  local prev = vim.lsp.handlers["window/logMessage"]
  vim.lsp.handlers["window/logMessage"] = function(err, result, ctx, config)
    local msg = result and result.message or ""
    for _, p in ipairs(LOG_PATTERNS) do
      if msg:find(p.pat, 1, true) then
        vim.schedule(function()
          M.show(p.title, p.hint, msg)
        end)
        break
      end
    end
    if prev then
      return prev(err, result, ctx, config)
    end
  end

  vim.api.nvim_create_user_command("LspAlertTest", function()
    M.show(
      "ROSLYN: PROJECT FAILED TO LOAD",
      "Design-time build broke. Hover and completion are now dead for every file in this project.",
      "This is a test alert triggered by :LspAlertTest -- nothing is actually wrong."
    )
  end, { desc = "Preview the LSP alert popup" })
end

--- Hook for a client's on_exit. Fires only on an abnormal exit, not on :LspRestart
--- or on quitting nvim.
---@param code integer
---@param signal integer
---@param client_id integer
function M.on_exit(code, signal, client_id)
  if vim.v.exiting ~= vim.NIL then
    return
  end
  if code == 0 and signal == 0 then
    return
  end
  local client = vim.lsp.get_client_by_id(client_id)
  local name = client and client.name or ("client " .. tostring(client_id))
  vim.schedule(function()
    M.show(
      "LSP SERVER CRASHED: " .. name:upper(),
      "The language server exited abnormally. Nothing will resolve until it is restarted.",
      string.format("exit code %d, signal %d", code, signal)
    )
  end)
end

return M
