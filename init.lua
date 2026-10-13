-- ┌──────────────────────────────────────────────────────────┐
-- │  baremetal.nvim — C / C++ / ASM / Rust / SystemVerilog / ...│
-- └──────────────────────────────────────────────────────────┘
-- Poradie: options → keymaps → autocmds → lazy (pluginy) → runner
--
-- Štruktúra:
--   lua/config/options.lua   základné nastavenia vim.opt
--   lua/config/keymaps.lua   globálne skratky (nezávislé od pluginov)
--   lua/config/autocmds.lua  autocommandy
--   lua/config/lazy.lua      bootstrap lazy.nvim, načíta lua/plugins/*
--   lua/config/runner.lua    "skompiluj a spusti aktuálny súbor" (<leader>rr)
--   lua/plugins/*.lua        každý súbor vracia zoznam plugin špecifikácií

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
