-- Globálne skratky. Plugin-specifické skratky sú pri pluginoch (keys = {...}).
local map = vim.keymap.set

-- Lepší pohyb po zalomených riadkoch
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Okná
map("n", "<C-h>", "<C-w>h", { desc = "Okno vľavo" })
map("n", "<C-j>", "<C-w>j", { desc = "Okno dole" })
map("n", "<C-k>", "<C-w>k", { desc = "Okno hore" })
map("n", "<C-l>", "<C-w>l", { desc = "Okno vpravo" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Zväčšiť výšku" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Zmenšiť výšku" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Zmenšiť šírku" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Zväčšiť šírku" })
map("n", "<leader>-", "<C-w>s", { desc = "Split dole" })
map("n", "<leader>|", "<C-w>v", { desc = "Split vpravo" })
map("n", "<leader>wd", "<C-w>c", { desc = "Zavrieť okno" })
map("n", "<leader>wo", "<C-w>o", { desc = "Iba toto okno" })
map("n", "<leader>w=", "<C-w>=", { desc = "Vyrovnať okná" })

-- Buffre
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Predošlý buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Ďalší buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Prepnúť na posledný buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Prepnúť na posledný buffer" })

-- Presun riadkov
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Riadok dole" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Riadok hore" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Riadok dole" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Riadok hore" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Výber dole", silent = true })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Výber hore", silent = true })

-- Odsadenie vo visual móde bez straty výberu
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste bez prepísania registra
map("x", "<leader>p", [["_dP]], { desc = "Paste bez yanku" })

-- Uloženie / ukončenie
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Uložiť" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Ukončiť všetko" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "Nový súbor" })

-- Esc zruší highlight vyhľadávania
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape + zrušiť hlsearch" })

-- Vyhľadávanie vždy vycentrované
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Quickfix / location list
map("n", "[q", vim.cmd.cprev, { desc = "Predošlý quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Ďalší quickfix" })

-- Diagnostika
local function diag_jump(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, float = true, severity = severity and vim.diagnostic.severity[severity] })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostika riadku" })
map("n", "]d", diag_jump(1), { desc = "Ďalšia diagnostika" })
map("n", "[d", diag_jump(-1), { desc = "Predošlá diagnostika" })
map("n", "]e", diag_jump(1, "ERROR"), { desc = "Ďalšia chyba" })
map("n", "[e", diag_jump(-1, "ERROR"), { desc = "Predošlá chyba" })
map("n", "]w", diag_jump(1, "WARN"), { desc = "Ďalšie varovanie" })
map("n", "[w", diag_jump(-1, "WARN"), { desc = "Predošlé varovanie" })

-- Terminál: Esc Esc => normal mode
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Normal mód v termináli" })

-- Lazy / Mason
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy (pluginy)" })
map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason (LSP/nástroje)" })
