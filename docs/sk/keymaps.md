---
title: Skratky
lang: sk
---

# Skratky

Leader je **`Space`**, local leader je `\`.
Stlač `<Space>` a počkaj – which-key ukáže všetko. `<Space>sk` vyhľadá skratky podľa mena a `<Space>?` ukáže skratky aktuálneho bufferu.

- [Základná editácia](#zakladna-editacia)
- [Okná a buffre](#okna-a-buffre)
- [Hľadanie](#hladanie)
- [Prehliadače súborov a harpoon](#prehliadace-suborov-a-harpoon)
- [Pohyb](#pohyb)
- [Textové objekty a surround](#textove-objekty-a-surround)
- [LSP / kód](#lsp-kod)
- [Diagnostika](#diagnostika)
- [Doplňovanie](#doplnovanie)
- [Build a spustenie](#build-a-spustenie)
- [CMake](#cmake)
- [Rust](#rust)
- [C / C++](#c-c)
- [Debug](#debug)
- [Git](#git)
- [Prepínače UI](#prepinace-ui)
- [Sessions a ostatné](#sessions-a-ostatne)

## Základná editácia {#zakladna-editacia}

| Skratka | Mód | Akcia |
|---|---|---|
| `<C-s>` | n i x s | Uložiť |
| `<A-j>` / `<A-k>` | n i v | Posunúť riadok / výber dole / hore |
| `<` / `>` | v | Odsadiť a ponechať výber |
| `<Space>p` | x | Vložiť cez výber bez prepísania registra |
| `<Esc>` | n i s | Escape + zrušenie zvýraznenia hľadania |
| `n` / `N` | n | Ďalší / predchádzajúci výsledok, vycentrovaný |
| `<C-d>` / `<C-u>` | n | Pol strany dole / hore, vycentrované |
| `j` / `k` | n x | Pohyb po zobrazených riadkoch pri zalomení |
| `<Space>fn` | n | Nový súbor |
| `<Space>qq` | n | Ukončiť všetko |

## Okná a buffre {#okna-a-buffre}

| Skratka | Akcia |
|---|---|
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Prechod do okna vľavo / dole / hore / vpravo |
| `<C-Up>` `<C-Down>` `<C-Left>` `<C-Right>` | Zmena veľkosti okna |
| `<Space>\|` / `<Space>-` | Rozdeliť vpravo / dole |
| `<Space>wd` / `<Space>wo` / `<Space>w=` | Zavrieť okno / zavrieť ostatné / vyrovnať |
| `<S-h>` / `<S-l>` | Predchádzajúci / ďalší buffer |
| `[b` / `]b` | Predchádzajúci / ďalší buffer (poradie v bufferline) |
| `[B` / `]B` | Posunúť buffer doľava / doprava |
| `<Space>bb` alebo ``<Space>` `` | Naposledy použitý buffer |
| `<Space>bd` / `<Space>bo` | Zavrieť buffer / zavrieť všetky ostatné |
| `<Space>bp` / `<Space>bP` | Pripnúť buffer / zavrieť nepripnuté |
| `<Space>bl` / `<Space>br` | Zavrieť buffre vľavo / vpravo |
| `<C-/>` | Terminál (funguje aj v termináli) |
| `<Esc><Esc>` | Odchod z terminálového módu |

## Hľadanie {#hladanie}

| Skratka | Akcia |
|---|---|
| `<Space><Space>` | Inteligentné hľadanie |
| `<Space>ff` / `<Space>fg` | Súbory / súbory v gite |
| `<Space>fr` | Nedávne súbory |
| `<Space>fb` alebo `<Space>,` | Buffre |
| `<Space>fp` | Projekty |
| `<Space>fc` | Súbory configu |
| `<Space>/` alebo `<Space>sg` | Grep v projekte |
| `<Space>sw` | Grep slova pod kurzorom / výberu |
| `<Space>sb` | Riadky v aktuálnom buffri |
| `<Space>sR` | Hľadaj a nahraď v projekte (grug-far) |
| `<Space>sr` | Pokračovať v poslednom pickeri |
| `<Space>sh` / `<Space>sM` | Help / man stránky |
| `<Space>sk` / `<Space>sC` / `<Space>sc` | Skratky / príkazy / história príkazov |
| `<Space>ss` / `<Space>sS` | LSP symboly v buffri / v projekte |
| `<Space>sd` / `<Space>sD` | Diagnostika v projekte / v buffri |
| `<Space>sm` / `<Space>sj` / `<Space>s"` | Značky / jumplist / registre |
| `<Space>sq` | Quickfix zoznam |
| `<Space>su` | História undo |
| `<Space>st` | TODO komentáre |

## Prehliadače súborov a harpoon {#prehliadace-suborov-a-harpoon}

| Skratka | Akcia |
|---|---|
| `<Space>e` / `<Space>E` | Strom súborov (neo-tree) / plávajúci strom |
| `<Space>ge` | Strom so stavom gitu |
| `-` | Oil: nadradený priečinok ako buffer, `:w` uloží zmeny |
| `<Space>H` | Harpoon: pridať súbor |
| `<Space>h` | Harpoon: menu |
| `<Space>1` … `<Space>5` | Harpoon: prejsť na súbor 1 … 5 |

