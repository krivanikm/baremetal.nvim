---
title: Home
---

# baremetal.nvim

**baremetal.nvim** is a batteries-included Neovim config for low-level and hardware work: C, C++, Assembly, Rust,
SystemVerilog and VHDL. "Baremetal" is about what you write with it – firmware, CPUs, code without an OS – not about
the config being minimal. It is built on `lazy.nvim` and the native LSP API of Neovim 0.11+.

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash
```

The installer asks which languages you want and sets up only those. See [Installation](install.html).

## At a glance

| | |
|---|---|
| Neovim | 0.11 or newer |
| Languages | 9 groups: C/C++, Assembly, Rust, SystemVerilog, VHDL, Python, Go, Bash, Web |
| Default languages | C/C++, Assembly, SystemVerilog |
| Plugins | ~50, pinned in `lazy-lock.json` |
| Platforms | Arch, Debian/Ubuntu, Fedora, openSUSE, macOS (Homebrew) |
| CI | stylua, shellcheck and a startup test on Neovim 0.11.0 and the latest stable release |
| License | MIT |

## Features

- **Language servers that work on first start.** Mason installs clangd, rust-analyzer, verible, vhdl_ls, asm-lsp and the rest automatically.
- **Compile and run the current file with `<Space>rr`.** C/C++ with AddressSanitizer and UBSan, Rust through `cargo run`, Verilog testbenches through Icarus together with the rest of the project. See [Run & debug](running.html).
- **Debugger.** codelldb and native GDB, including a remote GDB target for embedded boards (OpenOCD, QEMU).
- **C/C++ projects.** CMake integration (configure, build, run, debug, CTest) generates `compile_commands.json` for clangd.
- **HDL support.** The verible language server and formatter, plus a verilator linter that resolves modules across folders.
- **Formatting on save** with conform.nvim, toggled with `<Space>uf`.
- **Fuzzy finding and grep** for files, symbols, keymaps and diagnostics, all through snacks.nvim.
- **Git tools.** Lazygit, hunk staging, blame and a diff view.
- **which-key.** Press `<Space>` and wait, and every keymap shows up. The full list is in [Keymaps](keymaps.html).
- **Interactive tutor.** `:Tutor baremetal` teaches the setup in about 15 minutes.

## Screenshots

<div class="shots">
  <figure><a href="screenshots/dashboard.png"><img src="screenshots/dashboard.png" alt="Start screen" loading="lazy"></a><figcaption>start screen</figcaption></figure>
  <figure><a href="screenshots/completion.png"><img src="screenshots/completion.png" alt="Completion" loading="lazy"></a><figcaption>completion · signatures · inlay hints</figcaption></figure>
  <figure><a href="screenshots/picker.png"><img src="screenshots/picker.png" alt="Project grep" loading="lazy"></a><figcaption>project grep · &lt;Space&gt;/</figcaption></figure>
  <figure><a href="screenshots/whichkey.png"><img src="screenshots/whichkey.png" alt="which-key" loading="lazy"></a><figcaption>which-key · &lt;Space&gt;</figcaption></figure>
  <figure><a href="screenshots/debug.png"><img src="screenshots/debug.png" alt="Debugger" loading="lazy"></a><figcaption>debugging C · codelldb</figcaption></figure>
  <figure><a href="screenshots/run.png"><img src="screenshots/run.png" alt="Run file" loading="lazy"></a><figcaption>compile &amp; run · &lt;Space&gt;rr</figcaption></figure>
  <figure><a href="screenshots/hdl.png"><img src="screenshots/hdl.png" alt="SystemVerilog" loading="lazy"></a><figcaption>SystemVerilog · verible + verilator</figcaption></figure>
  <figure><a href="screenshots/git.png"><img src="screenshots/git.png" alt="Git diff" loading="lazy"></a><figcaption>git diff view · &lt;Space&gt;gd</figcaption></figure>
</div>

## Built with baremetal.nvim

[MNPK-01](https://krivanikm.github.io/mnpk01-soc/) is a custom 16-bit microcomputer written in SystemVerilog, simulated with
Verilator and targeting the Tang Nano 9K FPGA. Its RTL is written in this setup.

<div class="shots">
  <figure><a href="screenshots/cpu.png"><img src="screenshots/cpu.png" alt="MNPK-01 control unit in Neovim" loading="lazy"></a><figcaption>MNPK-01 control unit in Neovim</figcaption></figure>
  <figure><a href="screenshots/yosys-system-top.png"><img src="screenshots/yosys-system-top.png" alt="Yosys schematic of system_top" loading="lazy"></a><figcaption>system_top rendered by yosys show</figcaption></figure>
</div>

## Tutor

```vim
:Tutor baremetal
```

You can also press `T` on the start screen. The tutor is interactive, like the built-in `:Tutor`: you practise on real
lines and they turn from ✗ to ✓ once you get them right.
