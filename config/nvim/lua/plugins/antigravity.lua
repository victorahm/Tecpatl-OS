return {
  "NakLast/antigravity-cli.nvim",
  config = function()
    require("antigravity").setup({
      -- You can override the default command here if needed
      cmd = "agy",
      width_ratio = 0.8,
      height_ratio = 0.8,
      border = "rounded",
    })
  end,
}
