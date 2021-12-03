local ok1, cmp = pcall(require, "cmp")
local ok2, cmp_buffer = pcall(require, "cmp_buffer")
local ok3, snippy = pcall(require, "snippy")

if not (ok1 or ok2 or ok3) then
  return
end

local clangd_score = function(entry1, entry2)
  local socre1 = entry1.completion_item.score
  local socre2 = entry2.completion_item.score
  if socre1 and socre2 then
    local diff = socre1 - socre2
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
end

local under = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find "^_+"
  local _, entry2_under = entry2.completion_item.label:find "^_+"
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup {
  completion = {
    completeopt = "menu,menuone,noselect",
    keyword_pattern = [[\k\+]],
  },
  experimental = {
    ghost_text = true,
  },
  documentation = {
    border = "single",
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      function(...)
        return cmp_buffer:compare_locality(...)
      end,
      under,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.sort_text,
      cmp.config.compare.order,
    },
  },
  -- You should change this example to your chosen snippet engine.
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end,
  },
  -- You must set mapping.
  mapping = {
    -- ['<C-n>'] = mapping(mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }), { 'i', 'c' }),
    -- ['<C-p>'] = mapping(mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }), { 'i', 'c' }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-y>"] = cmp.mapping.confirm {
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
        -- vim.fn.feedkeys(t "<Plug>(vsnip-expand-or-jump)", "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
  },
  -- You should specify your *installed* sources.
  sources = {
    { name = "nvim_lsp" },
    -- { name = "luasnip" },
    { name = "snippy" },
    { name = "conjure" },
    {
      name = "buffer",
      keyword_length = 3,
      option = {
        keyword_pattern = [[\k\+]],
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = "path" },
    { name = "calc" },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format(
        "%s %s",
        require("plugins.configs.lspkind_icons").icons[vim_item.kind],
        vim_item.kind
      )

      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer = "[Buf]",
        vsnip = "[Snip]",
        conjure = "[Con]",
      })[entry.source.name]

      vim_item.dup = ({
        conjure = 0,
        nvim_lsp = 0,
      })[entry.source.name] or 0
      return vim_item
    end,
  },
}

cmp.setup.cmdline("/", {
  sources = cmp.config.sources {
    { name = "nvim_lsp_document_symbol" },
  },
  { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

vim.cmd [[
" Setup buffer configuration (nvim-lua source only enables in Lua filetype).
autocmd FileType scheme,fennel lua require'cmp'.setup.buffer {
\   sources = {
\     { name = 'conjure' },
\     { name = 'buffer' },
\   },
\ }
]]
