-- Rýchly "compile & run" pre aktuálny súbor (single-file programy, cvičenia, testbenche).
-- Pre projekty používaj Overseer (<leader>oo) alebo CMake (<leader>m...).
--
--   <leader>rr  skompiluj a spusti aktuálny súbor v termináli
--   <leader>rb  len skompiluj (chyby idú do quickfixu)
--   <leader>rd  skompiluj s -g a spusti debugger (DAP) na výsledku

local M = {}

local out_dir = vim.fn.stdpath("cache") .. "/run"
vim.fn.mkdir(out_dir, "p")

local function q(s)
  return vim.fn.shellescape(s)
end

-- Vráti { build = "...", run = "...", bin = "..." } pre daný filetype
local function recipe(file)
  local ft = vim.bo.filetype
  local name = vim.fn.fnamemodify(file, ":t:r")
  local bin = out_dir .. "/" .. name
  local r = {
    c = { build = ("gcc -std=c17 -g -O0 -Wall -Wextra -fsanitize=address,undefined %s -o %s -lm"):format(q(file), q(bin)) },
    cpp = { build = ("g++ -std=c++23 -g -O0 -Wall -Wextra -fsanitize=address,undefined %s -o %s"):format(q(file), q(bin)) },
    -- GAS: ak súbor definuje _start, linkuj bez libc startupu, inak cez main
    asm = {
      build = ("gcc -g -no-pie %s %s -o %s"):format(
        vim.fn.search("_start", "nw") > 0 and "-nostartfiles" or "",
        q(file),
        q(bin)
      ),
    },
    rust = { build = ("rustc -g --edition 2024 %s -o %s"):format(q(file), q(bin)) },
    go = { run = ("go run %s"):format(q(file)) },
    python = { run = ("python3 %s"):format(q(file)) },
    lua = { run = ("lua %s"):format(q(file)) },
    sh = { run = ("bash %s"):format(q(file)) },
    -- SystemVerilog/Verilog: Icarus (simulácia testbenchu), alternatíva: verilator --binary
    systemverilog = { build = ("iverilog -g2012 -Wall -o %s %s"):format(q(bin), q(file)), run = "vvp " .. q(bin) },
    verilog = { build = ("iverilog -g2005 -Wall -o %s %s"):format(q(bin), q(file)), run = "vvp " .. q(bin) },
  }
  local x = r[ft]
  if not x then
    return nil
  end
  -- Cargo projekt => cargo run
  if ft == "rust" and vim.fs.root(file, "Cargo.toml") then
    return { run = "cargo run", cwd = vim.fs.root(file, "Cargo.toml") }
  end
  x.bin = bin
  if x.build and not x.run then
    x.run = q(bin)
  end
  return x
end

local function term(cmd, cwd)
  Snacks.terminal.open(cmd, {
    cwd = cwd,
    interactive = false, -- ostane otvorený po skončení, q zatvorí
    win = { position = "bottom", height = 0.35 },
  })
end

function M.run()
  vim.cmd("silent! write")
  local file = vim.api.nvim_buf_get_name(0)
  local r = recipe(file)
  if not r then
    return vim.notify("Runner: nepodporovaný filetype " .. vim.bo.filetype, vim.log.levels.WARN)
  end
  local cmd = r.build and (r.build .. " && " .. r.run) or r.run
  term({ "sh", "-c", cmd }, r.cwd or vim.fn.fnamemodify(file, ":h"))
end

-- Synchronný build, výstup do quickfixu. Vráti cestu k binárke alebo nil.
function M.build()
  vim.cmd("silent! write")
  local file = vim.api.nvim_buf_get_name(0)
  local r = recipe(file)
  if not r or not r.build then
    vim.notify("Runner: tento filetype nemá build krok", vim.log.levels.WARN)
    return nil
  end
  local res = vim.system({ "sh", "-c", r.build }, { text = true }):wait()
  local output = (res.stdout or "") .. (res.stderr or "")
  vim.fn.setqflist({}, "r", { title = r.build, lines = vim.split(output, "\n", { trimempty = true }) })
  if res.code ~= 0 then
    vim.notify("Build zlyhal", vim.log.levels.ERROR)
    vim.cmd("copen")
    return nil
  end
  vim.notify("Build OK → " .. r.bin)
  return r.bin
end

function M.debug()
  if not pcall(require, "dap") then
    return vim.notify("Runner: debugger nie je zapnutý (vyber C/ASM/Rust v lua/custom/languages.lua)", vim.log.levels.WARN)
  end
  local bin = M.build()
  if not bin then
    return
  end
  require("dap").run({
    name = "Runner debug",
    type = "codelldb",
    request = "launch",
    program = bin,
    cwd = vim.fn.expand("%:p:h"),
    stopOnEntry = false,
  })
end

vim.keymap.set("n", "<leader>rr", M.run, { desc = "Run súbor" })
vim.keymap.set("n", "<leader>rb", M.build, { desc = "Build súbor" })
vim.keymap.set("n", "<leader>rd", M.debug, { desc = "Build + debug súbor" })

return M
