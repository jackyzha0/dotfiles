local vim = vim
local wo = vim.wo
local g = vim.g
local o = vim.o
vim.opt.termguicolors = true

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
        colors = {
          black = "#151820",
          bg0 = "#242b38",
          bg1 = "#2d3343",
          bg2 = "#343e4f",
          bg3 = "#363c51",
          bg_d = "#1e242e",
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
        },
        highlights = {
          FloatBorder = { bg = "NONE" },
          NormalFloat = { bg = "NONE" }
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
          file_ignore_patterns = { ".git/", "node_modules/" },
          preview = {
            filesize_hook = function(filepath, bufnr, opts)
              local max_bytes = 10000
              local cmd = { "head", "-c", max_bytes, filepath }
              require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
            end
          }
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
          }
        }
      }
      require('telescope').load_extension('fzf')
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
      show_modified = true,
      symbols = {
        ellipsis = "..."
      }
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
  {
    'akinsho/bufferline.nvim',
    version = "v3.*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        separator_style = { ' ', ' ' },
      },
      highlights = {
        duplicate_selected = {
          bg = '#242b38'
        },
        modified_selected = {
          bg = '#242b38'
        },
        close_button_selected = {
          bg = '#242b38'
        },
        indicator_selected = {
          bg = '#242b38'
        },
        buffer_selected = {
          italic = false,
          bg = '#242b38'
        }
      }
    }
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      show_current_context = true,
      char = "▏"
    }
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
  'antoinemadec/FixCursorHold.nvim',
  'nvim-treesitter/nvim-treesitter-context',
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
    opts = {}
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
  'lewis6991/gitsigns.nvim',
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
  }
}, {
  lazy = false,
  version = nil
})

-- borders and colours
local border_opts = {
  border = "rounded",
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
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  servers = {
    golangci_lint_ls = {},
    gopls = {},
    clangd = {},
    dockerls = {},
    eslint = {},
    html = {},
    hls = {},
    jsonls = {},
    cssls = {},
    tailwindcss = {},
    tsserver = {
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
    rust_analyzer = require('lsp-setup.rust-tools').setup({
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
    { name = 'path',     priority = 250 },
    { name = 'nvim_lsp', keyword_length = 3, priority = 1000 },
    { name = 'buffer',   keyword_length = 3, priority = 500 },
    { name = 'luasnip',  keyword_length = 2, priority = 250 },
  },
  window = {
    completion = cmp.config.window.bordered(border_opts),
    documentation = cmp.config.window.bordered(border_opts),
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
sign({ name = 'DiagnosticSignError', text = '✖' })
sign({ name = 'DiagnosticSignWarn', text = '▲' })
sign({ name = 'DiagnosticSignHint', text = '⚑' })
sign({ name = 'DiagnosticSignInfo', text = '' })

-- disable virtaul text for lsp_lines
vim.diagnostic.config({
  virtual_text = false,
})

-- Auto commands
vim.cmd [[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
  augroup END
]]

vim.cmd [[
  augroup diagnostics
    autocmd!
      autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
    augroup END
]]

vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = 'always',
      prefix = '',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)

-- Keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "<leader>o", "<cmd>Telescope find_files hidden=true<cr>", opts)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>t", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
keymap("n", "<leader>c", "<cmd>CodeActionMenu<CR>", opts)
keymap("i", "<C-c>", "<Esc>", opts)
keymap("n", "f", ":HopChar1<cr>", opts)
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
keymap('n', '<M-q>', '<Cmd>BufferClose<CR>', opts)
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
