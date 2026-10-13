-- Globálne skratky. Plugin-specifické skratky sú pri pluginoch (keys = {...}).
local map = vim.keymap.set

-- Lepší pohyb po zalomených riadkoch
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Okná
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

-- Buffre
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to last buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to last buffer" })

-- Presun riadkov
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move selection up", silent = true })

-- Odsadenie vo visual móde bez straty výberu
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste bez prepísania registra
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Uloženie / ukončenie
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- Esc zruší highlight vyhľadávania
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape + clear hlsearch" })

-- Vyhľadávanie vždy vycentrované
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Quickfix / location list
map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- Diagnostika
local function diag_jump(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, float = true, severity = severity and vim.diagnostic.severity[severity] })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", diag_jump(1), { desc = "Next diagnostic" })
map("n", "[d", diag_jump(-1), { desc = "Previous diagnostic" })
map("n", "]e", diag_jump(1, "ERROR"), { desc = "Next error" })
map("n", "[e", diag_jump(-1, "ERROR"), { desc = "Previous error" })
map("n", "]w", diag_jump(1, "WARN"), { desc = "Next warning" })
map("n", "[w", diag_jump(-1, "WARN"), { desc = "Previous warning" })

-- Terminál: Esc Esc => normal mode
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Terminal normal mode" })

-- Lazy / Mason
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy (plugins)" })
map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason (LSP/tools)" })
