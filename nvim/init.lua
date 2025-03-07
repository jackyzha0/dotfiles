local vim = vim
local wo = vim.wo
local g = vim.g
local o = vim.o
-- use nvim-tree instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- disable swap
vim.opt.swapfile = false

-- Vim options
vim.opt.smartcase = true
wo.number = true
g.mouse = "a"
wo.scrolloff = 8
wo.sidescrolloff = 8
wo.wrap = false
wo.cursorline = true
o.undodir = "/tmp/.vim-undo-dir"
o.undofile = true
o.clipboard = "unnamed"
g.mapleader = " "

local TAB_WIDTH = 2
o.tabstop = TAB_WIDTH
o.shiftwidth = TAB_WIDTH
o.softtabstop = TAB_WIDTH
o.expandtab = true
o.copyindent = true
o.signcolumn = "yes"

-- bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

colors = {
  black = "#000000",
  bg0 = "#171717",
  bg1 = "#242b38",
  bg2 = "#343e4f",
  bg3 = "#363c51",
  bg_d = "#13161c",
  bg_blue = "#91E9EE",
  bg_yellow = "#f0d197",
  fg = "#dfdee0",
  purple = "#8E7EB4",
  green = "#20FFAF",
  orange = "#db9351",
  blue = "#0DEFE1",
  yellow = "#f7c668",
  cyan = "#07a39a",
  red = "#F65C5C",
  grey = "#546178",
  light_grey = "#7d899f",
  transparent = "NONE",
}

