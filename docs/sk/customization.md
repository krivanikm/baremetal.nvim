---
title: Prispôsobenie
lang: sk
---

# Prispôsobenie

baremetal.nvim si vieš prispôsobiť dvoma spôsobmi:

1. **Priečinok `lua/custom/`.** Git ho ignoruje, takže môžeš ďalej sťahovať aktualizácie bez konfliktov. Najlepšia voľba pre malé a stredné zmeny.
2. **Fork repa.** Upravíš si čokoľvek a inštaluješ zo svojho forku cez `install.sh --repo <URL tvojho forku>`.

## Priečinok `lua/custom/` {#priecinok-lua-custom}

```
~/.config/nvim/lua/custom/
├── languages.lua      zapnuté jazyky (zapisuje ho inštalátor)
├── init.lua           načíta sa ako posledný, po celom configu
└── plugins/
    └── *.lua          ďalšie lazy.nvim špecifikácie, zlúčia sa so vstavanými
```

Každý súbor je voliteľný. Vytvor len tie, ktoré potrebuješ.

### Jazyky

`lua/custom/languages.lua` vracia zoznam zapnutých jazykov:

```lua
return {
  "c",
  "rust",
  "python",
}
```

Dostupné kľúče sú `c`, `asm`, `rust`, `systemverilog`, `vhdl`, `python`, `go`, `bash` a `web`.
Lua, JSON, YAML, TOML a Markdown sú zapnuté vždy. Ak súbor neexistuje, zapnuté sú len C/C++, Assembly a SystemVerilog.
Podrobnosti sú v časti [Jazyky](languages.html).

Po zmene súboru reštartuj Neovim a spusti `:Lazy sync`. Už nainštalované nástroje ostanú na disku – ak chceš miesto
späť, odstráň ich v `:Mason` (`X` na balíku).

### Nastavenia, skratky, autocommandy

`lua/custom/init.lua` sa načíta po všetkom ostatnom, takže môže prepísať čokoľvek:

```lua
vim.opt.relativenumber = false
vim.opt.colorcolumn = "80"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.keymap.set("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all" })
vim.keymap.set("n", "<leader>rr", "<cmd>make run<cr>", { desc = "make run" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.opt_local.shiftwidth = 8
    vim.opt_local.expandtab = false
  end,
})
```

Natrvalo vypnuté formátovanie pri uložení:

```lua
vim.g.autoformat = false
```

### Pluginy

Každý `.lua` súbor v `lua/custom/plugins/` vracia zoznam [lazy.nvim špecifikácií](https://lazy.folke.io/spec).
Ak špecifikácia pomenuje plugin, ktorý už existuje, lazy.nvim ju **zlúči** so vstavanou, takže píšeš len to, čo chceš zmeniť.

#### Zmena farebnej schémy {#zmena-farebnej-schemy}

```lua
return {
  { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "macchiato", transparent_background = true } },
}
```

Alebo úplne iná téma:

```lua
return {
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
```

#### Pridanie pluginu

```lua
return {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
```

#### Vypnutie pluginu

```lua
return {
  { "folke/flash.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
}
```

#### Zmena nastavení pluginu {#zmena-nastaveni-pluginu}

```lua
return {
  { "nvim-neo-tree/neo-tree.nvim", opts = { window = { width = 40, position = "right" } } },
  { "folke/snacks.nvim", opts = { dashboard = { preset = { header = "MY NVIM" } } } },
}
```

#### Pridanie alebo zmena formátovača {#pridanie-alebo-zmena-formatovaca}

```lua
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { zig = { "zigfmt" } },
      formatters = { clang_format = { prepend_args = { "--style=file", "--fallback-style=google" } } },
    },
  },
}
```

### Pridanie LSP servera, ktorý nie je vstavaný {#pridanie-lsp-servera}

Nainštaluj server (`:MasonInstall zls` alebo cez správcu balíkov) a zapni ho v `lua/custom/init.lua`:

```lua
vim.lsp.config("zls", {
  settings = { zls = { enable_build_on_save = true } },
})
vim.lsp.enable("zls")
```

`vim.lsp.config` sa zlúči s predvolenými nastaveniami z nvim-lspconfig, takže pri väčšine serverov stačí `vim.lsp.enable("meno")`.

### Zmena nastavení vstavaného servera {#zmena-nastaveni-servera}

To isté API funguje aj na servery, ktoré už sú nastavené:

```lua
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
})
```

## Fork

1. Sprav si fork repa na GitHube.
2. Nainštaluj zo svojho forku:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/<ty>/baremetal.nvim/main/install.sh | bash -s -- --repo https://github.com/<ty>/baremetal.nvim.git
   ```
   Fork si môžeš naklonovať aj kamkoľvek a spustiť z neho `./install.sh` – `~/.config/nvim` potom bude symlink na klon.
3. Zmeň predvolené `REPO` na začiatku `install.sh`, aby tvoj príkaz fungoval aj bez `--repo`.

Kde začať:

| Čo | Kde |
|---|---|
| Logo a tlačidlá na úvodnej obrazovke | `lua/plugins/ui.lua` → `dashboard` |
| Globálne skratky | `lua/config/keymaps.lua` |
| Nastavenia editora | `lua/config/options.lua` |
| Príkazy na kompiláciu a spustenie | `lua/config/runner.lua` → `recipe()` |
| LSP servery a ich nastavenia | `lua/plugins/lsp.lua` |
| Ktoré nástroje / parsery patria k jazyku | `lua/plugins/lsp.lua`, `lua/plugins/treesitter.lua`, `lua/plugins/format-lint.lua` |
| Nový jazykový kľúč | `lua/config/langs.lua` (`M.all`) a `install.sh` (`ALL_LANGS`, `LANG_DESC`) |
