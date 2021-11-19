local M = {}
local util = require "lspconfig/util"

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"

  local servers = { "hls" }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 100,
      },
    }
  end

  require("rust-tools").setup {
    server = {
      on_attach = attach,
      capabilities = capabilities,
      filetypes = { "rust" },
      flags = {
        debounce_text_changes = 100,
      },
    },
  }

  lspconfig.racket_langserver.setup {
    on_attach = attach,
    capabilities = capabilities,
    filetypes = { "racket" },
  }

  lspconfig.clangd.setup {
    on_attach = attach,
    capabilities = capabilities,
    filetypes = { "objc", "objcpp", "cuda" },
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
    flags = {
      debounce_text_changes = 100,
    },
  }

  lspconfig.ccls.setup {
    on_attach = attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp" },
    cmd = { "ccls" },
    root_dir = function(fname)
      return util.root_pattern(
        "compile_commands.json",
        ".git",
        ".ccls-root",
        ".ccls"
      )(fname) or util.path.dirname(fname)
    end,
    init_options = {
      capabilities = {
        foldingRangeProvider = false,
        workspace = {
          workspaceFolders = {
            supported = false,
          },
        },
      },
      index = {
        onChange = false,
        -- trackDependency = 2,
        initialNoLinkage = true,
      },
      -- completion = {
      --   filterAndSort = false,
      -- },
      cache = {
        directory = "/tmp/ccls-cache/",
      },
    },
    flags = {
      debounce_text_changes = 100,
    },
  }

  lspconfig.sumneko_lua.setup {
    on_attach = attach,
    capabilities = capabilities,
    commands = {
      Format = {
        function()
          require("stylua-nvim").format_file()
        end,
      },
    },
    filetypes = { "lua" },
    cmd = {
      "/home/rhcher/workspace/lua-language-server/bin/Linux/lua-language-server",
      "/home/rhcher/workspace/lua-language-server/main.lua",
    },
    settings = {
      Lua = {
        diagnostics = {
          enable = true,
          globals = { "vim", "packer_plugins" },
        },
        completion = {
          callSnippet = "Replace",
        },
        hint = {
          enable = false,
        },
        runtime = { version = "LuaJIT" },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
        },
        IntelliSense = {
          traceLocalSet = true,
          traceReturn = true,
          traceBeSetted = true,
          traceFieldInject = true,
        },
        telemetry = {
          enable = false,
        },
      },
    },
    flags = {
      debounce_text_changes = 100,
    },
  }
end

return M
