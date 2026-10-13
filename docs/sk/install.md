---
title: Inštalácia
lang: sk
---

# Inštalácia

## Požiadavky

| | |
|---|---|
| Neovim | **0.11 alebo novší** |
| Nástroje | `git`, `curl`, `unzip`, `tar`, C kompilátor (`gcc`), `make` |
| Hľadanie | `ripgrep`, `fd` |
| Mason | `node` + `npm` a `python3` (cez ne sa inštaluje viacero serverov) |
| Font | [Nerd Font](https://www.nerdfonts.com) v termináli (kitty a WezTerm majú symboly zabudované) |
| Voliteľné | `lazygit`, `bear` (compile_commands pre Make projekty), `gdb`, `cmake` |

Inštalátor ti toto všetko vie nainštalovať na Archu, Debiane/Ubuntu, Fedore, openSUSE a macOS (Homebrew).
Samotný Neovim musí byť nainštalovaný vopred – inštalátor skontroluje jeho verziu skôr, než čokoľvek zmení.

## Jedným príkazom

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash
```

Inštalátor spraví tieto kroky:

1. Opýta sa, ktoré jazyky chceš (menu so zaškrtávaním, predvolene sú vybrané C/C++, Assembly a SystemVerilog).
2. Skontroluje, či je Neovim dosť nový.
3. Po tvojom potvrdení doinštaluje systémové balíky, ktoré vybrané jazyky potrebujú.
4. Zálohuje tvoj doterajší Neovim config, dáta, stav a cache do `*.bak-<dátum>`.
5. Naklonuje config do `~/.config/nvim`.
6. V headless režime nainštaluje pluginy a jazykové nástroje.

## Z naklonovaného repa

Odporúčané, ak ho chceš upravovať:

```sh
git clone https://github.com/krivanikm/baremetal.nvim.git ~/code/baremetal.nvim
~/code/baremetal.nvim/install.sh
```

Keď skript spustíš z klonu, `~/.config/nvim` bude **symlink** na ten priečinok. Upravuješ klon a zmeny sa prejavia hneď.

## Vyskúšanie bez zásahu do tvojho configu

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash -s -- --appname baremetal
NVIM_APPNAME=baremetal nvim
```

## Prepínače inštalátora

| Prepínač | |
|---|---|
| `-l, --langs c,rust,python` | Jazyky bez menu (`all` = všetky) |
| `-y, --yes` | Bez otázok; predvolené jazyky, ak nie je zadané `--langs` |
| `--no-deps` | Neinštaluje systémové balíky |
| `--no-sync` | Pluginy a nástroje sa nainštalujú až pri prvom spustení |
| `--appname NAME` | Inštalácia vedľa pôvodného configu ako `NVIM_APPNAME=NAME` |
| `--repo URL` | Inštalácia z tvojho forku |
| `--branch NAME` | Iná vetva |

Úplne automatická inštalácia:

```sh
curl -fsSL https://raw.githubusercontent.com/krivanikm/baremetal.nvim/main/install.sh | bash -s -- -y --langs c,asm,rust
```

## Ručná inštalácia

```sh
git clone https://github.com/krivanikm/baremetal.nvim.git ~/.config/nvim
nvim
```

Bez inštalátora sú zapnuté len predvolené jazyky. Ako ich zmeniť, nájdeš v časti [Jazyky](languages.html).

## Aktualizácia

```sh
cd ~/.config/nvim && git pull
```

Potom v Neovime spusti `:Lazy restore`, aby si dostal presne tie verzie pluginov, ktoré sú v `lazy-lock.json`.
`:Lazy sync` naopak aktualizuje všetko na najnovšie verzie.

## Odinštalovanie

```sh
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Pôvodný setup vrátiš tak, že priečinky `*.bak-<dátum>`, ktoré vytvoril inštalátor, premenuješ späť.

## Riešenie problémov

| Problém | Riešenie |
|---|---|
| Namiesto ikon sú štvorčeky alebo otázniky | Nainštaluj Nerd Font a nastav ho v termináli |
| Varovanie `tree-sitter CLI missing` | `:MasonInstall tree-sitter-cli` a reštart |
| clangd nenájde hlavičkové súbory | Vygeneruj `compile_commands.json` (pozri [tipy pre projekty](languages.html#tipy-pre-projekty)) |
| Chýba jazykový server | `:Mason` ukáže, čo je nainštalované, `:checkhealth vim.lsp` ukáže, čo je pripojené |
| Niečo iné | `:checkhealth`, `:Lazy`, `:Mason`, `:messages` |
