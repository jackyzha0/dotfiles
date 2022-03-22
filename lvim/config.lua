--[[
lvim is the global options object
Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onenord"
lvim.builtin.lualine.options.theme = "onenord"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-c>"] = ":'<, '>w !pbcopy"
lvim.keys.normal_mode["<leader>fg"] = "<cmd>Telescope live_grep<cr>"
lvim.keys.normal_mode["<leader>ff"] = "<cmd>Telescope find_files<cr>"
lvim.keys.normal_mode["<leader>fb"] = "<cmd>Telescope file_browser<cr>"
lvim.keys.normal_mode["<leader>fw"] = "<cmd>HopChar2<cr>"

lvim.keys.normal_mode["<leader>xx"] = "<cmd>TroubleToggle<cr>"
lvim.keys.normal_mode["<leader>xw"] = "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>"
lvim.keys.normal_mode["<leader>xd"] = "<cmd>TroubleToggle lsp_document_diagnostics<cr>"
lvim.keys.normal_mode["<leader>xq"] = "<cmd>TroubleToggle quickfix<cr>"
lvim.keys.normal_mode["<leader>xl"] = "<cmd>TroubleToggle loclist<cr>"
lvim.keys.normal_mode["<leader>xk"] = "<cmd>lua vim.diagnostic.open_float(0, { scope = \"line\", border = \"single\" })<CR>"


lvim.builtin.dashboard.custom_header = {
  "                                                                                ## #                   ",
  "                         ^                             ^                       # #                     ",
  "      ^    ^            /|\\            ^    ^         /|\\ ^                   ##         ^             ",
  "  ^  /|\\  /|\\  ^        /|\\  ^     ^  /|\\  /|\\  ^     /|\\/|\\    ^          __||         /|\\ ^    ^   ^ ",
  " /|\\ /|\\  /|\\ /|\\       /|\\ /|\\   /|\\ /|\\  /|\\ /|\\    /|\\/|\\   /|\\        /.\\__\\        /|\\/|\\  /|\\ /|\\",
  " .|  #|.. .|& /|\\        | #&|.   .|  #|.. .|& /|\\     | #|.   /|\\        |O | |        .| #|.. .|& /|\\",
}
lvim.builtin.dashboard.footer = ""
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in cse the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = true
lvim.builtin.nvimtree.setup.view.width = 20
lvim.builtin.nvimtree.hide_dotfiles = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })
vim.list_extend(lvim.lsp.override, { "rust_analyzer"  })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)
require("lvim.lsp.manager").setup("jedi_language_server", {})

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { exe = "black", filetypes = { "python" } },
--   { exe = "isort", filetypes = { "python" } },
--   {
--     exe = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "flake8", filetypes = { "python" } }
-- }

-- Additional Plugins
lvim.plugins = {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"
      vim.g.indent_blankline_filetype_exclude = {"help", "terminal", "dashboard"}
      vim.g.indent_blankline_buftype_exclude = {"terminal"}
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = function ()
      require("trouble").setup()
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = {"fugitive"}
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "rmehri01/onenord.nvim",
    config = function ()
      require('onenord').setup()
    end, 
  },
  {
    "danilamihailov/beacon.nvim",
    config = function() end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          })
    end,
  },
  {
    "nacro90/numb.nvim",
    config = function()
      require("numb").setup()
    end,
  },
  {
    "Pocco81/AutoSave.nvim",
    config = function()
      require("autosave").setup({
        clean_command_line_interval = 1000,
        debounce_delay = 1000,
      })
    end,
  },
  {
    "chentau/marks.nvim",
    config = function()
      require("marks").setup({
        builtin_marks = { ".", "'", "\"", "^" },
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function ()
      require("lsp_signature").setup({
        hint_prefix = "hint: ",
        floating_window = false
      })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    config = function()
      require("rust-tools").setup({
        tools = {
          autoSetHints = true,
          hover_with_actions = true,
          runnables = {
            use_telescope = true,
          },
          inlay_hints = {
            show_variable_name = true,
            show_parameter_hints = true,
            parameter_hints_prefix = "params:",
            other_hints_prefix = "-> ",
            max_len_align = true
          }
        },
        server = {
          cmd = { vim.fn.stdpath "data" .. "/lsp_servers/rust/rust-analyzer" },
          on_attach = require("lvim.lsp").common_on_attach,
          on_init = require("lvim.lsp").common_on_init,
        },
        })
    end,
    ft = { "rust", "rs" },
  },
  {
    "xiyaowong/nvim-transparent",
    config = function()
      require("transparent").setup({
        enable = true
      })
    end,
  },
  { "weilbith/nvim-code-action-menu" }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  {"BufEnter,FocusGained,InsertLeave,WinEnter", "*", "if &nu && mode() != \"i\" | set rnu   | endif"},
  {"BufLeave,FocusLost,InsertEnter,WinLeave", "*", "if &nu                      | set nornu | endif"},
  {"FileReadPost", "*", "RustSetInlayHints"},
  {"CursorHold,CursorHoldI", "*", "lua vim.diagnostic.open_float(nil, {focus=false, scope=\"cursor\"})"}
}

vim.opt.number = true

vim.cmd([[let g:beacon_minimal_jump = 1]])
