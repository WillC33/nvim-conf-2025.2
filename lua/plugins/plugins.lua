return {
  -- LSP & Mason
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "elixirls",    -- Elixir
        "ts_ls",       -- TypeScript/JavaScript
        "svelte",      -- Svelte
        "tailwindcss", -- Tailwind CSS
        "html",        -- HTML
        "cssls",       -- CSS
        "lua_ls"       -- Lua (for nvim config)
      },
      automatic_enable = true,
    },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Set up diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Manual fallback configs for servers that need them
      local lspconfig = require('lspconfig')

      -- These might need manual setup
      lspconfig.cssls.setup({})
      lspconfig.html.setup({})
      lspconfig.tailwindcss.setup({})
      lspconfig.svelte.setup({})
    end
  },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "elixir", "heex", "eex",    -- Elixir
          "typescript", "javascript", -- TS/JS
          "svelte",                   -- Svelte
          "html", "css",              -- Web
          "lua", "vim", "vimdoc"      -- Nvim
        },
        highlight = { enable = true }
      })
    end
  },

  -- Fuzzy Finder (fastest setup)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            width = { padding = 0 },
            height = { padding = 0 },
            preview_width = 0.5,
          },
        },
        sorting_strategy = "ascending",
        path_display = { "filename_first" },
      },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make"
  },

  -- File Management
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true
      }
    },
    config = function(_, opts)
      require("oil").setup(opts)
      vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      }
    }
  },

  -- Theme
  { "savq/melange-nvim" }
}
