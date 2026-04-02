-- lua/config/commands.lua
local M = {}

local function github_blob_to_raw(url)
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
    cjs = "javascript",
    mjs = "javascript",
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
    rs = "rust",
    go = "go",
    py = "python",
  }
  return ext and map[ext] or nil
end

local function set_buffer_content_from_string(buf, content)
  local lines = vim.split(content or "", "\n", { plain = true })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function open_remote_source(url)
  if not url or url == "" then
    vim.notify("URL が空です", vim.log.levels.WARN)
    return
  end

  local target_url = url

  if url:match("^https://github%.com/.+/blob/.+$") then
    local raw_url, err = github_blob_to_raw(url)
    if not raw_url then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    target_url = raw_url
  end

  local buf = vim.api.nvim_create_buf(true, false)

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].buftype = ""
  vim.bo[buf].buflisted = true

  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_name(buf, target_url)

  vim.net.request(target_url, {}, function(err, res)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      if err then
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.notify(("Failed to fetch: %s"):format(tostring(err)), vim.log.levels.ERROR)
        return
      end
      if not res or type(res.body) ~= "string" then
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.notify("HTTP Responce error:", vim.log.levels.ERROR)
        return
      end

      set_buffer_content_from_string(buf, res.body)
      local ft = detect_filetype(target_url)
      if ft then
        vim.bo[buf].filetype = ft
      end

      vim.bo[buf].modified = false
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("normal! gg")
      end)
    end)
  end)
end

local function prompt_and_open_remote_source()
  vim.ui.input({
    prompt = "",
  }, function(input)
    if not input or input == "" then
      return
    end
    open_remote_source(vim.trim(input))
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("OpenGithubSource", function(opts)
    open_remote_source(opts.args)
  end, {
    nargs = 1,
    desc = "Open a GitHub blob URL or raw URL in a new buffer",
  })

  vim.keymap.set("n", "<leader>git", prompt_and_open_remote_source, {
    desc = "Open remote GitHub source from URL",
  })
end

return M
