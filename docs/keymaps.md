# Keymaps

The leader key is **`Space`**, and the local leader is `\`.
Press `<Space>` and wait to see everything in which-key. `<Space>sk` searches all keymaps by name, and `<Space>?` shows the keymaps of the current buffer.

- [General editing](#general-editing)
- [Windows and buffers](#windows-and-buffers)
- [Find and search](#find-and-search)
- [File explorers and harpoon](#file-explorers-and-harpoon)
- [Motions](#motions)
- [Text objects and surround](#text-objects-and-surround)
- [LSP / code](#lsp--code)
- [Diagnostics](#diagnostics)
- [Completion](#completion)
- [Build and run](#build-and-run)
- [CMake](#cmake)
- [Rust](#rust)
- [C / C++](#c--c)
- [Debug](#debug)
- [Git](#git)
- [UI toggles](#ui-toggles)
- [Sessions and misc](#sessions-and-misc)

## General editing

| Key | Mode | Action |
|---|---|---|
| `<C-s>` | n i x s | Save |
| `<A-j>` / `<A-k>` | n i v | Move line / selection down / up |
| `<` / `>` | v | Indent and keep the selection |
| `<Space>p` | x | Paste over the selection without overwriting the register |
| `<Esc>` | n i s | Escape + clear search highlight |
| `n` / `N` | n | Next / previous match, centred |
| `<C-d>` / `<C-u>` | n | Half page down / up, centred |
| `j` / `k` | n x | Move by screen line on wrapped lines |
| `<Space>fn` | n | New file |
| `<Space>qq` | n | Quit everything |

## Windows and buffers

| Key | Action |
|---|---|
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Move to the window left / down / up / right |
| `<C-Up>` `<C-Down>` `<C-Left>` `<C-Right>` | Resize window |
| `<Space>\|` / `<Space>-` | Split right / below |
| `<Space>wd` / `<Space>wo` / `<Space>w=` | Close window / close others / equalize |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `[b` / `]b` | Previous / next buffer (bufferline order) |
| `[B` / `]B` | Move buffer left / right |
| `<Space>bb` or ``<Space>` `` | Alternate buffer |
| `<Space>bd` / `<Space>bo` | Close buffer / close all other buffers |
| `<Space>bp` / `<Space>bP` | Pin buffer / close unpinned |
| `<Space>bl` / `<Space>br` | Close buffers to the left / right |
| `<C-/>` | Toggle terminal (works in terminal mode too) |
| `<Esc><Esc>` | Leave terminal mode |

## Find and search

| Key | Action |
|---|---|
| `<Space><Space>` | Smart find |
| `<Space>ff` / `<Space>fg` | Files / git files |
| `<Space>fr` | Recent files |
| `<Space>fb` or `<Space>,` | Buffers |
| `<Space>fp` | Projects |
| `<Space>fc` | Config files |
| `<Space>/` or `<Space>sg` | Grep in the project |
| `<Space>sw` | Grep word under cursor / selection |
| `<Space>sb` | Lines in the current buffer |
| `<Space>sR` | Search & replace in the project (grug-far) |
| `<Space>sr` | Resume the last picker |
| `<Space>sh` / `<Space>sM` | Help pages / man pages |
| `<Space>sk` / `<Space>sC` / `<Space>sc` | Keymaps / commands / command history |
| `<Space>ss` / `<Space>sS` | LSP symbols in the buffer / workspace |
| `<Space>sd` / `<Space>sD` | Diagnostics in the project / buffer |
| `<Space>sm` / `<Space>sj` / `<Space>s"` | Marks / jumplist / registers |
| `<Space>sq` | Quickfix list |
| `<Space>su` | Undo history |
| `<Space>st` | TODO comments |

## File explorers and harpoon

| Key | Action |
|---|---|
| `<Space>e` / `<Space>E` | File tree (neo-tree) / floating tree |
| `<Space>ge` | Git status tree |
| `-` | Oil: edit the parent folder as a buffer, then `:w` applies the changes |
| `<Space>H` | Harpoon: add the file |
| `<Space>h` | Harpoon: menu |
| `<Space>1` … `<Space>5` | Harpoon: go to file 1 … 5 |

In neo-tree: `l` opens, `h` closes a folder, `Y` copies the path.

## Motions

