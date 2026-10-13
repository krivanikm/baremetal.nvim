---
title: Run & debug
---

# Run & debug

## Compile and run the current file

| Key | Action |
|---|---|
| `<Space>rr` | Compile and run the current file in a terminal at the bottom |
| `<Space>rb` | Build only, errors go to the quickfix list |
| `<Space>rd` | Build with debug info and start the debugger on the result |

The file is saved first. Binaries go to `~/.cache/nvim/run/`, named after the file plus a short hash of its full path,
so two `main.c` files in different folders never overwrite each other.

| Filetype | Command |
|---|---|
| C | `gcc -std=c17 -g -O0 -Wall -Wextra -fsanitize=address,undefined` |
| C++ | `g++ -std=c++23 -g -O0 -Wall -Wextra -fsanitize=address,undefined` |
| GAS asm | `gcc -g -no-pie` (adds `-nostartfiles` if the file defines `_start`) |
| Rust | `cargo run` inside a Cargo project, otherwise `rustc -g --edition 2024` |
| SystemVerilog / Verilog | `iverilog -g2012` over the project files, then `vvp` |
| Go / Python / Lua / Bash | `go run` / `python3` / `lua` / `bash` |

## SystemVerilog / Verilog

A testbench almost never lives alone, so `<Space>rr` compiles it together with the modules it uses:

1. If a parent folder contains `verible.filelist` or `files.f`, the files listed there are compiled
   (`iverilog -c <list>`, run from that folder). The same `verible.filelist` is also used by the verible language server.
2. Otherwise every `.sv` and `.v` file in the folder of the current file and its subfolders is compiled.

The top module is the first `module` in the current file (`iverilog -s <name>`), so open the testbench and press `<Space>rr`.

A `verible.filelist` is a plain list of paths, one per line:

```
rtl/alu/alu.sv
rtl/registers/register_file.sv
rtl/system_top.sv
tb/tb_system.sv
```

## Projects and tasks

For anything bigger than one file, use the project tools:

| Key | Action |
|---|---|
| `<Space>oo` | Run a task (make, cargo, npm, just, ...) through Overseer |
| `<Space>ot` | Task list |
| `<Space>os` | Run a shell command as a task |
| `<Space>mg` / `<Space>mb` / `<Space>mr` | CMake: generate / build / run |
| `<Space>md` | CMake: debug the selected target |
| `<Space>mT` | CTest |

## Debugging

nvim-dap with dap-ui. codelldb is used for C, C++, Rust and Assembly; the native GDB adapter needs gdb 14 or newer.

| Key | Action |
|---|---|
| `F5` or `<Space>dc` | Continue / start |
| `F9` or `<Space>db` | Toggle breakpoint |
| `F10` / `F11` / `F12` | Step over / into / out |
| `<Space>dB` | Conditional breakpoint |
| `<Space>dC` | Run to cursor |
| `<Space>de` | Evaluate expression |
| `<Space>du` | Toggle the debug UI |
| `<Space>dd` | Disassembly (if the adapter supports it) |

Launch configurations for C / C++ / ASM:

- **codelldb: pick binary** – a picker over executables in the project
- **codelldb: binary + arguments**
- **gdb: launch**
- **gdb: attach to process**
- **gdb: remote target** – `localhost:3333` by default, for OpenOCD or `qemu -s -S`

A `.vscode/launch.json` in the project is loaded automatically.

<p class="wide-shot"><img src="screenshots/debug.png" alt="Debugging C with codelldb"></p>
