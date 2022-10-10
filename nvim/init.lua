local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
local bo = vim.bo
local wo = vim.wo
local g = vim.g
local o = vim.o
vim.opt.termguicolors = true

-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require'packer'
local util = require'packer.util'

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
  local use = use
  use {
    'lewis6991/impatient.nvim',
    config = function()
      require'impatient'
    end
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require'telescope'.setup {
        defaults = {
          file_ignore_patterns = { ".git/", "node_modules/" },
        },
        pickers = {
          find_files = {
            hidden = false,
          }
        }
      }
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
        style = 'dark',
        transparent = true,
        code_style = {
          comments = "none",
          keywords = "bold"
        },
        diagnostics = {
          darker = false,
          background = false
        }
      })
      onedark.load()
    end
  }
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
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
      }
    end
  }
  use 'antoinemadec/FixCursorHold.nvim'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'machakann/vim-highlightedyank'
  use {
    'mfussenegger/nvim-ts-hint-textobject',
    config = function()
      require'nvim-treesitter.configs'.setup {
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
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
          },
        },
      }
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
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu'
  }
  use "kyazdani42/nvim-web-devicons"
  use {
    'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require'bufferline'.setup {
        auto_hide = true,
        closable = false,
        clickable = false
      } 
    end
  }
  use {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end
  }
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
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
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end
  }
  use 'rcarriga/nvim-notify'
  use 'simrat39/rust-tools.nvim'
  use 'rktjmp/highlight-current-n.nvim'
  use {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          insert_only = false,
        },
      })
    end,
  }
  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            layout = "diff3_mixed"
          }
        },
        file_panel = {
          listing_style = "list",
        }
      })
    end
  }
  end
)

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
vim.opt.completeopt = { 'menuone', 'noselect'}
vim.opt.updatetime = 500
local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = {behavior = cmp.SelectBehavior.Select}
local lspkind = require('lspkind')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    })
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),
  },
})

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Vim options
vim.opt.smartcase = true
wo.number = true
wo.scrolloff = 8
wo.sidescrolloff = 8
wo.wrap = false
wo.cursorline = true
o.undodir="/tmp/.vim-undo-dir"
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
sign({name = 'DiagnosticSignError', text = '✖'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

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

-- Keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "<leader>o", "<cmd>Telescope find_files hidden=true<cr>", opts)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>b", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
keymap("n", "<leader>c", "<cmd>CodeActionMenu<CR>", opts)
keymap("i", "<C-c>", "<Esc>", opts)
keymap("n", "f", ":HopChar1<cr>", opts) 
keymap("n", "<leader>m", ":DiffviewOpen<CR>", opts) 
keymap('n', '<C-/>', '<CMD>lua require("Comment.api").toggle.linewise.current()<CR>', {})
keymap('x', '<C-/>', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', {})

-- tree hopping
keymap('o', "m", ":<C-U>lua require('tsht').nodes()<CR>", {silent = true})
keymap('x', "m", ":lua require('tsht').nodes()<CR>", opts)

-- window splits
keymap("n", "<leader>w", "<C-w>k", {})
keymap("n", "<leader>a", "<C-w>h", {})
keymap("n", "<leader>s", "<C-w>j", {})
keymap("n", "<leader>d", "<C-w>l", {})

-- tabs
keymap('n', '<M-,>', '<Cmd>BufferPrevious<CR>', opts)
keymap('n', '<M-.>', '<Cmd>BufferNext<CR>', opts)
keymap('n', '<M-q>', '<Cmd>BufferClose<CR>', opts)
keymap('n', '<M-1>', '<Cmd>BufferGoto 1<CR>', opts)
keymap('n', '<M-2>', '<Cmd>BufferGoto 2<CR>', opts)
keymap('n', '<M-3>', '<Cmd>BufferGoto 3<CR>', opts)
keymap('n', '<M-4>', '<Cmd>BufferGoto 4<CR>', opts)
keymap('n', '<M-5>', '<Cmd>BufferGoto 5<CR>', opts)
keymap('n', '<M-6>', '<Cmd>BufferGoto 6<CR>', opts)
keymap('n', '<M-7>', '<Cmd>BufferGoto 7<CR>', opts)
keymap('n', '<M-8>', '<Cmd>BufferGoto 8<CR>', opts)
keymap('n', '<M-9>', '<Cmd>BufferGoto 9<CR>', opts)

