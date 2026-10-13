# Customization

There are two ways to make baremetal.nvim your own:

1. **The `lua/custom/` folder.** Git ignores it, so you can keep pulling updates without conflicts. This is the best choice for small and medium changes.
2. **Fork the repo.** Edit anything you like and install from your fork with `install.sh --repo <your fork URL>`.

## The `lua/custom/` folder

```
~/.config/nvim/lua/custom/
├── languages.lua      which languages are enabled (the installer writes this)
├── init.lua           runs last, after all other config
└── plugins/
    └── *.lua          extra lazy.nvim specs, merged with the built-in ones
```

Every file is optional. Create only the ones you need.

### Languages

`lua/custom/languages.lua` returns the list of enabled languages:

```lua
return {
  "c",
  "rust",
  "python",
}
```

The available keys are `c`, `asm`, `rust`, `systemverilog`, `vhdl`, `python`, `go`, `bash` and `web`.
Lua, JSON, YAML, TOML and Markdown are always on. If the file does not exist, only C/C++, Assembly and SystemVerilog are enabled.

The selection controls four things:

- which LSP servers, formatters and debuggers Mason installs and starts
- which treesitter parsers get compiled
- which language plugins load (rustaceanvim, crates.nvim, clangd_extensions, cmake-tools, nvim-dap, nvim-lint)
- which formatters run on save

After you change the file, restart Neovim and run `:Lazy sync`. Tools that are already installed stay on disk. Remove them in `:Mason` (`X` on a package) if you want the space back.

### Options, keymaps, autocommands

`lua/custom/init.lua` is loaded after everything else, so it can override anything:

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

To turn off format on save permanently:

```lua
vim.g.autoformat = false
```

### Plugins

Every `.lua` file in `lua/custom/plugins/` returns a list of [lazy.nvim specs](https://lazy.folke.io/spec). If a spec names a plugin that already exists, lazy.nvim **merges** it with the built-in one, so you only write the parts you want to change.

#### Change the colour scheme

```lua
return {
  { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "macchiato", transparent_background = true } },
}
```

Or switch to a different theme completely:

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

#### Add a plugin

```lua
return {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
```

#### Disable a plugin

```lua
return {
  { "folke/flash.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
}
```

#### Change a plugin's options

```lua
return {
  { "nvim-neo-tree/neo-tree.nvim", opts = { window = { width = 40, position = "right" } } },
  { "folke/snacks.nvim", opts = { dashboard = { preset = { header = "MY NVIM" } } } },
}
```

#### Add or change a formatter

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

### Add an LSP server that isn't built in

Install the server (`:MasonInstall zls`, or from your package manager), then enable it in `lua/custom/init.lua`:

```lua
vim.lsp.config("zls", {
  settings = { zls = { enable_build_on_save = true } },
})
vim.lsp.enable("zls")
```

`vim.lsp.config` merges with the defaults from nvim-lspconfig, so for most servers `vim.lsp.enable("name")` is all you need.

### Change settings of a built-in server

The same API works on servers that are already set up:

```lua
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
})
```

## Forking

1. Fork the repo on GitHub.
2. Install from your fork:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/<you>/baremetal.nvim/main/install.sh | bash -s -- --repo https://github.com/<you>/baremetal.nvim.git
   ```
   You can also clone your fork anywhere and run `./install.sh` from it, which symlinks `~/.config/nvim` to the clone.
3. Change the default `REPO` at the top of `install.sh` so your one-liner works without `--repo`.

Good places to start:

| What | Where |
|---|---|
| Start screen logo and buttons | `lua/plugins/ui.lua` → `dashboard` |
| Global keymaps | `lua/config/keymaps.lua` |
| Editor options | `lua/config/options.lua` |
| Compile & run commands | `lua/config/runner.lua` → `recipe()` |
| LSP servers and their settings | `lua/plugins/lsp.lua` |
| Which tools / parsers belong to a language | `lua/plugins/lsp.lua`, `lua/plugins/treesitter.lua`, `lua/plugins/format-lint.lua` |
| Adding a new language key | `lua/config/langs.lua` (`M.all`) and `install.sh` (`ALL_LANGS`, `LANG_DESC`) |
