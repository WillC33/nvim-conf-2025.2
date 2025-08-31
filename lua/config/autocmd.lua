local M = {}

function M.setup()
  -- Auto-format on save (fails gracefully if no LSP formatter)
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('AutoFormat', { clear = true }),
    callback = function()
      -- Only format if LSP client with formatting capability is attached
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        if client.supports_method('textDocument/formatting') then
          vim.lsp.buf.format({
            async = false,
            timeout_ms = 2000,
            filter = function(c) return c.supports_method('textDocument/formatting') end
          })
          break -- Only format once
        end
      end
    end,
  })

  -- Highlight on yank
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('HighlightYank', { clear = true }),
    callback = function()
      vim.highlight.on_yank({ timeout = 150 })
    end,
  })

  -- Close certain filetypes with <q>
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('CloseWithQ', { clear = true }),
    pattern = { 'help', 'man', 'qf', 'lspinfo', 'checkhealth' },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
  })

  -- Auto-create directories when saving files
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('AutoMkdir', { clear = true }),
    callback = function(event)
      if event.match:match('^%w%w+:[\\/][\\/]') then
        return -- Don't create directories for URLs
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })


  -- Auto run Credo
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.{ex,exs}",
    callback = function()
      -- Only run if in an Elixir project
      if vim.fn.filereadable("mix.exs") == 1 then
        -- Run silently and show only if there are issues
        vim.fn.jobstart({ 'mix', 'credo', '--format', 'oneline' }, {
          on_stdout = function(_, data)
            local has_issues = false
            for _, line in ipairs(data) do
              if line:match("^[^:]+:") then
                has_issues = true
                break
              end
            end
            if has_issues then
              vim.notify("Credo found issues. Run :Credo for details", vim.log.levels.WARN)
            end
          end
        })
      end
    end
  })
end

return M
