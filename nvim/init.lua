local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
local bo = vim.bo
local wo = vim.wo
local g = vim.g
local o = vim.o
vim.opt.termguicolors = true

-- ensure that packer is installed
local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require 'packer'
local util = require 'packer.util'

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

-- borders and colours
local border_opts = {
  border = "rounded",
}

--- startup and add configure plugins
packer.startup({
  function()
    local use = use
    use {
      'lewis6991/impatient.nvim',
      config = function()
        require 'impatient'
      end
    }
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use {
      'nvim-telescope/telescope.nvim', branch = '0.1.x',
      requires = { { 'nvim-lua/plenary.nvim' } },
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
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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
    }
    use {
      'jghauser/mkdir.nvim'
    }
    use {
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
    }
    use "nvim-tree/nvim-web-devicons"
    use({
      "utilyre/barbecue.nvim",
      tag = "*",
      requires = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
      },
      after = "nvim-web-devicons",     -- keep this if you're using NvChad
      config = function()
        require("barbecue").setup({
          show_modified = true,
          symbols = {
            ellipsis = "..."
          }
        })
      end,
    })
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup({
          options = {
            theme = "onedark",
            icons_enabled = false,
          }
        })
      end
    }
    use {
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('indent_blankline').setup({
          show_current_context = true,
          char = "▏"
        })
      end
    }
    use {
      'junnplus/lsp-setup.nvim',
      requires = {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
      }
    }
    use {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
      end,
    }
    use 'windwp/nvim-ts-autotag'
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
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
    }
    use 'antoinemadec/FixCursorHold.nvim'
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'machakann/vim-highlightedyank'
    use {
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
    }
    use {
      'lewis6991/satellite.nvim',
      config = function()
        require('satellite').setup()
      end
    }
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
        'onsails/lspkind.nvim'
      }
    }
    use {
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end
    }
    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup {
          enable_check_bracket_line = true,
          check_ts = true
        }
      end
    }
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end
    }
    use {
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
    }
    use 'rcarriga/nvim-notify'
    use 'simrat39/rust-tools.nvim'
    use 'rktjmp/highlight-current-n.nvim'
    use 'fedepujol/move.nvim'
    use {
      "stevearc/dressing.nvim",
      config = function()
        require("dressing").setup({
          input = {
            insert_only = true,
          },
        })
      end,
    }
    use {
      'akinsho/git-conflict.nvim',
      tag = "v1.0.0",
      config = function()
        require('git-conflict').setup({
          disable_diagnostics = true
        })
      end
    }
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float(border_opts)
      end
    }
  }
})

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
    tsserver = {},
    pyright = {},
    marksman = {},
    julials = {},
    jdtls = {},
    rust_analyzer = require('lsp-setup.rust-tools').setup({
      tools = {
        inlay_hints = {
          show_parameter_hints = false,
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

-- moves
-- Normal-mode commands
keymap('n', '<A-Down>', ':MoveLine(1)<CR>', opts)
keymap('n', '<A-Up>', ':MoveLine(-1)<CR>', opts)

-- Visual-mode commands
keymap('v', '<A-Down>', ':MoveBlock(1)<CR>', opts)
keymap('v', '<A-Up>', ':MoveBlock(-1)<CR>', opts)
