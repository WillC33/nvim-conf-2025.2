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
        --"expert",      -- Elixir
        "elixirls",
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

      local configs = {
        cssls = {},
        html = {},
        tailwindcss = {},
        svelte = {},
      }

      for server, config in pairs(configs) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- Elixir Expert (waiting for Dialyzer)
      -- vim.lsp.enable('expert')
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

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp"
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        completion = {
          autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
          keyword_length = 3,
        },
        sources = {
          -- Buffer ONLY during auto-complete
          { name = 'buffer', keyword_length = 2 }
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping(function(fallback)
            -- Manual trigger: show BOTH buffer + LSP
            cmp.complete({
              config = {
                sources = {
                  { name = 'nvim_lsp' },
                  { name = 'buffer' }
                }
              }
            })
          end),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        },
      })
    end
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
  {
    "WillC33/heathglass.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local heathglass = require("heathglass")
      heathglass.setup({
        transparent = true,
        terminal_colors = true,
      })
    end,
  }
}