| Key | Action |
|---|---|
| `s` | Flash: jump with 2 characters + label |
| `S` | Flash: select a treesitter node |
| `r` (operator pending) | Remote flash, e.g. `yr` |
| `R` (operator / visual) | Treesitter search |
| `]f` / `[f` (`]F` / `[F`) | Next / previous function start (end) |
| `]c` / `[c` (`]C` / `[C`) | Next / previous class or struct |
| `]a` / `[a` (`]A` / `[A`) | Next / previous argument |
| `]]` / `[[` | Next / previous reference of the word under the cursor |
| `]t` / `[t` | Next / previous TODO |
| `]q` / `[q` | Next / previous quickfix item |
| `[x` | Jump to the enclosing context (function, module) |

## Text objects and surround

These need a treesitter parser, so they work in code files.

| Object | Meaning |
|---|---|
| `af` / `if` | Function |
| `ac` / `ic` | Class / struct |
| `aa` / `ia` | Argument / parameter |
| `ai` / `ii` | Conditional |
| `al` / `il` | Loop |
| `ak` / `ik` | Comment |
| `ih` | Git hunk |

| Key | Action |
|---|---|
| `<Space>cx` / `<Space>cX` | Swap the argument with the next / previous one |
| `gsa{motion}{char}` | Add surrounding, e.g. `gsaiw"` |
| `gsd{char}` | Delete surrounding, e.g. `gsd(` |
| `gsr{old}{new}` | Replace surrounding, e.g. `gsr'"` |
| `gsf` / `gsF` / `gsh` | Find right / find left / highlight surrounding |

## LSP / code

| Key | Action |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `gr` | References |
| `gI` / `gy` | Implementation / type definition |
| `K` / `gK` | Hover docs / signature help |
| `<Space>ca` | Code action |
| `<Space>cr` | Rename symbol |
| `<Space>cR` | Rename file (updates imports via LSP) |
| `<Space>cf` | Format |
| `<Space>cF` | Fix all (source.fixAll) |
| `<Space>cc` | Run codelens |
| `<Space>ci` / `<Space>cI` | Incoming / outgoing calls |
| `<Space>co` / `<Space>sa` | Outline (aerial) / outline navigation |
| `<Space>cs` / `<Space>cl` | Symbols / LSP definitions & references (Trouble) |
| `<Space>cL` | LSP info (`:checkhealth vim.lsp`) |
| `<Space>cm` | Mason |

## Diagnostics

| Key | Action |
|---|---|
| `<Space>cd` | Diagnostic on the current line |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `]w` / `[w` | Next / previous warning |
| `<Space>xx` / `<Space>xX` | Diagnostics for the project / buffer (Trouble) |
| `<Space>xq` / `<Space>xl` | Quickfix / location list (Trouble) |
| `<Space>xt` | TODOs (Trouble) |
| `<Space>cv` | Run the linter now (SystemVerilog) |

## Completion

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous item, or jump between snippet fields |
| `<C-j>` / `<C-k>` | Next / previous item |
| `<CR>` | Accept |
| `<C-Space>` | Open the menu / docs |
| `<C-e>` | Close the menu |

## Build and run

| Key | Action |
|---|---|
| `<Space>rr` | Compile and run the current file in a terminal |
| `<Space>rb` | Build only, errors go to quickfix |
| `<Space>rd` | Build with debug info and start the debugger |
| `<Space>oo` | Run a task (make, cargo, npm, just, ...) |
| `<Space>ot` | Task list |
| `<Space>os` | Run a shell command as a task |
| `<Space>oa` | Task action |

What `<Space>rr` does per filetype:

| Filetype | Command |
|---|---|
| C | `gcc -std=c17 -g -O0 -Wall -Wextra -fsanitize=address,undefined` |
| C++ | `g++ -std=c++23 -g -O0 -Wall -Wextra -fsanitize=address,undefined` |
| GAS asm | `gcc -g -no-pie` (adds `-nostartfiles` if the file defines `_start`) |
| Rust | `cargo run` inside a Cargo project, otherwise `rustc -g --edition 2024` |
| SystemVerilog / Verilog | `iverilog -g2012` / `-g2005`, then `vvp` |
| Go / Python / Lua / Bash | `go run` / `python3` / `lua` / `bash` |

## CMake

| Key | Action |
|---|---|
| `<Space>mg` | Generate (configure), and symlink `compile_commands.json` to the root |
| `<Space>mb` | Build |
| `<Space>mr` | Run |
| `<Space>md` | Debug |
| `<Space>mt` / `<Space>ml` | Select build / launch target |
| `<Space>mv` | Build type (Debug / Release) |
| `<Space>mc` | Clean |
| `<Space>mT` | CTest |

