local M = {}

local function set_keymap(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

local function handle_lsp_tab()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<Tab>"
  end
end

local function handle_lsp_stab()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  else
    return "<C-Tab>"
  end
end

local function yank_filepath()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
  vim.notify('Copied: ' .. vim.fn.expand('%:p'))
end

function M.setup()
  -- File Management
  set_keymap("n", "<leader>e", function()
    require("oil").open()
  end, "Open Oil file explorer")
  set_keymap("n", "-", function()
    require("oil").open()
  end, "Open parent directory")

  -- Telescope
  set_keymap("n", "<leader>fs", function()
    require("telescope.builtin").live_grep()
  end, "Live grep")
  set_keymap("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
  end, "Find files")
  set_keymap("n", "<leader>fi", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
  end, "Search in buffer")
  set_keymap("n", "<Tab>", function()
    require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({}))
  end, "Switch buffers")

  set_keymap("n", "<Esc>", function()
    -- Close any floating windows
    for _, win in pairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= '' then
        vim.api.nvim_win_close(win, false)
        return
      end
    end
    -- If no floating windows, clear search highlight
    vim.cmd('nohlsearch')
  end, "Close floating windows or clear search")

  -- Gitsigns
  set_keymap("n", "<C-b>", "<Cmd>Gitsigns blame<CR>", "Git blame")
  set_keymap("n", "<leader>gb", "<Cmd>Gitsigns blame_line<CR>", "Blame line")
  set_keymap("n", "<C-g>", "<Cmd>Gitsigns next_hunk<CR>", "Next hunk")
  set_keymap("n", "<leader>gp", "<Cmd>Gitsigns prev_hunk<CR>", "Previous hunk")
  set_keymap("n", "<leader>gh", "<Cmd>Gitsigns reset_hunk<CR>", "Reset hunk")
  set_keymap("n", "<leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", "Stage hunk")

  -- LSP Keybinds (set when LSP attaches)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local opts = { buffer = ev.buf, noremap = true, silent = true }

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Find references' }))
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
      vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code actions' }))
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
      vim.keymap.set('n', '<C-d>', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float,
        vim.tbl_extend('force', opts, { desc = 'Show diagnostics' }))
    end,
  })

  -- General mappings
  set_keymap("i", "jk", "<Esc>", "Escape insert mode")
  set_keymap({ "v", "x" }, "<leader>y", '"+y', "Yank to system clipboard")
  set_keymap("n", "<leader>yf", yank_filepath, "Yank buffer filepath to clipboard")
  set_keymap("n", "<leader>p", '"+p', "Paste from system clipboard")
  set_keymap("i", "<C-Space>", "<C-x><C-o>", "Open module suggestions")
  -- Navigate suggestions
  set_keymap("i", "<Tab>", handle_lsp_tab, "Select next completion")
  set_keymap("i", "<S-Tab>", handle_lsp_stab, "Select prev completion")
  set_keymap("t", "<Esc>", [[<C-\><C-n>]], "Exit terminal mode")

  -- Window navigation
  set_keymap("n", "<S-Tab>", ":bprevious<CR>", "Move to previous buffer")
  set_keymap("n", "<C-h>", "<C-w>h", "Move to left window")
  set_keymap("n", "<C-j>", "<C-w>j", "Move to bottom window")
  set_keymap("n", "<C-k>", "<C-w>k", "Move to top window")
  set_keymap("n", "<C-l>", "<C-w>l", "Move to right window")

  -- Quick save/quit
  set_keymap("n", "<leader>w", "<cmd>w<cr>", "Save file")
  set_keymap("n", "<leader>q", "<cmd>q<cr>", "Quit")
end

return M
