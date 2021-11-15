local function prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end

local luasnip = prequire "luasnip"

vim.cmd [[imap <silent><expr> <C-l> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Esc>A']]
vim.cmd [[imap <silent><expr> <C-h> '<Plug>luasnip-jump-prev']]

local chadrc_config = require("core.utils").load_config()
luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}
require("luasnip/loaders/from_vscode").load {
  path = { chadrc_config.plugins.options.luasnip.snippet_path },
}
