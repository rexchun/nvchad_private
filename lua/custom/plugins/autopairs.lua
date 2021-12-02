local present1, npairs = pcall(require, "nvim-autopairs")
local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
local present3, cmp = pcall(require, "cmp")

if not (present1 or present2 or present3) then
  return
end

cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done { map_char = { haskell = "", fennel = "" } }
)

cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"

local cond = require "nvim-autopairs.conds"
local Rule = require "nvim-autopairs.rule"

npairs.setup {
  disable_filetype = { "racket", "clojure", "scheme", "lisp", "fennel" },
  enable_check_bracket_line = true,
  check_ts = true,
  fast_wrap = {},
}

npairs.add_rules {
  Rule(" ", " ")
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ "()", "{}", "[]" }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({ "(  )", "{  }", "[  ]" }, context)
    end),
  Rule("", " )")
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == ")"
    end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key ")",
  Rule("", " }")
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == "}"
    end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key "}",
  Rule("", " ]")
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == "]"
    end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key "]",
}

npairs.get_rule("'")[1]:with_pair(function()
  if vim.bo.filetype == "scheme" or vim.bo.filetype == "racket" then
    return false
  end
end)

_G.my_cr = function()
  if vim.fn.pumvisible() ~= 0 then
    return npairs.esc "<C-e><CR>"
  else
    return npairs.autopairs_cr()
  end
end

vim.api.nvim_set_keymap(
  "i",
  "<CR>",
  "v:lua.my_cr()",
  { noremap = true, silent = true, expr = true }
)
