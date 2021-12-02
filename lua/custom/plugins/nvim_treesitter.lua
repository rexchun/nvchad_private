local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

-- vim.api.nvim_command "set foldmethod=expr"
-- vim.api.nvim_command "set foldexpr=nvim_treesitter#foldexpr()"
treesitter.setup {
  ensure_installed = {
    "c",
    "cpp",
    "rust",
    "lua",
    "python",
    "cmake",
    "vim",
    "fennel",
    "query",
  },
  autopairs = { enable = true },
  matchup = {
    enable = true,
    disale_virtual_textb = false,
    include_match_words = false,
  },
  highlight = {
    enable = true,
    disable = { "racket" },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ["<CR>"] = "textsubjects-smart",
      ["<Tab>"] = "textsubjects-container-outer",
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
}
