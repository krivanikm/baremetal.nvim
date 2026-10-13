---
title: Languages
---

# Languages

| Key | Language | LSP | Formatter | Linter | Debug / run |
|---|---|---|---|---|---|
| `c` | C / C++ / CUDA + CMake | clangd (+ clang-tidy) | clang-format | clang-tidy via clangd | codelldb / gdb |
| `asm` | GAS / NASM | asm-lsp | – | – | codelldb / gdb |
| `rust` | Rust | rust-analyzer (rustaceanvim) | rustfmt | clippy | codelldb |
| `systemverilog` | SystemVerilog / Verilog | verible | verible | verible + verilator | iverilog + vvp (`<Space>rr`) |
| `vhdl` | VHDL | vhdl_ls | – | vhdl_ls | – |
| `python` | Python | basedpyright + ruff | ruff | ruff | – |
| `go` | Go | gopls | goimports / gofmt | staticcheck | – |
| `bash` | Bash / sh | bashls | shfmt | shellcheck | – |
| `web` | HTML / CSS / JS / TS | – | prettier | – | – |

Lua, JSON, YAML, TOML and Markdown are **always** enabled, because you need them to edit the config itself.

## Choosing languages

Your choice is stored in `lua/custom/languages.lua`. Git ignores that file, so your selection never conflicts with updates:

```lua
return {
  "c",
  "asm",
  "rust",
}
```

If the file does not exist, only `c`, `asm` and `systemverilog` are enabled.

The selection controls:

- which LSP servers, formatters and debuggers Mason installs and starts
- which treesitter parsers get compiled
- which language plugins load (rustaceanvim, crates.nvim, clangd_extensions, cmake-tools, nvim-dap, nvim-lint)
- which formatters run on save

After you change the file, restart Neovim and run `:Lazy sync`. Mason installs the new tools in the background.

## Project tips

- **clangd** needs `compile_commands.json`. For CMake projects press `<Space>mg`. For Make projects run `bear -- make` once.
- **asm-lsp** only shows diagnostics when the project has an `.asm-lsp.toml` (architecture, assembler), so NASM and custom ISAs don't fill up with false errors.
- **vhdl_ls** analyses the whole project when it finds a `vhdl_ls.toml`.
- **verible** reads `.rules.verible_lint`. The verilator linter automatically adds `-y` for every folder that contains `.sv`/`.v` files.
- **Verilog simulation** with `<Space>rr` uses `verible.filelist` (or `files.f`) when the project has one, see [Run & debug](running.html#systemverilog--verilog).
