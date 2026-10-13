---
title: Spúšťanie a debug
lang: sk
---

# Spúšťanie a debug

## Skompiluj a spusti aktuálny súbor

| Skratka | Akcia |
|---|---|
| `<Space>rr` | Skompiluje a spustí aktuálny súbor v termináli dole |
| `<Space>rb` | Len skompiluje, chyby idú do quickfix zoznamu |
| `<Space>rd` | Skompiluje s debug informáciami a spustí na výsledku debugger |

Súbor sa najprv uloží. Binárky idú do `~/.cache/nvim/run/` s menom súboru a krátkym hashom celej cesty,
takže dva `main.c` z rôznych priečinkov sa navzájom neprepíšu.

| Typ súboru | Príkaz |
|---|---|
| C | `gcc -std=c17 -g -O0 -Wall -Wextra -fsanitize=address,undefined` |
| C++ | `g++ -std=c++23 -g -O0 -Wall -Wextra -fsanitize=address,undefined` |
| GAS asm | `gcc -g -no-pie` (pridá `-nostartfiles`, ak súbor definuje `_start`) |
| Rust | `cargo run` v Cargo projekte, inak `rustc -g --edition 2024` |
| SystemVerilog / Verilog | `iverilog -g2012` nad súbormi projektu, potom `vvp` |
| Go / Python / Lua / Bash | `go run` / `python3` / `lua` / `bash` |

## SystemVerilog / Verilog

Testbench takmer nikdy nie je sám, preto ho `<Space>rr` skompiluje spolu s modulmi, ktoré používa:

1. Ak niektorý nadradený priečinok obsahuje `verible.filelist` alebo `files.f`, skompilujú sa súbory z tohto zoznamu
   (`iverilog -c <zoznam>`, spustené z toho priečinka). Ten istý `verible.filelist` používa aj jazykový server verible.
2. Inak sa skompilujú všetky súbory `.sv` a `.v` v priečinku aktuálneho súboru a v jeho podpriečinkoch.

Top modul je prvý `module` v aktuálnom súbore (`iverilog -s <meno>`), takže otvor testbench a stlač `<Space>rr`.

`verible.filelist` je obyčajný zoznam ciest, jedna na riadok:

```
rtl/alu/alu.sv
rtl/registers/register_file.sv
rtl/system_top.sv
tb/tb_system.sv
```

## Projekty a tasky

Na čokoľvek väčšie ako jeden súbor použi projektové nástroje:

| Skratka | Akcia |
|---|---|
| `<Space>oo` | Spustí task (make, cargo, npm, just, ...) cez Overseer |
| `<Space>ot` | Zoznam taskov |
| `<Space>os` | Spustí shell príkaz ako task |
| `<Space>mg` / `<Space>mb` / `<Space>mr` | CMake: generate / build / run |
| `<Space>md` | CMake: debug vybraného targetu |
| `<Space>mT` | CTest |

## Debugovanie

nvim-dap s dap-ui. Pre C, C++, Rust a Assembly sa používa codelldb; natívny GDB adaptér potrebuje gdb 14 alebo novší.

| Skratka | Akcia |
|---|---|
| `F5` alebo `<Space>dc` | Pokračovať / spustiť |
| `F9` alebo `<Space>db` | Breakpoint |
| `F10` / `F11` / `F12` | Step over / into / out |
| `<Space>dB` | Podmienený breakpoint |
| `<Space>dC` | Beh po kurzor |
| `<Space>de` | Vyhodnotiť výraz |
| `<Space>du` | Debug UI zapnúť / vypnúť |
| `<Space>dd` | Disassembly (ak to adaptér podporuje) |

Spúšťacie konfigurácie pre C / C++ / ASM:

- **codelldb: pick binary** – výber spustiteľného súboru z projektu
- **codelldb: binary + arguments**
- **gdb: launch**
- **gdb: attach to process**
- **gdb: remote target** – predvolene `localhost:3333`, pre OpenOCD alebo `qemu -s -S`

`.vscode/launch.json` v projekte sa načíta automaticky.

<p class="wide-shot"><img src="../screenshots/debug.png" alt="Debugovanie C cez codelldb"></p>