## Rust

| Key | Action |
|---|---|
| `<Space>ca` | Code action (rust-analyzer grouped) |
| `K` | Hover with actions |
| `<Space>rR` / `<Space>rt` | Cargo runnables / testables |
| `<Space>dR` | Debuggables |
| `<Space>ce` / `<Space>cE` | Explain error / render full diagnostic |
| `<Space>cM` | Expand macro |
| `<Space>cp` | Parent module |
| `<Space>cJ` | Join lines |
| `<Space>cC` | Open Cargo.toml |

## C / C++

| Key | Action |
|---|---|
| `<Space>ch` | Switch header ↔ source |
| `<Space>cA` | Clangd AST |
| `<Space>cH` | Type hierarchy |
| `<Space>cy` | Symbol info |
| `<Space>cS` | Clangd memory usage |

## Debug

| Key | Action |
|---|---|
| `F5` or `<Space>dc` | Continue / start |
| `F9` or `<Space>db` | Toggle breakpoint |
| `F10` or `<Space>do` | Step over |
| `F11` or `<Space>di` | Step into |
| `F12` or `<Space>dO` | Step out |
| `<Space>dB` | Conditional breakpoint |
| `<Space>dL` | Logpoint |
| `<Space>dC` | Run to cursor |
| `<Space>dj` / `<Space>dk` | Stack frame down / up |
| `<Space>dl` | Run last |
| `<Space>dp` | Pause |
| `<Space>dt` | Terminate |
| `<Space>du` | Toggle debug UI |
| `<Space>de` | Evaluate expression (normal / visual) |
| `<Space>dw` | Add the word under the cursor to watches |
| `<Space>dr` | REPL |
| `<Space>dx` | Clear all breakpoints |
| `<Space>dd` | Disassembly (if the adapter supports it) |

Launch configurations for C / C++ / ASM:

- **codelldb: pick binary**: a picker over executables in the project
- **codelldb: binary + arguments**
- **gdb: launch** (needs gdb ≥ 14)
- **gdb: attach to process**
- **gdb: remote target**: `localhost:3333` by default, for OpenOCD or `qemu -s -S`

A `.vscode/launch.json` in the project is loaded automatically.

## Git

| Key | Action |
|---|---|
| `<Space>gg` | Lazygit |
| `]h` / `[h` | Next / previous hunk |
| `<Space>ghs` / `<Space>ghr` | Stage / reset hunk (normal or visual) |
| `<Space>ghS` / `<Space>ghR` | Stage / reset buffer |
| `<Space>ghp` | Preview hunk inline |
| `<Space>ghb` / `<Space>ghB` | Blame line / blame buffer |
| `<Space>ghd` | Diff against the index |
| `<Space>gd` / `<Space>gD` | Open / close diffview |
| `<Space>gH` | File history |
| `<Space>gl` / `<Space>gf` | Git log / log of the file |
| `<Space>gs` / `<Space>gb` | Git status / branches |
| `<Space>gB` | Open on the web (GitHub, GitLab, ...) |

## UI toggles

| Key | Toggle |
|---|---|
| `<Space>uf` | Format on save |
| `<Space>uh` | Inlay hints |
| `<Space>ud` | Diagnostics |
| `<Space>us` | Spell checking |
| `<Space>uw` | Line wrap |
| `<Space>ul` / `<Space>uL` | Line numbers / relative numbers |
| `<Space>uT` | Treesitter highlight |
| `<Space>ut` | Treesitter context (sticky header) |
| `<Space>ug` | Indent guides |
| `<Space>uD` | Dim inactive code |
| `<Space>ub` | Inline git blame |
| `<Space>uC` | Colour scheme picker |
| `<Space>un` | Hide notifications |
| `<Space>n` | Notification history |
| `<Space>z` | Zen mode |

## Sessions and misc

| Key | Action |
|---|---|
| `<Space>qs` | Restore the session for this folder |
| `<Space>qS` | Pick a session |
| `<Space>ql` | Restore the last session |
| `<Space>qd` | Don't save the current session |
| `<Space>U` | Undo tree |
| `<Space>l` | Lazy (plugin manager) |
| `<Space>cm` | Mason (tool manager) |
| `q` | Close help, quickfix, man and other helper windows |
