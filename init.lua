vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- OPTIONS
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- relative numbers
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- lsp
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  -- cmake = {
  --   CMake = {
  --     filetypes = {"cmake", "CMakeLists.txt"},
  --   },
  -- },
}
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_statlazypath then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS
require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- git
  {
    "tpope/vim-fugitive",
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'echasnovski/mini.icons' },
    config = function ()
      local startify = require'alpha.themes.startify'
      require'alpha'.setup(startify.config)
    end,
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim',
        config = function()
          require "mason".setup()
        end
      },
      { 'williamboman/mason-lspconfig.nvim',
        config = function()
          require "mason-lspconfig".setup {
            ensure_installed = vim.tbl_keys(servers),
          }
        end
      },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>c", group = "[C]ode" },
      -- { "<leader>c_", hidden = true },
      { "<leader>d", group = "[D]ocument" },
      -- { "<leader>d_", hidden = true },
      { "<leader>g", group = "[G]it" },
      -- { "<leader>g_", hidden = true },
      { "<leader>r", group = "[R]ename" },
      -- { "<leader>r_", hidden = true },
      { "<leader>s", group = "[S]earch" },
      -- { "<leader>s_", hidden = true },
      { "<leader>w", group = "[W]orkspace" }
      -- { "<leader>w_", hidden = true },
    },
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },
  -- THEME
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("cyberdream").setup({
  --       transparent = true,
  --     })
  --     vim.cmd.colorscheme 'cyberdream'
  --   end,
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function(opts)
      require("catppuccin").setup {
        flavour = "mocha",
        transparent_background = true,
      }
      vim.cmd.colorscheme "catppuccin"
    end
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {
          function ()
            return os.date("%H:%M:%S")
          end
        },
        lualine_z = {
          'location',
          'progress',
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    opts = {

    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',

  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ["<leader>p"] = "feh",
          },
        },
        filtered_items = {
          visible = true,
        },
        commands = {
          feh = function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              vim.system(
                { 'feh', node.path },
                {
                  cwd = vim.fn.getcwd()
                }
              )
            end
          end
        },
      },
    },
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
  },
  {
    'ray-x/lsp_signature.nvim',
    event = "VeryLazy",
    opts = {
      bind = true,

    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end
  },
  {
    'mg979/vim-visual-multi',
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    }
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
          "hello"
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async'
    },
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
      })
    end,
  },
  {
    "j-morano/buffer_manager.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true
  },
}, {})


-- [[ Basic Keymaps ]]

-- KEYBINDS
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'c', 'cpp', 'go', 'lua',
      'python', 'rust', 'tsx',
      'javascript', 'typescript',
      'vimdoc', 'vim', 'bash', 'gdscript'
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      -- swap = {
      --   enable = true,
      --   swap_next = {
      --     ['<leader>a'] = '@parameter.inner',
      --   },
      --   swap_previous = {
      --     ['<leader>A'] = '@parameter.inner',
      --   },
      -- },
    },
  }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('<leader>h', vim.lsp.buf.hover, "LSP [H]over")

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- setup lsp_signature
  require "lsp_signature".on_attach({}, bufnr)
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup_handlers {
  function(server_name)
    if server_name == "rust_analyzer" then
      return
    end
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

require 'lspconfig'.gdscript.setup{}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {})


-- Default shell to powershell if on windows
local os_uname = vim.loop.os_uname().sysname
if string.find(os_uname, "Windows") and true or false then
  vim.opt.shell = 'powershell'
end

-- open neotree on start (after session manager, if applicable)
local neotree_group = vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionLoadPost",
  desc = "Open Neotree on startup",
  group = neotree_group,
  callback = function()
    vim.cmd "Neotree"
  end,
})

-- rustaceanvim
vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end
  }
}


-- editconfig command
vim.api.nvim_create_user_command("EditConfig", function()
  vim.cmd.e(vim.fn.stdpath("config").."/init.lua")
end, {})

local function guess_commands()
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. '/yarn.lock') == 1 then
    return { dev = "yarn dev", build = "yarn build" }
  elseif vim.fn.filereadable(cwd .. '/package.json') == 1 then
    return { dev = "npm run dev", build = "npm run build" }
  elseif vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
    return { build = "cmake -S . -B build && cmake --build build" }
  else
    return nil
  end
end

local function guess_dev_command()
  local commands = guess_commands()
  return commands and commands.dev or nil
end

local function guess_build_command()
  local commands = guess_commands()
  return commands and commands.build or nil
end

local function open_or_goto_terminal()
  local bufnr = vim.fn.bufnr("terminal")
  if bufnr < 0 then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
      "<esc><C-w><C-s><C-w><C-j>:term<cr>:keepalt file terminal<cr>",
      true, true, true
    ))
    return true
  else
    vim.cmd.drop("terminal")
    return false
  end
end

-- buffer keybinds
vim.keymap.set('n', '<leader>lb', require("buffer_manager.ui").toggle_quick_menu, { desc = "Opens buffer manager" })
vim.keymap.set('n', '<leader>a', ":AerialOpen<cr>", { desc = "AerialOpen" })
vim.keymap.set('n', '<leader>t', open_or_goto_terminal, { desc = "Open terminal below" })
vim.keymap.set('n', '<leader><F5>', function()
  local dev_command = vim.g.dev_command or guess_dev_command()
  if dev_command then
    local delay = open_or_goto_terminal() and 500 or 1000/60
    vim.defer_fn(function()
      vim.cmd "startinsert"
      vim.fn.feedkeys(
        vim.api.nvim_replace_termcodes("<C-c>", true, true, true)
      )
      vim.defer_fn(function()
        vim.fn.feedkeys(
          dev_command
          .. vim.api.nvim_replace_termcodes("<cr>", true, true, true)
        )
      end, 1000/60)
    end, delay)
  else
    print "No dev command"
  end
end, { desc = "Run command in dev_command" })

vim.keymap.set('n', '<leader>b', function()
  local build_command = vim.g.build_command or guess_build_command()
  if build_command then
    local delay = open_or_goto_terminal() and 500 or 1000/60
    vim.defer_fn(function()
      vim.cmd "startinsert"
      vim.fn.feedkeys(
        vim.api.nvim_replace_termcodes("<C-c>", true, true, true)
      )
      vim.defer_fn(function()
        vim.fn.feedkeys(
          build_command
          .. vim.api.nvim_replace_termcodes("<cr>", true, true, true)
        )
      end, 1000/60)
    end, delay)
  else
    print "No build command"
  end
end, { desc = "Run command in build_command" })

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- folding
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Git
vim.keymap.set('n', '<leader>g', require('neogit').open)

-- auto load session.vim
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local cwd = vim.fn.getcwd()
    local sessionFile = cwd .. "/.nvim-session"
    if vim.fn.filereadable("'" .. sessionFile .. "'") == 1 then
      vim.fn.execute("source " .. sessionFile)
    end
  end,
  pattern = '*',
})
