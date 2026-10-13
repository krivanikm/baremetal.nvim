<div align="center">

# baremetal.nvim

**A Neovim IDE for low-level and hardware work: C, C++, Assembly, Rust, SystemVerilog and VHDL.**

Built on `lazy.nvim` and the native LSP API of Neovim 0.11+.
Pick only the languages you need, and the installer sets up the rest.

[Install](#install) · [Languages](#languages) · [Keymaps](docs/keymaps.md) · [Customize](docs/customization.md) · [Tutor](#tutor) · [Slovensky](README.sk.md)

</div>

---

## Features

- **Language servers that work on first start.** Mason installs clangd, rust-analyzer, verible, vhdl_ls, asm-lsp and the rest automatically.
- **Compile and run the current file with `<Space>rr`.** C/C++ builds with AddressSanitizer and UBSan, Rust uses `cargo run`, and Verilog testbenches run through Icarus.
- **Debugger.** codelldb and native GDB, including a remote GDB target for embedded boards (OpenOCD, QEMU).
- **C/C++ projects.** CMake integration (configure, build, run, debug, CTest) generates `compile_commands.json` for clangd.
- **HDL support.** The verible language server and formatter, plus a verilator linter that resolves modules across folders.
- **Formatting on save** with conform.nvim. Toggle it with `<Space>uf`.
- **Fuzzy finding and grep** for files, symbols, keymaps and diagnostics, all through snacks.nvim.
- **Git tools.** Lazygit, hunk staging, blame and a diff view.
- **Treesitter text objects and motions**: functions, classes, arguments, loops and conditionals.
- **which-key.** Press `<Space>` and wait, and every keymap shows up.
- **Interactive tutor.** Run `:Tutor baremetal` to learn the setup in about 15 minutes.

## Requirements

| | |
|---|---|
| Neovim | **0.11 or newer** |
| Tools | `git`, `curl`, `unzip`, `tar`, a C compiler (`gcc`), `make` |
| Search | `ripgrep`, `fd` |
| Mason | `node` + `npm` and `python3` (several servers are installed through them) |
| Font | A [Nerd Font](https://www.nerdfonts.com) in your terminal (kitty and WezTerm ship the symbols) |
| Optional | `lazygit`, `bear` (compile_commands for Make projects), `gdb`, `cmake` |

The installer can set all of this up for you on Arch, Debian/Ubuntu, Fedora, openSUSE and macOS (Homebrew).

## Install

### One-liner

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash
```

The installer runs these steps:

1. Asks which languages you want, using a checkbox menu.
2. Installs the system packages those languages need, after asking you.
3. Backs up your existing Neovim config, data, state and cache to `*.bak-<date>`.
4. Clones the config to `~/.config/nvim`.
5. Installs all plugins and the language tools in headless mode.

### From a clone (recommended if you want to hack on it)

```sh
git clone https://github.com/krivanikm/baremetal.nvim.git ~/code/baremetal.nvim
~/code/baremetal.nvim/install.sh
```

When the script runs from a clone, it **symlinks** `~/.config/nvim` to that folder. You edit the clone and the changes apply straight away.

### Try it without touching your current config

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash -s -- --appname baremetal
NVIM_APPNAME=baremetal nvim
```

### Installer options

| Option | |
|---|---|
| `-l, --langs c,rust,python` | Choose languages without the menu (`all` for everything) |
| `-y, --yes` | Non-interactive: yes to every question, all languages unless `--langs` is given |
| `--no-deps` | Do not install system packages |
| `--no-sync` | Do not install plugins / tools now (it happens on the first start instead) |
| `--appname NAME` | Install side by side as `NVIM_APPNAME=NAME` |
| `--repo URL` | Install from your fork |
| `--branch NAME` | Use a different branch |

Example of a fully unattended install:

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash -s -- -y --langs c,asm,rust
```

### Manual install

```sh
git clone https://github.com/krivanikm/baremetal.nvim.git ~/.config/nvim
nvim
```

Without the installer, every language is enabled. See [choosing languages](#languages) to narrow it down.

## Languages

| Key | Language | LSP | Formatter | Linter | Debug |
|---|---|---|---|---|---|
| `c` | C / C++ / CUDA + CMake | clangd (+ clang-tidy) | clang-format | clang-tidy via clangd | codelldb / gdb |
| `asm` | GAS / NASM | asm-lsp | – | – | codelldb / gdb |
| `rust` | Rust | rust-analyzer (rustaceanvim) | rustfmt | clippy | codelldb |
| `systemverilog` | SystemVerilog / Verilog | verible | verible | verible + verilator | sim via iverilog (`<Space>rr`) |
| `vhdl` | VHDL | vhdl_ls | – | vhdl_ls | – |
| `python` | Python | basedpyright + ruff | ruff | ruff | – |
| `go` | Go | gopls | goimports / gofmt | staticcheck | – |
| `bash` | Bash / sh | bashls | shfmt | shellcheck | – |
| `web` | HTML / CSS / JS / TS | – | prettier | – | – |

Lua, JSON, YAML, TOML and Markdown are **always** enabled, because you need them to edit the config itself.

Your choice is stored in `lua/custom/languages.lua`. Git ignores that file, so your selection never conflicts with updates:

```lua
return {
  "c",
  "asm",
  "rust",
}
```

To change the languages later, edit the file, restart Neovim and run `:Lazy sync`. Mason installs the new tools in the background. If the file does not exist, all languages are enabled.

### Project tips

- **clangd** needs `compile_commands.json`. For CMake projects press `<Space>mg`. For Make projects run `bear -- make` once.
- **asm-lsp** only shows diagnostics when the project has an `.asm-lsp.toml` (architecture, assembler), so NASM and custom ISAs don't fill up with false errors.
- **vhdl_ls** analyses the whole project when it finds a `vhdl_ls.toml`.
- **verible** reads `.rules.verible_lint`. The verilator linter automatically adds `-y` for every folder that contains `.sv`/`.v` files.

## Tutor

```vim
:Tutor baremetal
```

You can also press `T` on the start screen. The tutor is interactive, like the built-in `:Tutor`: you practise on real lines and they turn from ✗ to ✓ once you get them right.

## Keymaps

The leader key is **`Space`**. Press it and wait, and which-key shows every key you can press next. The most important ones are below. The full list is in **[docs/keymaps.md](docs/keymaps.md)**.

| Key | Action |
|---|---|
| `<Space><Space>` | Smart find (files, recent, buffers) |
| `<Space>/` | Grep in project |
| `<Space>e` / `-` | File tree / edit folder as buffer (oil) |
| `s` | Jump anywhere with 2 characters (flash) |
| `gd` `gr` `K` | Definition / references / docs |
| `<Space>ca` / `<Space>cr` | Code action / rename |
| `<Space>rr` | Compile & run current file |
| `F5` `F9` `F10` `F11` | Debug: continue, breakpoint, step over, step into |
| `<Space>gg` | Lazygit |
| `<C-/>` | Terminal |

## Customize

Personal changes go into `lua/custom/`, which git ignores, so `git pull` never conflicts with them:

```
lua/custom/languages.lua    which languages are enabled
lua/custom/init.lua         your options, keymaps, autocommands
lua/custom/plugins/*.lua    extra plugins or overrides of existing ones
```

See **[docs/customization.md](docs/customization.md)** for examples (changing the theme, adding plugins, disabling plugins, adding an LSP server).

## Structure

```
init.lua                     leader key + loads the modules below
install.sh                   installer
tutor/baremetal.tutor        :Tutor baremetal
lua/config/options.lua       vim.opt, filetypes, Mason bin in PATH
lua/config/keymaps.lua       global keymaps
lua/config/autocmds.lua      yank highlight, last position, indent per language, ...
lua/config/lazy.lua          lazy.nvim bootstrap
lua/config/langs.lua         language selection (reads lua/custom/languages.lua)
lua/config/runner.lua        compile & run the current file
lua/plugins/colorscheme.lua  catppuccin (+ tokyonight, kanagawa)
lua/plugins/ui.lua           snacks (dashboard, picker, terminal, lazygit), lualine, bufferline, which-key
lua/plugins/editor.lua       neo-tree, oil, flash, surround, trouble, aerial, grug-far, sessions, harpoon
lua/plugins/treesitter.lua   treesitter (main branch), text objects, context
lua/plugins/lsp.lua          mason + lspconfig + per-server settings + LSP keymaps
lua/plugins/completion.lua   blink.cmp
lua/plugins/format-lint.lua  conform (format on save), nvim-lint (verilator)
lua/plugins/dap.lua          nvim-dap + dap-ui: codelldb, gdb, remote target
lua/plugins/git.lua          gitsigns, diffview
lua/plugins/lang.lua         rustaceanvim, crates, clangd_extensions, cmake-tools, overseer
```

## Updating

```sh
cd ~/.config/nvim && git pull
```

Then run `:Lazy restore` inside Neovim to get the exact plugin versions from `lazy-lock.json`. `:Lazy sync` updates everything to the latest versions instead.

## Uninstall

```sh
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

To get your old setup back, rename the `*.bak-<date>` folders the installer created back to their original names.

## Troubleshooting

| Problem | Fix |
|---|---|
| Squares or question marks instead of icons | Install a Nerd Font and select it in your terminal |
| `tree-sitter CLI missing` warning | `:MasonInstall tree-sitter-cli`, then restart |
| clangd can't find headers | Generate `compile_commands.json` (see [project tips](#project-tips)) |
| A language server is missing | `:Mason` shows what's installed. `:checkhealth vim.lsp` shows what's attached |
| Something else | `:checkhealth`, `:Lazy`, `:Mason`, `:messages` |

## License

[MIT](LICENSE)