V neo-tree: `l` otvorí, `h` zatvorí priečinok, `Y` skopíruje cestu.

## Pohyb {#pohyb}

| Skratka | Akcia |
|---|---|
| `s` | Flash: skok pomocou 2 znakov + návestia |
| `S` | Flash: výber treesitter uzla |
| `r` (čakajúci operátor) | Vzdialený flash, napr. `yr` |
| `R` (operátor / visual) | Treesitter hľadanie |
| `]f` / `[f` (`]F` / `[F`) | Začiatok (koniec) ďalšej / predchádzajúcej funkcie |
| `]c` / `[c` (`]C` / `[C`) | Ďalšia / predchádzajúca trieda alebo struct |
| `]a` / `[a` (`]A` / `[A`) | Ďalší / predchádzajúci argument |
| `]]` / `[[` | Ďalší / predchádzajúci výskyt slova pod kurzorom |
| `]t` / `[t` | Ďalšie / predchádzajúce TODO |
| `]q` / `[q` | Ďalšia / predchádzajúca položka quickfixu |
| `[x` | Skok na nadradený kontext (funkcia, modul) |

## Textové objekty a surround {#textove-objekty-a-surround}

Potrebujú treesitter parser, takže fungujú v súboroch s kódom.

| Objekt | Význam |
|---|---|
| `af` / `if` | Funkcia |
| `ac` / `ic` | Trieda / struct |
| `aa` / `ia` | Argument / parameter |
| `ai` / `ii` | Podmienka |
| `al` / `il` | Cyklus |
| `ak` / `ik` | Komentár |
| `ih` | Git hunk |

| Skratka | Akcia |
|---|---|
| `<Space>cx` / `<Space>cX` | Vymeniť argument s nasledujúcim / predchádzajúcim |
| `gsa{pohyb}{znak}` | Pridať obal, napr. `gsaiw"` |
| `gsd{znak}` | Zmazať obal, napr. `gsd(` |
| `gsr{starý}{nový}` | Nahradiť obal, napr. `gsr'"` |
| `gsf` / `gsF` / `gsh` | Nájsť vpravo / nájsť vľavo / zvýrazniť obal |

## LSP / kód {#lsp-kod}

| Skratka | Akcia |
|---|---|
| `gd` / `gD` | Definícia / deklarácia |
| `gr` | Referencie |
| `gI` / `gy` | Implementácia / definícia typu |
| `K` / `gK` | Dokumentácia / signatúra |
| `<Space>ca` | Code action |
| `<Space>cr` | Premenovať symbol |
| `<Space>cR` | Premenovať súbor (cez LSP upraví importy) |
| `<Space>cf` | Formátovať |
| `<Space>cF` | Opraviť všetko (source.fixAll) |
| `<Space>cc` | Spustiť codelens |
| `<Space>ci` / `<Space>cI` | Prichádzajúce / odchádzajúce volania |
| `<Space>co` / `<Space>sa` | Osnova (aerial) / navigácia v osnove |
| `<Space>cs` / `<Space>cl` | Symboly / LSP definície a referencie (Trouble) |
| `<Space>cL` | Info o LSP (`:checkhealth vim.lsp`) |
| `<Space>cm` | Mason |

## Diagnostika {#diagnostika}

| Skratka | Akcia |
|---|---|
| `<Space>cd` | Diagnostika na aktuálnom riadku |
| `]d` / `[d` | Ďalšia / predchádzajúca diagnostika |
| `]e` / `[e` | Ďalšia / predchádzajúca chyba |
| `]w` / `[w` | Ďalšie / predchádzajúce varovanie |
| `<Space>xx` / `<Space>xX` | Diagnostika projektu / bufferu (Trouble) |
| `<Space>xq` / `<Space>xl` | Quickfix / location list (Trouble) |
| `<Space>xt` | TODO (Trouble) |
| `<Space>cv` | Spustiť linter hneď (SystemVerilog) |

## Doplňovanie {#doplnovanie}

| Skratka | Akcia |
|---|---|
| `<Tab>` / `<S-Tab>` | Ďalšia / predchádzajúca položka alebo skok medzi poľami snippetu |
| `<C-j>` / `<C-k>` | Ďalšia / predchádzajúca položka |
| `<CR>` | Potvrdiť |
| `<C-Space>` | Otvoriť menu / dokumentáciu |
| `<C-e>` | Zavrieť menu |

## Build a spustenie {#build-a-spustenie}

| Skratka | Akcia |
|---|---|
| `<Space>rr` | Skompilovať a spustiť aktuálny súbor v termináli |
| `<Space>rb` | Len skompilovať, chyby idú do quickfixu |
| `<Space>rd` | Skompilovať s debug info a spustiť debugger |
| `<Space>oo` | Spustiť task (make, cargo, npm, just, ...) |
| `<Space>ot` | Zoznam taskov |
| `<Space>os` | Spustiť shell príkaz ako task |
| `<Space>oa` | Akcia nad taskom |

