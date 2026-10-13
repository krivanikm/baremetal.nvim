-- ┌──────────────────────────────────────────────────────────┐
-- │  baremetal.nvim — C / C++ / ASM / Rust / SystemVerilog / ...│
-- └──────────────────────────────────────────────────────────┘
-- Load order: options → keymaps → autocmds → lazy (plugins) → runner
--
-- Layout:
--   lua/config/options.lua   basic vim.opt settings
--   lua/config/keymaps.lua   global keymaps (independent of plugins)
--   lua/config/autocmds.lua  autocommands
--   lua/config/lazy.lua      bootstraps lazy.nvim, loads lua/plugins/*
--   lua/config/runner.lua    "compile and run the current file" (<leader>rr)
--   lua/plugins/*.lua        each file returns a list of plugin specs

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("config.runner")

if vim.uv.fs_stat(vim.fn.stdpath("config") .. "/lua/custom/init.lua") then
  require("custom")
end
