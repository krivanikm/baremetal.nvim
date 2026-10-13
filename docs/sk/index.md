---
title: Úvod
lang: sk
---

# baremetal.nvim

**baremetal.nvim** je kompletný Neovim config na low-level a hardvérový vývoj: C, C++, Assembly, Rust, SystemVerilog
a VHDL. „Baremetal“ hovorí o tom, čo v ňom píšeš – firmvér, procesory, kód bez operačného systému – nie o tom, že by
bol config minimalistický. Je postavený na `lazy.nvim` a natívnom LSP API z Neovimu 0.11+.

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash
```

Inštalátor sa opýta, ktoré jazyky chceš, a nastaví len tie. Viac v časti [Inštalácia](install.html).

## V skratke

| | |
|---|---|
| Neovim | 0.11 alebo novší |
| Jazyky | 9 skupín: C/C++, Assembly, Rust, SystemVerilog, VHDL, Python, Go, Bash, Web |
| Predvolené jazyky | C/C++, Assembly, SystemVerilog |
| Pluginy | ~50, verzie zamknuté v `lazy-lock.json` |
| Systémy | Arch, Debian/Ubuntu, Fedora, openSUSE, macOS (Homebrew) |
| CI | stylua, shellcheck a test štartu na Neovime 0.11.0 aj na najnovšej stabilnej verzii |
| Licencia | MIT |

## Čo to vie

- **LSP funguje hneď po prvom spustení.** Mason sám nainštaluje clangd, rust-analyzer, verible, vhdl_ls, asm-lsp a ďalšie.
- **`<Space>rr` skompiluje a spustí aktuálny súbor.** C/C++ s AddressSanitizerom a UBSan, Rust cez `cargo run`, Verilog testbench cez Icarus spolu so zvyškom projektu. Viac v časti [Spúšťanie a debug](running.html).
- **Debugger.** codelldb a natívny GDB, vrátane remote targetu pre embedded dosky (OpenOCD, QEMU).
- **C/C++ projekty.** Integrácia CMake (configure, build, run, debug, CTest) vygeneruje `compile_commands.json` pre clangd.
- **HDL.** Jazykový server a formatter verible, plus verilator linter, ktorý nájde moduly aj v iných priečinkoch.
- **Formátovanie pri uložení** cez conform.nvim, zapína a vypína sa skratkou `<Space>uf`.
- **Fuzzy hľadanie a grep** súborov, symbolov, skratiek a diagnostiky, všetko cez snacks.nvim.
- **Git.** Lazygit, stage hunkov, blame a diff view.
- **which-key.** Stlač `<Space>`, počkaj a uvidíš všetky skratky. Celý zoznam je v časti [Skratky](keymaps.html).
- **Interaktívny tutor.** `:Tutor baremetal` ťa celým setupom prevedie asi za 15 minút.

## Screenshoty

<div class="shots">
  <figure><a href="../screenshots/dashboard.png"><img src="../screenshots/dashboard.png" alt="Úvodná obrazovka" loading="lazy"></a><figcaption>úvodná obrazovka</figcaption></figure>
  <figure><a href="../screenshots/completion.png"><img src="../screenshots/completion.png" alt="Doplňovanie" loading="lazy"></a><figcaption>doplňovanie · signatúry · inlay hinty</figcaption></figure>
  <figure><a href="../screenshots/picker.png"><img src="../screenshots/picker.png" alt="Grep v projekte" loading="lazy"></a><figcaption>grep v projekte · &lt;Space&gt;/</figcaption></figure>
  <figure><a href="../screenshots/whichkey.png"><img src="../screenshots/whichkey.png" alt="which-key" loading="lazy"></a><figcaption>which-key · &lt;Space&gt;</figcaption></figure>
  <figure><a href="../screenshots/debug.png"><img src="../screenshots/debug.png" alt="Debugger" loading="lazy"></a><figcaption>debugovanie C · codelldb</figcaption></figure>
  <figure><a href="../screenshots/run.png"><img src="../screenshots/run.png" alt="Spustenie súboru" loading="lazy"></a><figcaption>skompiluj a spusti · &lt;Space&gt;rr</figcaption></figure>
  <figure><a href="../screenshots/hdl.png"><img src="../screenshots/hdl.png" alt="SystemVerilog" loading="lazy"></a><figcaption>SystemVerilog · verible + verilator</figcaption></figure>
  <figure><a href="../screenshots/git.png"><img src="../screenshots/git.png" alt="Git diff" loading="lazy"></a><figcaption>git diff view · &lt;Space&gt;gd</figcaption></figure>
</div>

## Vyvíjané v baremetal.nvim

[MNPK-01](https://krivanikm.github.io/mnpk01-soc/sk/) je vlastný 16-bitový mikropočítač v SystemVerilogu, simulovaný
vo Verilatore a určený pre FPGA Tang Nano 9K. Jeho RTL vzniká práve v tomto configu.

<div class="shots">
  <figure><a href="../screenshots/cpu.png"><img src="../screenshots/cpu.png" alt="Control unit MNPK-01 v Neovime" loading="lazy"></a><figcaption>control unit MNPK-01 v Neovime</figcaption></figure>
  <figure><a href="../screenshots/yosys-system-top.png"><img src="../screenshots/yosys-system-top.png" alt="Schéma system_top z Yosysu" loading="lazy"></a><figcaption>system_top vykreslený cez yosys show</figcaption></figure>
</div>

## Tutor

```vim
:Tutor baremetal
```

Alebo stlač `T` na úvodnej obrazovke. Tutor je interaktívny ako vstavaný `:Tutor`: cvičíš na skutočných riadkoch
a keď to spravíš správne, zmenia sa z ✗ na ✓.