-- plugin setup
require("lazy").setup({
  "nvim-tree/nvim-web-devicons",
  {
    'navarasu/onedark.nvim',
    config = function()
      local onedark = require('onedark')
      onedark.setup({
        style = 'cool',
        transparent = true,
        code_style = {
          comments = "none",
          keywords = "bold"
        },
        diagnostics = {
          darker = false,
          background = false
        },
        colors = colors,
        highlights = {
          TelescopeNormal = { bg = colors.bg_d },
          TelescopePromptBorder = { fg= colors.grey, bg = colors.bg_d },
          TelescopeResultsBorder = { fg= colors.grey, bg = colors.bg_d },
          TelescopePreviewBorder = { fg= colors.grey, bg = colors.bg_d },
          TreesitterContext = { bg = colors.bg_d },
          GitSignsChange = { fg = colors.yellow },
          GitSignsChangeLn = { fg = colors.yellow },
          GitSignsChangeNr = { fg = colors.yellow },
          CopilotSuggestion = {fg = colors.grey }, 
        },
        lualine = {
          transparent = true
        }
      })
      onedark.load()
    end
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-fzf-native.nvim" },
    config = function()
      require 'telescope'.setup {
        defaults = {
          file_ignore_patterns = { "node_modules/" },
          -- borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
          borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          prompt_prefix = '❯ ',
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = 'top',
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<c-x>"] = "delete_buffer",
              }
            }
          },
          live_grep = {
            debounce = 1000
          }
        }
      }
      require('telescope').load_extension('fzf')
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        filters = { custom = { "^.git$" } }
      })

      local nt_api = require('nvim-tree.api')

      nt_api.events.subscribe(nt_api.events.Event.TreeOpen, function()
        local tree_winid = nt_api.tree.winid()

        if tree_winid ~= nil then
          vim.api.nvim_set_option_value('statusline', '%t', {win = tree_winid})
        end
      end)
    end
  },
  'jghauser/mkdir.nvim',
  {
    "utilyre/barbecue.nvim",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      theme = {
        normal = { bg = colors.bg_d },
      },
      show_modified = true,
      symbols = {
        ellipsis = "..."
      },
      -- https://github.com/neovide/neovide/pull/2165
      lead_custom_section = function()
        return { { " ", "WinBar" } }
      end,
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = "onedark",
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {},
        lualine_x = { 'encoding', 'filesize' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      }
    }
  },
  "MunifTanjim/prettier.nvim",
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        separator_style = { ' ', ' ' },
      },
      highlights = {
        duplicate_selected = {
          bg = colors.bg1, 
        },
        modified_selected = {
          bg = colors.bg1, 
        },
        close_button_selected = {
          bg = colors.bg1, 
        },
        indicator_selected = {
          bg = colors.bg1 
        },
        buffer_selected = {
          italic = false,
          bg = colors.bg1
        }
      }
    }
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    version = "v3.5.0",
    main = "ibl",
    opts = {
      indent = {
        char = "▏"
      }
    },
  },
  {
    'junnplus/lsp-setup.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    }
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  },
  'windwp/nvim-ts-autotag',
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    priority = 2000,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        autotag = { enable = true },
        highlight = { enable = true },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_previous_start = {
              ["[["] = "@parameter.inner"
            },
            goto_next_start = {
              ["]]"] = "@parameter.inner"
            }
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["iq"] = "@parameter.inner",
              ["aq"] = "@parameter.outer",
              ["ib"] = "@block.inner",
              ["ab"] = "@block.outer",
            }
          }
        },
        disable = function(lang, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 10000
        end
      }
    end
  },
  'simrat39/rust-tools.nvim',
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 3,
    }
  },
  'nvim-treesitter/nvim-treesitter-textobjects',
  'machakann/vim-highlightedyank',
  {
    'mfussenegger/nvim-ts-hint-textobject',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
          },
        },
      }
    end
  },
  {
    'lewis6991/satellite.nvim',
    opts = {
      winblend = 0,
    }
  },
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  {
    'MunifTanjim/prettier.nvim',
    opts = {}
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim'
    }
  },
  {
    "kylechui/nvim-surround",
    opts = {}
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      enable_check_bracket_line = true,
      check_ts = true
    }
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '┃' },
        topdelete    = { text = '┃' },
        changedelete = { text = '┃' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align',
      },
    }
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true,   -- CSS rgb() and rgba() functions
        hsl_fn = true,   -- CSS hsl() and hsla() functions
        css = false,     -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false,  -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = 'foreground',
      })
    end
  },
  { "ojroques/nvim-bufdel" },
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        }
      }
    },
  },
  {
    'rcarriga/nvim-notify',
    lazy = true,
    opts = {
      fps = 30,
      stages = "fade_in_slide_out",
      timeout = 500,
      top_down = true,
    },
  },
  'rktjmp/highlight-current-n.nvim',
  'fedepujol/move.nvim',
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        insert_only = true,
      },
    }
  },
  {
    'akinsho/git-conflict.nvim',
    version = "v1.0.0",
    opts = {
      disable_diagnostics = true
    }
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false
      },
      copilot_node_command = 'node',
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<M-Tab>",
          next = "<M-]>",
          prev = "<M-[>",
        }
      }
    }
  }
}, {
  lazy = true,
  version = nil
})

-- borders and colours
local border_opts = {
}

-- LSP
require('lsp-setup').setup({
  default_mappings = true,
  mappings = {
    gd = 'lua require"telescope.builtin".lsp_definitions()',
    gi = 'lua require"telescope.builtin".lsp_implementations()',
    gr = 'lua require"telescope.builtin".lsp_references()',
    gt = 'vim.lsp.buf.type_definition',
  },
  on_attach = function(client, bufnr)
    -- Check if the LSP server supports inlay hints
    if client.server_capabilities.inlayHintProvider then
      -- Enable inlay hints
      vim.lsp.buf_request(bufnr, "textDocument/inlayHint", vim.lsp.util.make_range_params())
    end
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  servers = {
    golangci_lint_ls = {},
    gopls = {},
    clangd = {},
    dockerls = {},
    html = {},
    hls = {},
    jsonls = {},
    cssls = {},
    clojure_lsp = {},
    eslint = {
      settings = {
        workingDirectory = { mode = 'location' },
      },
    },
    ts_ls = {
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- or "literals" or "none"
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      settings = {
        implicitProjectConfiguration = {
          checkJs = true
        }
      }
    },
    pyright = {},
    marksman = {},
    julials = {},
    jdtls = {},
    rust_analyzer = require('rust-tools').setup({
      tools = {
        inlay_hints = {
          show_parameter_hints = true,
          other_hints_prefix = ":: ",
          only_current_line = true,
        }
      },
      server = {
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true
              }
            },
            checkOnSave = {
              command = "clippy",
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
    })
  },
})

