-- IMPORTANT NOTE : This is the user config, can be edited. Will be preserved if updated with internal updater
-- This file is for NvChad options & tools, custom settings are split between here and 'lua/custom/init.lua'

local M = {}
M.options, M.ui, M.mappings, M.plugins = {}, {}, {}, {}

-- NOTE: To use this, make a copy with `cp example_chadrc.lua chadrc.lua`

--------------------------------------------------------------------

-- To use this file, copy the structure of `core/default_config.lua`,
-- examples of setting relative number & changing theme:

M.options = {
  backup = false,
  writebackup = false,
  swapfile = false,
  nvChad = {
    insert_nav = false,
  },
}

-- M.ui = {
--    theme = "srcery",
-- }

-- NvChad included plugin options & overrides
M.plugins = {
  status = {
    blankline = false,
    esc_insertmode = false,
  },
  options = {
    lspconfig = {
      -- path of file containing setups of different lsps (ex : "custom.plugins.lspconfig"), read the docs for more info
      setup_lspconf = "custom/plugins/lspconfig",
    },
  },
  -- To change the Packer `config` of a plugin that comes with NvChad,
  -- add a table entry below matching the plugin github name
  --              '-' -> '_', remove any '.lua', '.nvim' extensions
  -- this string will be called in a `require`
  --              use "(custom.configs).my_func()" to call a function
  --              use "custom.blankline" to call a file
  default_plugin_config_replace = {
    nvim_cmp = "custom/plugins/nvim_cmp",
    nvim_autopairs = "custom/plugins/autopairs",
    nvim_treesitter = "custom/plugins/nvim_treesitter",
    luasnip = "custom/plugins/nvim_luasnip",
    indent_blankline = "custom/plugins/blankline",
    signature = "custom/plugins/signature",
  },
}

M.mappings = {
  close_buffer = "<leader>bk",
  save_file = "<leader>bs", -- save file using :w
  window_nav = {
    moveLeft = "<M-h>",
    moveRight = "<M-l>",
    moveUp = "<M-k>",
    moveDown = "<M-j>",
  },
  terminal = {
    -- multiple mappings can be given for esc_termmode and esc_hide_termmode
    -- get out of terminal mode
    esc_termmode = { [[<C-\><C-n>]] }, -- multiple mappings allowed
    -- get out of terminal mode and hide it
    esc_hide_termmode = { "<esc>" }, -- multiple mappings allowed
    -- show & recover hidden terminal buffers in a telescope picker
    pick_term = "<leader>W",
    -- below three are for spawning terminals
    new_horizontal = "<leader>h",
    new_vertical = "<leader>v",
    new_window = "<leader>w",
  },
}

M.mappings.plugins = {
  bufferline = {
    next_buffer = "]b", -- next buffer
    prev_buffer = "[b", -- previous buffer
  },
  -- easily (un)comment code, language aware
  comment = {
    toggle = "gcc", -- toggle comment (works on multiple lines)
  },
  better_escape = { -- <ESC> will still work
    esc_insertmode = { "jj" }, -- multiple mappings allowed
  },
  nvimtree = {
    toggle = "<leader>e",
    focus = "<C-n>",
  },
}

return M
