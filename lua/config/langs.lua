local M = {}

M.all = { "c", "asm", "rust", "systemverilog", "vhdl", "python", "go", "bash", "web" }

local selected = M.all
local user_file = vim.fn.stdpath("config") .. "/lua/custom/languages.lua"
if vim.uv.fs_stat(user_file) then
  local user = require("custom.languages")
  if type(user) == "table" then
    selected = user
  end
end

M.enabled = {}
for _, lang in ipairs(selected) do
  M.enabled[lang] = true
end

function M.has(...)
  for _, lang in ipairs({ ... }) do
    if M.enabled[lang] then
      return true
    end
  end
  return false
end

function M.pick(groups)
  local out, seen = {}, {}
  for lang, items in pairs(groups) do
    if lang == "core" or M.enabled[lang] then
      for _, item in ipairs(items) do
        if not seen[item] then
          seen[item] = true
          out[#out + 1] = item
        end
      end
    end
  end
  table.sort(out)
  return out
end

return M
