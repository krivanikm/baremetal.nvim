local opt = vim.opt

-- Put Mason binaries (LSP, formatters, tree-sitter CLI, codelldb) on PATH right away,
-- so treesitter/conform can see them before mason.nvim is loaded.
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- lualine shows the mode
opt.laststatus = 3 -- one global statusline
opt.cmdheight = 1
opt.pumheight = 12
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "\u{f078}", foldclose = "\u{f054}", foldsep = " " }
opt.winborder = "rounded" -- borders for all floating windows (0.11+)
opt.colorcolumn = "100"
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.conceallevel = 2
opt.confirm = true

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true
opt.virtualedit = "block"
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.updatetime = 200
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect" }
opt.formatoptions = "jcroqlnt"
opt.inccommand = "split" -- live preview of :s///

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- Treesitter folding (enabled per buffer in plugins/treesitter.lua)
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""

-- Assembly: *.s/*.S default to GAS syntax
vim.g.asmsyntax = "asm"

-- Disable unused providers (faster startup, quiet :checkhealth)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Global format-on-save switch (<leader>uf)
vim.g.autoformat = true

-- Extra filetypes
vim.filetype.add({
  extension = {
    vh = "verilog",
    svh = "systemverilog",
    nasm = "nasm",
    asm = "nasm",
    inc = "nasm",
    ld = "ld",
    lds = "ld",
    xdc = "tcl",
    sdc = "tcl",
    cu = "cuda",
    -- h = "c", -- uncomment if you write plain C (nvim treats .h as cpp by default)
  },
  filename = {
    [".clang-format"] = "yaml",
    [".clang-tidy"] = "yaml",
    [".asm-lsp.toml"] = "toml",
  },
})