Čo presne robí `<Space>rr` pre jednotlivé jazyky, je v časti [Spúšťanie a debug](running.html).

## CMake {#cmake}

| Skratka | Akcia |
|---|---|
| `<Space>mg` | Generate (configure) a symlink `compile_commands.json` do koreňa projektu |
| `<Space>mb` | Build |
| `<Space>mr` | Run |
| `<Space>md` | Debug |
| `<Space>mt` / `<Space>ml` | Výber build / launch targetu |
| `<Space>mv` | Typ buildu (Debug / Release) |
| `<Space>mc` | Clean |
| `<Space>mT` | CTest |

## Rust {#rust}

| Skratka | Akcia |
|---|---|
| `<Space>ca` | Code action (zoskupené rust-analyzerom) |
| `K` | Dokumentácia s akciami |
| `<Space>rR` / `<Space>rt` | Cargo runnables / testables |
| `<Space>dR` | Debuggables |
| `<Space>ce` / `<Space>cE` | Vysvetliť chybu / celá diagnostika |
| `<Space>cM` | Rozbaliť makro |
| `<Space>cp` | Nadradený modul |
| `<Space>cJ` | Spojiť riadky |
| `<Space>cC` | Otvoriť Cargo.toml |

## C / C++ {#c-c}

| Skratka | Akcia |
|---|---|
| `<Space>ch` | Prepnúť header ↔ source |
| `<Space>cA` | Clangd AST |
| `<Space>cH` | Hierarchia typov |
| `<Space>cy` | Info o symbole |
| `<Space>cS` | Pamäť clangd |

## Debug {#debug}

| Skratka | Akcia |
|---|---|
| `F5` alebo `<Space>dc` | Pokračovať / spustiť |
| `F9` alebo `<Space>db` | Breakpoint |
| `F10` alebo `<Space>do` | Step over |
| `F11` alebo `<Space>di` | Step into |
| `F12` alebo `<Space>dO` | Step out |
| `<Space>dB` | Podmienený breakpoint |
| `<Space>dL` | Logpoint |
| `<Space>dC` | Beh po kurzor |
| `<Space>dj` / `<Space>dk` | Stack frame dole / hore |
| `<Space>dl` | Spustiť posledné |
| `<Space>dp` | Pauza |
| `<Space>dt` | Ukončiť |
| `<Space>du` | Debug UI |
| `<Space>de` | Vyhodnotiť výraz (normal / visual) |
| `<Space>dw` | Pridať slovo pod kurzorom do watches |
| `<Space>dr` | REPL |
| `<Space>dx` | Zmazať všetky breakpointy |
| `<Space>dd` | Disassembly (ak to adaptér podporuje) |

## Git {#git}

| Skratka | Akcia |
|---|---|
| `<Space>gg` | Lazygit |
| `]h` / `[h` | Ďalší / predchádzajúci hunk |
| `<Space>ghs` / `<Space>ghr` | Stage / reset hunku (normal alebo visual) |
| `<Space>ghS` / `<Space>ghR` | Stage / reset bufferu |
| `<Space>ghp` | Náhľad hunku |
| `<Space>ghb` / `<Space>ghB` | Blame riadku / bufferu |
| `<Space>ghd` | Diff voči indexu |
| `<Space>gd` / `<Space>gD` | Otvoriť / zavrieť diffview |
| `<Space>gH` | História súboru |
| `<Space>gl` / `<Space>gf` | Git log / log súboru |
| `<Space>gs` / `<Space>gb` | Git status / vetvy |
| `<Space>gB` | Otvoriť na webe (GitHub, GitLab, ...) |

## Prepínače UI {#prepinace-ui}

| Skratka | Prepína |
|---|---|
| `<Space>uf` | Formátovanie pri uložení |
| `<Space>uh` | Inlay hinty |
| `<Space>ud` | Diagnostiku |
| `<Space>us` | Kontrolu pravopisu |
| `<Space>uw` | Zalamovanie riadkov |
| `<Space>ul` / `<Space>uL` | Čísla riadkov / relatívne čísla |
| `<Space>uT` | Treesitter zvýraznenie |
| `<Space>ut` | Treesitter kontext (lepkavá hlavička) |
| `<Space>ug` | Vodiace čiary odsadenia |
| `<Space>uD` | Stlmenie neaktívneho kódu |
| `<Space>ub` | Inline git blame |
| `<Space>uC` | Výber farebnej schémy |
| `<Space>un` | Skryť notifikácie |
| `<Space>n` | História notifikácií |
| `<Space>z` | Zen mód |

## Sessions a ostatné {#sessions-a-ostatne}

| Skratka | Akcia |
|---|---|
| `<Space>qs` | Obnoviť session pre tento priečinok |
| `<Space>qS` | Vybrať session |
| `<Space>ql` | Obnoviť poslednú session |
| `<Space>qd` | Neukladať aktuálnu session |
| `<Space>U` | Strom undo |
| `<Space>l` | Lazy (správca pluginov) |
| `<Space>cm` | Mason (správca nástrojov) |
| `q` | Zavrie help, quickfix, man a iné pomocné okná |
