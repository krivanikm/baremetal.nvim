---
title: Installation
---

# Installation

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
Neovim itself has to be installed first – the installer checks its version before it changes anything.

## One-liner

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash
```

The installer runs these steps:

1. Asks which languages you want, using a checkbox menu (C/C++, Assembly and SystemVerilog are preselected).
2. Checks that Neovim is new enough.
3. Installs the system packages those languages need, after asking you.
4. Backs up your existing Neovim config, data, state and cache to `*.bak-<date>`.
5. Clones the config to `~/.config/nvim`.
6. Installs all plugins and the language tools in headless mode.

## From a clone

Recommended if you want to hack on it:

```sh
git clone https://github.com/krivanikm/baremetal.nvim.git ~/code/baremetal.nvim
~/code/baremetal.nvim/install.sh
```

When the script runs from a clone, it **symlinks** `~/.config/nvim` to that folder. You edit the clone and the changes apply straight away.

## Try it without touching your current config

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash -s -- --appname baremetal
NVIM_APPNAME=baremetal nvim
```

## Installer options

| Option | |
|---|---|
| `-l, --langs c,rust,python` | Choose languages without the menu (`all` for everything) |
| `-y, --yes` | Non-interactive: yes to every question, default languages unless `--langs` is given |
| `--no-deps` | Do not install system packages |
| `--no-sync` | Do not install plugins / tools now (it happens on the first start instead) |
| `--appname NAME` | Install side by side as `NVIM_APPNAME=NAME` |
| `--repo URL` | Install from your fork |
| `--branch NAME` | Use a different branch |

A fully unattended install:

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash -s -- -y --langs c,asm,rust
```

## Manual install

```sh
git clone https://github.com/krivanikm/baremetal.nvim.git ~/.config/nvim
nvim
```

Without the installer, only the default languages are enabled. See [Languages](languages.html) to change them.

## Updating

```sh
cd ~/.config/nvim && git pull
```

Then run `:Lazy restore` inside Neovim to get the exact plugin versions from `lazy-lock.json`.
`:Lazy sync` updates everything to the latest versions instead.

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
| clangd can't find headers | Generate `compile_commands.json` (see [project tips](languages.html#project-tips)) |
| A language server is missing | `:Mason` shows what's installed, `:checkhealth vim.lsp` shows what's attached |
| Something else | `:checkhealth`, `:Lazy`, `:Mason`, `:messages` |
