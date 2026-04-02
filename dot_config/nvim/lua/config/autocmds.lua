-- ~/.config/nvim/lua/config/autocmds.lua

local english_im = "com.apple.inputmethod.Kotoeri.RomajiTyping.Roman"

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("AutoSwitchIMOnNormal", { clear = true }),
  pattern = "*:n*",
  callback = function()
    vim.fn.system({ "macism", english_im })
  end,
})

vim.o.updatetime = 300
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local matches = vim.fn.getmatches()
    for _, m in ipairs(matches) do
      if m.pattern == "\\%u200b" then
        return
      end
    end
    vim.fn.matchadd("ErrorMsg", "\\%u200b")
  end,
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     local clients = vim.lsp.get_clients({ bufnr = 0 })
--     if #clients > 0 then
--       local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
--       if #diagnostics > 0 then
--         vim.diagnostic.open_float(nil, {
--           focus = false,
--           scope = "cursor",
--           close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--           border = "rounded",
--           source = "if_many",
--         })
--       else
--         vim.lsp.buf.hover()
--       end
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      scope = "cursor",
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "if_many",
    })
  end,
})



local function github_blob_to_raw(url)
  -- 行番号アンカーは一旦除去
  url = url:gsub("#L%d+%-L%d+$", ""):gsub("#L%d+$", "")

  local owner, repo, ref, path = url:match(
    "^https://github%.com/([^/]+)/([^/]+)/blob/([^/]+)/(.+)$"
  )

  if not owner then
    return nil, "GitHub blob URL ではありません"
  end

  return ("https://raw.githubusercontent.com/%s/%s/%s/%s"):format(
    owner,
    repo,
    ref,
    path
  )
end

local function detect_filetype(path)
  local ext = path:match("%.([%w_%-]+)$")
  local map = {
    lua = "lua",
    vim = "vim",
    js = "javascript",
    ts = "typescript",
    jsx = "javascriptreact",
    tsx = "typescriptreact",
    json = "json",
    md = "markdown",
    nix = "nix",
    sh = "sh",
    bash = "bash",
    zsh = "zsh",
    yml = "yaml",
    yaml = "yaml",
    toml = "toml",
    css = "css",
    html = "html",
  }
  return ext and map[ext] or nil
end

local function open_github_source(url)
  local raw_url, err = github_blob_to_raw(url)
  if not raw_url then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_create_buf(true, false)

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true

  vim.net.request(raw_url, { outbuf = buf }, function(req_err, _)
    vim.schedule(function()
      if req_err then
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
        vim.notify(("Failed to fetch: %s"):format(req_err), vim.log.levels.ERROR)
        return
      end

      vim.api.nvim_set_current_buf(buf)
      vim.api.nvim_buf_set_name(buf, raw_url)

      local ft = detect_filetype(raw_url)
      if ft then
        vim.bo[buf].filetype = ft
      end

      vim.bo[buf].modified = false
      vim.notify(("Opened: %s"):format(raw_url), vim.log.levels.INFO)
    end)
  end)
end

vim.api.nvim_create_user_command("OpenGithubSource", function(opts)
  open_github_source(opts.args)
end, {
  nargs = 1,
  complete = "file",
})