-- Autocomplete setup
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.updatetime = 500
local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = { behavior = cmp.SelectBehavior.Select }
local lspkind = require('lspkind')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'nvim_lsp', keyword_length = 3, priority = 1000 },
    { name = 'buffer',   keyword_length = 3, priority = 500 },
    { name = 'luasnip',  keyword_length = 2, priority = 250 },
    { name = 'path',     priority = 250 },
  },
  window = {
    -- completion = cmp.config.window.bordered(border_opts),
    -- documentation = cmp.config.window.bordered(border_opts),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    })
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
  },
})

-- better diagnostics signs
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end
sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '▲' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

-- disable virtaul text for lsp_lines
vim.diagnostic.config({
  virtual_text = false,
  float = border_opts
})

-- Auto commands
vim.cmd [[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
  augroup END
]]

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)

-- Keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "<leader>o", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>t", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>p", "<cmd>NvimTreeToggle<cr>", opts)
keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
keymap("n", "<leader>c", "<cmd>CodeActionMenu<CR>", opts)
keymap("n", '<leader>x', "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("i", "<C-c>", "<Esc>", opts)
keymap("n", "<leader>m", ":DiffviewOpen<CR>", opts)
keymap('n', '<C-/>', '<CMD>lua require("Comment.api").toggle.linewise.current()<CR>', {})
keymap('x', '<C-/>', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', {})

-- window splits
keymap("n", "<leader>w", "<C-w>k", {})
keymap("n", "<leader>a", "<C-w>h", {})
keymap("n", "<leader>s", "<C-w>j", {})
keymap("n", "<leader>d", "<C-w>l", {})

keymap('n', 'co', '<Plug>(git-conflict-ours)', opts)
keymap('n', 'ct', '<Plug>(git-conflict-theirs)', opts)
keymap('n', 'cb', '<Plug>(git-conflict-both)', opts)
keymap('n', 'c0', '<Plug>(git-conflict-none)', opts)
keymap('n', ']x', '<Plug>(git-conflict-prev-conflict)', opts)
keymap('n', '[x', '<Plug>(git-conflict-next-conflict)', opts)

-- tabs
keymap('n', '<M-,>', '<Cmd>BufferLineCyclePrev<CR>', opts)
keymap('n', '<M-.>', '<Cmd>BufferLineCycleNext<CR>', opts)
keymap('n', '<M-q>', '<Cmd>BufDel<CR>', opts)
keymap('n', '<M-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', opts)
keymap('n', '<M-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', opts)
keymap('n', '<M-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', opts)
keymap('n', '<M-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', opts)
keymap('n', '<M-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', opts)
keymap('n', '<M-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', opts)
keymap('n', '<M-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', opts)
keymap('n', '<M-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', opts)
keymap('n', '<M-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', opts)

-- moves
-- Normal-mode commands
keymap('n', '<A-Down>', ':MoveLine(1)<CR>', opts)
keymap('n', '<A-Up>', ':MoveLine(-1)<CR>', opts)

-- Visual-mode commands
keymap('v', '<A-Down>', ':MoveBlock(1)<CR>', opts)
keymap('v', '<A-Up>', ':MoveBlock(-1)<CR>', opts)

-- Neovide options
if vim.g.neovide then
  vim.g.neovide_show_border = true
  vim.g.neovide_cursor_animation_length = 0.08
  vim.g.neovide_padding_top = 5
  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
  vim.g.neovide_floating_shadow = false;
  vim.g.neovide_remember_window_size = false

  -- shortcuts 
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<D-w>', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<D-t>', ':enew<CR>', { noremap = true, silent = true })
end

