---
title: Jazyky
lang: sk
---

# Jazyky

| Kľúč | Jazyk | LSP | Formátovač | Linter | Debug / spustenie |
|---|---|---|---|---|---|
| `c` | C / C++ / CUDA + CMake | clangd (+ clang-tidy) | clang-format | clang-tidy cez clangd | codelldb / gdb |
| `asm` | GAS / NASM | asm-lsp | – | – | codelldb / gdb |
| `rust` | Rust | rust-analyzer (rustaceanvim) | rustfmt | clippy | codelldb |
| `systemverilog` | SystemVerilog / Verilog | verible | verible | verible + verilator | iverilog + vvp (`<Space>rr`) |
| `vhdl` | VHDL | vhdl_ls | – | vhdl_ls | – |
| `python` | Python | basedpyright + ruff | ruff | ruff | – |
| `go` | Go | gopls | goimports / gofmt | staticcheck | – |
| `bash` | Bash / sh | bashls | shfmt | shellcheck | – |
| `web` | HTML / CSS / JS / TS | – | prettier | – | – |

Lua, JSON, YAML, TOML a Markdown sú zapnuté **vždy**, lebo ich potrebuješ na úpravu samotného configu.

## Výber jazykov

Výber sa ukladá do `lua/custom/languages.lua`. Git tento súbor ignoruje, takže tvoj výber sa nikdy nebije s aktualizáciami:

```lua
return {
  "c",
  "asm",
  "rust",
}
```

Ak súbor neexistuje, zapnuté sú len `c`, `asm` a `systemverilog`.

Výber určuje:

- ktoré LSP servery, formátovače a debuggery Mason nainštaluje a spustí
- ktoré treesitter parsery sa skompilujú
- ktoré jazykové pluginy sa načítajú (rustaceanvim, crates.nvim, clangd_extensions, cmake-tools, nvim-dap, nvim-lint)
- ktoré formátovače bežia pri uložení

Po zmene súboru reštartuj Neovim a spusti `:Lazy sync`. Mason nové nástroje doinštaluje na pozadí.

## Tipy pre projekty

- **clangd** potrebuje `compile_commands.json`. V CMake projekte stlač `<Space>mg`, v Make projekte raz spusti `bear -- make`.
- **asm-lsp** ukazuje diagnostiku, len ak má projekt `.asm-lsp.toml` (architektúra, assembler), aby sa NASM a vlastné inštrukčné sady nezaplnili falošnými chybami.
- **vhdl_ls** analyzuje celý projekt, keď nájde `vhdl_ls.toml`.
- **verible** číta `.rules.verible_lint`. Verilator linter sám pridá `-y` pre každý priečinok so súbormi `.sv`/`.v`.
- **Simulácia Verilogu** cez `<Space>rr` použije `verible.filelist` (alebo `files.f`), ak ho projekt má, pozri [Spúšťanie a debug](running.html#systemverilog--verilog).
