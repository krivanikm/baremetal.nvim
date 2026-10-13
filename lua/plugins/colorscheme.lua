return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000, -- load before everything else
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      term_colors = true,
      dim_inactive = { enabled = true, percentage = 0.15 },
      styles = { comments = { "italic" }, keywords = { "italic" } },
      auto_integrations = true, -- integrations for installed plugins
      custom_highlights = function(c)
        return {
          LineNr = { fg = c.overlay0 },
          CursorLineNr = { fg = c.peach, style = { "bold" } },
        }
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- Alternative themes (<leader>uC switches)
  { "folke/tokyonight.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
}
