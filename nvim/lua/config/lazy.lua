-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- [[ Color Schemes ]] --
    { "marko-cerovac/material.nvim",        priority = 1000 },
    { "Mofiqul/vscode.nvim",                priority = 1000 },
    { "rockyzhang24/arctic.nvim",           dependencies = "rktjmp/lush.nvim",          priority = 1000 },
    { "lunarvim/darkplus.nvim",             priority = 1000 },
    { "zenbones-theme/zenbones.nvim",       dependencies = "rktjmp/lush.nvim",          priority = 1000 },
    { "gmr458/cold.nvim",                   priority = 1000 },

    -- [[ General Plugins ]] --
    { "ntpeters/vim-better-whitespace" },
    { "folke/todo-comments.nvim",           dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
    { "brenoprata10/nvim-highlight-colors", opts = {} },
    { "psf/black" },
    {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
      opts = {},
    },
    {
      "echasnovski/mini.nvim",
      config = function()
        require("mini.git").setup()
        require("mini.diff").setup({ view = { priority = -10 } }) -- Hide gutter symbols.
        require("mini.statusline").setup()
      end,
    },
    {
      "tanvirtin/vgit.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
      opts = {
        settings = {
          live_blame = { enabled = false },
          live_gutter = { enabled = false },
          scene = { diff_preference = "split" },
        },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        require("telescope").setup({
          defaults = require("telescope.themes").get_ivy({ -- Use the Ivy theme for all pickers.
            mappings = {
              i = {
                ["<C-u>"] = false,                              -- Let me clear the search bar with <C-u>.
                ["<Esc>"] = require("telescope.actions").close, -- Let me exit quickly with <Esc>.
              },
            },
          }),
          extensions = { fzf = {} },
          pickers = { colorscheme = { enable_preview = true } },
        })
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
      config = function()
        require("neo-tree").setup({
          source_selector = { statusline = true },
          filesystem = {
            window = {
              mappings = {
                ["-"] = "navigate_up", -- Copy default keymap from Oil.
                ["o"] = "system_open",
                ["/"] = "noop",        -- So I can search as usual.
                ["F"] = "fuzzy_finder",
                ["z"] = "noop",        -- So I can center with `zz`.
              },
            }
          },
          commands = {
            -- From https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#open-with-system-viewer
            system_open = function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.jobstart({ "xdg-open", path }, { detach = true })
            end,
          },
        })
      end,
    },
    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "asm", "bash", "bibtex", "c", "cpp", "c_sharp", "css", "csv", "cuda", "d", "dockerfile", "fish",
            "gitattributes", "gitcommit", "git_config", "gitignore", "git_rebase", "go", "gomod", "gosum", "gotmpl",
            "gowork", "haskell", "html", "htmldjango", "ini", "java", "javascript", "jq", "jsdoc", "json", "json5",
            "julia", "kotlin", "latex", "lua", "luadoc", "make", "markdown", "markdown_inline", "matlab", "nasm", "ocaml",
            "pascal", "perl", "php", "phpdoc", "powershell", "prolog", "pymanifest", "python", "query", "regex",
            "requirements", "ruby", "rust", "scala", "sql", "ssh_config", "swift", "tcl", "terraform", "tmux", "toml",
            "tsv", "typescript", "typst", "verilog", "vhdl", "vim", "vimdoc", "xml", "xresources", "yaml", "zig",
          },
          auto_install = false,
          highlight = {
            enable = true,
            ---@diagnostic disable-next-line: unused-local
            disable = function(lang, buf)     -- Disable Treesitter for large files.
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              return ok and stats and stats.size > max_filesize
            end,
          },
        })
      end,
    },

    -- [[ LSP and Autocompletion ]] --
    {
      "neovim/nvim-lspconfig",
      dependencies = { "Saghen/blink.cmp", "folke/lazydev.nvim" },
      config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        lspconfig.basedpyright.setup({ capabilities = capabilities })
        lspconfig.lua_ls.setup({ capabilities = capabilities })
      end,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found.
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "Saghen/blink.cmp",
      dependencies = "rafamadriz/friendly-snippets",
      version = "v0.8.2", --There might be a problem with v0.9 and VGit, NeoTree etc.
      -- version = "*", -- TODO: Switch to latest version eventually.
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
          },
        },
        keymap = {
          preset = "default",
          ["<Esc>"] = {
            function(cmp)
              cmp.hide()
              vim.cmd.stopinsert()
              return true
            end,
          },
          ["<C-c>"] = { "hide", "fallback" },
          ["<Tab>"] = {
            -- Tab will show completions, advance completions, or insert a <Tab> character "intelligently".
            function(cmp)
              -- Don't mess with snippets.
              local snippets = require('blink.cmp.config').snippets
              if snippets.active() then return end

              -- Copied, posibly from here: https://github.com/hrsh7th/nvim-cmp/issues/181 or an LLM.
              local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
              end

              if has_words_before() and not cmp.is_visible() then
                return cmp.show()
              end
            end,
            "select_next", "snippet_forward", "fallback",
          },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<Enter>"] = { "accept", "snippet_forward", "fallback" },

          cmdline = {
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
          },
        },
        appearance = { use_nvim_cmp_as_default = true },
        signature = { enabled = true },
        completion = {
          list = { selection = "auto_insert" },
          menu = {
            auto_show = true,
            draw = {
              columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 }, { "source_name" }, },
            },
          },
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
          ghost_text = { enabled = true },
        },
      },
      opts_extend = { "sources.default" },
    },
  },
})
