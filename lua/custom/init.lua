-- This is where your custom modules and plugins go.
-- See the wiki for a guide on how to extend NvChad

local hooks = require "core.hooks"
-- vim.cmd [[au FileType racket,clojure,fennel,scheme colorscheme srcery]]

vim.cmd [[set grepformat="%f:%l:%c:%m"]]
vim.cmd [[set grepprg="rg --hidden --vimgrep --smart-case --"]]
vim.cmd [[set jumpoptions="stack"]]
vim.cmd [[let maplocalleader=","]]
vim.cmd [[set scrolloff=4]]
vim.cmd [[set scrolloff=4]]
vim.cmd [[set sidescrolloff=5]]
vim.cmd [[set nowrap]]
vim.cmd [[set noswapfile]]
vim.cmd [[set nobackup]]
vim.cmd [[set pumheight=10]]

-- vim_matchup
vim.g.matchup_matchparen_deferred = 1
-- vim.cmd [[autocmd FileType scheme,racket,fennel,clojure let b:matchup_matchparen_hi_surround_always = 1]]
vim.cmd [[let g:matchup_matchparen_offscreen = {'method': 'status_manual'}]]

-- sexp
-- vim.cmd [[let g:sexp_filetypes = 'clojure,scheme,lisp,timl,fennel']]

vim.cmd [[inoremap <silent> jj <esc>]]
vim.cmd [[snoremap <silent> jj <esc>]]
vim.cmd [[inoremap <silent> <C-j> <Esc>o]]
vim.cmd [[inoremap <silent> <C-k> <Esc>O]]
vim.cmd [[nnoremap : ;]]
vim.cmd [[nnoremap ; :]]
vim.cmd [[xnoremap : ;]]
vim.cmd [[xnoremap ; :]]
vim.cmd [[nnoremap n nzz]]
vim.cmd [[nnoremap N Nzz]]
vim.cmd [[tnoremap <a-h> <c-\><c-n><c-w>h]]
vim.cmd [[tnoremap <a-l> <c-\><c-n><c-w>l]]
vim.cmd [[tnoremap <a-j> <c-\><c-n><c-w>j]]
vim.cmd [[tnoremap <a-k> <c-\><c-n><c-w>k]]

