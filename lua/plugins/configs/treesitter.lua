local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
  return
end

ts_config.setup {
  ensure_installed = {
    "lua",
    "cpp",
    "haskell",
  },
  highlight = {
    enable = true,
  },
  matchup = { enable = true },
}
