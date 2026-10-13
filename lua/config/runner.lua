-- Quick "compile & run" for the current file (single-file programs, exercises, testbenches).
-- For projects use Overseer (<leader>oo) or CMake (<leader>m...).
--
--   <leader>rr  compile and run the current file in a terminal
--   <leader>rb  compile only (errors go to quickfix)
--   <leader>rd  compile with -g and start the debugger (DAP) on the result

local M = {}

local out_dir = vim.fn.stdpath("cache") .. "/run"
vim.fn.mkdir(out_dir, "p")

local function q(s) return vim.fn.shellescape(s) end

local function hdl(file, bin)
  local top = ""
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    local m = line:match("^%s*module%s+([%w_]+)")
    if m then
      top = "-s " .. q(m)
      break
    end
  end
  local root = vim.fs.root(file, { "verible.filelist", "files.f" })
  if root then
    local list = vim.uv.fs_stat(root .. "/verible.filelist") and "verible.filelist" or "files.f"
    return {
      build = ("iverilog -g2012 -Wall %s -o %s -c %s"):format(top, q(bin), q(list)),
      run = "vvp " .. q(bin),
      cwd = root,
    }
  end
  local dir = vim.fn.fnamemodify(file, ":h")
  local files = vim.fs.find(
    function(name) return name:match("%.s?v$") ~= nil end,
    { path = dir, type = "file", limit = math.huge }
  )
  local args = vim.tbl_map(q, files)
  return {
    build = ("iverilog -g2012 -Wall %s -o %s %s"):format(top, q(bin), table.concat(args, " ")),
    run = "vvp " .. q(bin),
  }
end

-- Returns { build = "...", run = "...", bin = "..." } for the current filetype
local function recipe(file)
  local ft = vim.bo.filetype
  local name = vim.fn.fnamemodify(file, ":t:r")
  local bin = out_dir .. "/" .. name .. "-" .. vim.fn.sha256(file):sub(1, 8)
  local r = {
    c = {
      build = ("gcc -std=c17 -g -O0 -Wall -Wextra -fsanitize=address,undefined %s -o %s -lm"):format(q(file), q(bin)),
    },
    cpp = {
      build = ("g++ -std=c++23 -g -O0 -Wall -Wextra -fsanitize=address,undefined %s -o %s"):format(q(file), q(bin)),
    },
    -- GAS: if the file defines _start, link without libc startup, otherwise through main
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
  }
  if ft == "systemverilog" or ft == "verilog" then
    r[ft] = hdl(file, bin)
  end
  local x = r[ft]
  if not x then
    return nil
  end
  -- Cargo project => cargo run
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
    interactive = false, -- stays open after it finishes, q closes it
    win = { position = "bottom", height = 0.35 },
  })
end

function M.run()
  vim.cmd("silent! write")
  local file = vim.api.nvim_buf_get_name(0)
  local r = recipe(file)
  if not r then
    return vim.notify("Runner: unsupported filetype " .. vim.bo.filetype, vim.log.levels.WARN)
  end
  local cmd = r.build and (r.build .. " && " .. r.run) or r.run
  term({ "sh", "-c", cmd }, r.cwd or vim.fn.fnamemodify(file, ":h"))
end

-- Synchronous build, output goes to quickfix. Returns the binary path or nil.
function M.build()
  vim.cmd("silent! write")
  local file = vim.api.nvim_buf_get_name(0)
  local r = recipe(file)
  if not r or not r.build then
    vim.notify("Runner: this filetype has no build step", vim.log.levels.WARN)
    return nil
  end
  local res = vim.system({ "sh", "-c", r.build }, { text = true, cwd = r.cwd or vim.fn.fnamemodify(file, ":h") }):wait()
  local output = (res.stdout or "") .. (res.stderr or "")
  vim.fn.setqflist({}, "r", { title = r.build, lines = vim.split(output, "\n", { trimempty = true }) })
  if res.code ~= 0 then
    vim.notify("Build failed", vim.log.levels.ERROR)
    vim.cmd("copen")
    return nil
  end
  vim.notify("Build OK → " .. r.bin)
  return r.bin
end

function M.debug()
  if not pcall(require, "dap") then
    return vim.notify(
      "Runner: debugger is disabled (enable c, asm or rust in lua/custom/languages.lua)",
      vim.log.levels.WARN
    )
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

vim.keymap.set("n", "<leader>rr", M.run, { desc = "Run file" })
vim.keymap.set("n", "<leader>rb", M.build, { desc = "Build file" })
vim.keymap.set("n", "<leader>rd", M.debug, { desc = "Build + debug file" })

return M
