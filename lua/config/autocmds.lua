local function augroup(name) return vim.api.nvim_create_augroup("ide_" .. name, { clear = true }) end
local au = vim.api.nvim_create_autocmd

-- Briefly highlight yanked text
au("TextYankPost", {
  group = augroup("yank"),
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Return to the last cursor position in the file
au("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(ev)
    local exclude = { "gitcommit" }
    if vim.tbl_contains(exclude, vim.bo[ev.buf].filetype) or vim.b[ev.buf].last_loc_done then
      return
    end
    vim.b[ev.buf].last_loc_done = true
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Equalize splits when the terminal is resized
au("VimResized", {
  group = augroup("resize"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Close helper windows with q
au("FileType", {
  group = augroup("close_q"),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "notify", "startuptime", "dap-float", "grug-far" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true, desc = "Close" })
  end,
})

-- Text files: wrap + spell
au("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Per-language indentation (guess-indent overrides it based on file contents)
au("FileType", {
  group = augroup("indent"),
  pattern = { "lua", "verilog", "systemverilog", "json", "yaml", "toml", "html", "css", "javascript", "typescript" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
au("FileType", {
  group = augroup("indent_tabs"),
  pattern = { "make", "go", "asm", "nasm" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 8
    vim.opt_local.tabstop = 8
  end,
})

-- Create missing directories on save
au("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(ev)
    if ev.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Reload the file if it changed outside nvim
au({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})