vim.cmd [[imap <expr> <C-l>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Esc>A']]
vim.cmd [[smap <expr> <C-l>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Esc>A']]
vim.cmd [[smap <expr> <C-h>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<Esc>I']]
vim.cmd [[smap <expr> <C-h>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<Esc>I']]

vim.api.nvim_set_keymap(
  "n",
  "<leader>le",
  "vim.diagnostic.open_float()",
  { silent = true, noremap = true }
)

-- splitjoin
-- vim.g.splitjoin_split_mapping = ""
-- vim.g.splitjoin_join_mapping = ""
-- NOTE: To use this, make a copy with `cp example_init.lua init.lua`

--------------------------------------------------------------------

-- To modify packaged plugin configs, use the overrides functionality
-- if the override does not exist in the plugin config, make or request a PR,
-- or you can override the whole plugin config with 'chadrc' -> M.plugins.default_plugin_config_replace{}
-- this will run your config instead of the NvChad config for the given plugin

-- hooks.override("lsp", "publish_diagnostics", function(current)
--   current.virtual_text = false;
--   return current;
-- end)

-- To add new mappings, use the "setup_mappings" hook,
-- you can set one or many mappings
-- example below:

-- To add new plugins, use the "install_plugin" hook,
-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- examples below:

hooks.add("install_plugins", function(use)
  use {
    "kevinhwang91/nvim-bqf",
    branch = "dev",
    ft = "qf",
    config = function()
      require("bqf").setup {
        preview = {
          auto_preview = false,
        },
      }
      vim.cmd [[au FileType qf nnoremap <buffer><silent> q :ccl<CR>]]
    end,
  }

  use {
    "wellle/targets.vim",
    config = function()
      vim.g.targets_seekRanges =
        "cc cr cb cB lc ac Ac lr lb ar ab rr rb bb ll al aa"
    end,
  }
  use {
    "hrsh7th/vim-eft",
    opt = true,
    config = function()
      vim.g.eft_ignorecase = true
    end,
  }

  use {
    "machakann/vim-sandwich",
    commit = "4cd1ea8db6aa43af8e1996422e2010c49d3a5998",
    config = function()
      vim.cmd [[let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)]]
      vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]
    end,
  }

  use {
    "ggandor/lightspeed.nvim",
    event = "BufWinEnter",
    config = function()
      vim.cmd [[autocmd colorscheme * lua require'lightspeed'.init_highlight(true)]]
      -- vim.cmd [[au FileType racket,clojure,fennel,scheme lua require("lightspeed").init_highlight(true)]]
    end,
  }

  use {
    "tpope/vim-sleuth",
    cmd = "Sleuth",
    config = function()
      vim.g.sleuth_automatic = 1
    end,
  }

  use {
    "wlangstroth/vim-racket",
    ft = "racket",
  }

  use {
    "Olical/conjure",
    branch = "develop",
    ft = { "racket", "scheme", "fennel", "lisp" },
    config = function()
      vim.cmd [[let g:conjure#client#scheme#stdio#command = "petite"]]
      vim.cmd [[let g:conjure#client#scheme#stdio#prompt_pattern = "\n?> $"]]
      vim.cmd [[let g:conjure#client#scheme#stdio#value_prefix_pattern = v:false]]
      vim.cmd [[let g:conjure#highlight#enabled = v:true]]
    end,
  }

  use {
    "Olical/aniseed",
    branch = "develop",
    after = "conjure",
    config = function()
      vim.cmd [[let g:conjure#client#fennel#aniseed#aniseed_module_prefix = "aniseed."]]
    end,
  }

  use { "tpope/vim-sexp-mappings-for-regular-people", after = "vim-sexp" }

  use {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  }

  use { "antoinemadec/FixCursorHold.nvim" }

  use { "tpope/vim-repeat", event = "BufReadPre" }

  use { "ckipp01/stylua-nvim", ft = "lua" }

  use { "rhcher/srcery-vim" }

  use {
    "karb94/neoscroll.nvim",
    event = "BufRead",
    config = function()
      require("neoscroll").setup()
    end,
  }

  use {
    "PaterJason/cmp-conjure",
    after = "nvim-cmp",
  }

  use {
    "bakpakin/fennel.vim",
  }

  use {
    "TimUntersberger/neogit",
    requires = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
      local neogit = require "neogit"
      neogit.setup {
        integrations = {
          diffview = true,
        },
      }
    end,
    cmd = "Neogit",
  }

  use {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup {}
    end,
  }

  use {
    "mhinz/vim-grepper",
    keys = { "gs", "<leader>*" },
    cmd = "Grepper",
    config = function()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>*",
        ":Grepper -tool rg -cword -noprompt<CR>",
        { noremap = true }
      )
      vim.g.grepper = {
        tools = { "rg", "git" },
        dir = "repo,file",
        open = 0,
        switch = 1,
        jump = 0,
        simple_prompt = 1,
        quickfix = 1,
        searchreg = 1,
        highlight = 0,
        stop = 10000,
        rg = {
          grepprg = "rg -H --no-heading --vimgrep --smart-case",
          grepformat = "%f:%l:%c:%m,%f:%l:%m",
        },
      }

      vim.cmd(
        ([[aug Grepper
              au!
              au User Grepper ++nested %s | %s
           aug END]]):format(
          [[call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})]],
          "bo cope"
        )
      )

      vim.cmd [[command! Todo :Grepper -noprompt -tool git -grepprg git grep -nIi '\(TODO\|FIXME\)']]

      vim.cmd [[nmap gs  <plug>(GrepperOperator)
                xmap gs  <plug>(GrepperOperator)]]
    end,
  }

  use {
    "hrsh7th/cmp-cmdline",
    after = "nvim-cmp",
  }

  use {
    "rhcher/zephyr-nvim",
  }

  use {
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    after = "nvim-cmp",
  }

  use {
    "eraserhd/parinfer-rust",
    cmd = "ParinferOn",
  }

  use {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  }

  use {
    "hrsh7th/vim-vsnip",
    event = "InsertEnter",
    config = function()
      vim.cmd [[let g:vsnip_snippet_dirs = ["~/.local/share/nvim/site/pack/packer/opt/friendly-snippets/snippets/"] ]]
    end,
  }

  use {
    "hrsh7th/cmp-vsnip",
    after = "nvim-cmp",
  }

  -- use {
  --   "RRethy/vim-illuminate",
  --   config = function()
  --     vim.g.Illuminate_delay = 400
  --     vim.g.Illuminate_insert_mode_highlight = 1
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<a-n>",
  --       '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
  --       { noremap = true, silent = true }
  --     )
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<a-p>",
  --       '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
  --       { noremap = true, silent = true }
  --     )
  --   end,
  -- }

  use {
    "neovimhaskell/haskell-vim",
    ft = "haskell",
  }

  use { "Shougo/context_filetype.vim" }

  use {
    "guns/vim-sexp",
    ft = { "racket", "fennel", "clojure", "scheme" },
    setup = function()
      vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel,racket"
    end,
    config = function()
      vim.g.sexp_enable_insert_mode_mappings = 0
    end,
  }

  use {
    "AndrewRadev/splitjoin.vim",
    -- cmd = { "SplitjoinJoin", "SplitjoinSplit" },
    config = function()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>j",
        "<cmd>SplitjoinSplit<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>k",
        "<cmd>SplitjoinJoin<CR>",
        { noremap = true, silent = true }
      )
    end,
  }

  use {
    "RRethy/nvim-treesitter-textsubjects",
    after = "nvim-treesitter",
  }
end)

-- alternatively, put this in a sub-folder like "lua/custom/plugins/mkdir"
-- then source it with

-- require "custom.plugins.mkdir"
