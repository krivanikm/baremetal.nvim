#!/usr/bin/env bash
set -euo pipefail

REPO="${BAREMETAL_REPO:-https://github.com/krivanikm/baremetal.nvim.git}"
BRANCH="${BAREMETAL_BRANCH:-main}"
APPNAME="${NVIM_APPNAME:-nvim}"
ASSUME_YES=0
INSTALL_DEPS=1
SYNC=1
LANGS_ARG=""
MIN_NVIM="0.11.0"

ALL_LANGS=(c asm rust systemverilog vhdl python go bash web)
DEFAULT_LANGS=(c asm systemverilog)
declare -A LANG_DESC=(
  [c]="C / C++ / CUDA + CMake      clangd, clang-format, codelldb"
  [asm]="Assembly (GAS / NASM)       asm-lsp"
  [rust]="Rust                        rust-analyzer, clippy, crates.nvim"
  [systemverilog]="SystemVerilog / Verilog     verible, verilator, iverilog"
  [vhdl]="VHDL                        vhdl_ls"
  [python]="Python                      basedpyright, ruff"
  [go]="Go                          gopls, goimports"
  [bash]="Bash / sh                   bashls, shellcheck, shfmt"
  [web]="HTML / CSS / JS / TS        treesitter + prettier"
)
declare -A SELECTED=()

if [[ -t 1 ]]; then
  BOLD=$'\e[1m' DIM=$'\e[2m' RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m' RESET=$'\e[0m'
else
  BOLD="" DIM="" RED="" GREEN="" YELLOW="" BLUE="" RESET=""
fi

info() { printf '%s==>%s %s\n' "$BLUE$BOLD" "$RESET" "$*"; }
ok() { printf '%s ✓%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%s !%s %s\n' "$YELLOW" "$RESET" "$*" >&2; }
die() {
  printf '%s ✗%s %s\n' "$RED" "$RESET" "$*" >&2
  exit 1
}

usage() {
  cat <<EOF
${BOLD}baremetal.nvim installer${RESET}

Usage: install.sh [options]

Options:
  -l, --langs LIST     Languages to set up, comma separated, or "all"
                       (${ALL_LANGS[*]})
                       Without this flag you get an interactive menu.
  -y, --yes            Do not ask, answer yes to everything (default
                       languages: ${DEFAULT_LANGS[*]}, unless --langs is given)
      --no-deps        Skip installing system packages
      --no-sync        Skip headless plugin / tool installation
      --appname NAME   Install as NVIM_APPNAME=NAME (default: ${APPNAME})
      --repo URL       Clone from a different repo or fork
      --branch NAME    Branch to clone (default: ${BRANCH})
  -h, --help           Show this help

Environment: BAREMETAL_REPO, BAREMETAL_BRANCH, NVIM_APPNAME
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -l | --langs) LANGS_ARG="${2:?--langs needs a value}"; shift ;;
    --langs=*) LANGS_ARG="${1#*=}" ;;
    -y | --yes) ASSUME_YES=1 ;;
    --no-deps) INSTALL_DEPS=0 ;;
    --no-sync) SYNC=0 ;;
    --appname) APPNAME="${2:?--appname needs a value}"; shift ;;
    --repo) REPO="${2:?--repo needs a value}"; shift ;;
    --branch) BRANCH="${2:?--branch needs a value}"; shift ;;
    -h | --help) usage; exit 0 ;;
    *) usage; die "Unknown option: $1" ;;
  esac
  shift
done

have() { command -v "$1" >/dev/null 2>&1; }

has_tty() { [[ -r /dev/tty && -w /dev/tty ]] && { : </dev/tty; } 2>/dev/null; }

ask() {
  local answer=""
  read -r -p "$1" answer </dev/tty || true
  printf '%s' "$answer"
}

confirm() {
  [[ $ASSUME_YES -eq 1 ]] && return 0
  has_tty || return 0
  local answer
  answer="$(ask "$1 [Y/n] ")"
  [[ -z "$answer" || "$answer" =~ ^[Yy] ]]
}

lang_on() { [[ -n "${SELECTED[$1]:-}" ]]; }

any_lang() {
  local l
  for l in "$@"; do lang_on "$l" && return 0; done
  return 1
}

selected_list() {
  local l out=()
  for l in "${ALL_LANGS[@]}"; do lang_on "$l" && out+=("$l"); done
  printf '%s' "${out[*]}"
}

parse_langs() {
  local raw="${1// /}" l
  SELECTED=()
  if [[ "$raw" == "all" ]]; then
    for l in "${ALL_LANGS[@]}"; do SELECTED[$l]=1; done
    return 0
  fi
  IFS=',' read -r -a items <<<"$raw"
  for l in "${items[@]}"; do
    [[ -z "$l" ]] && continue
    [[ -n "${LANG_DESC[$l]:-}" ]] || die "Unknown language '$l'. Choose from: ${ALL_LANGS[*]}"
    SELECTED[$l]=1
  done
}

menu_langs() {
  local i l input n
  for l in "${DEFAULT_LANGS[@]}"; do SELECTED[$l]=1; done
  while true; do
    printf '\n%sWhich languages do you want?%s %s(Lua, JSON, YAML, TOML and Markdown are always included)%s\n\n' "$BOLD" "$RESET" "$DIM" "$RESET" >/dev/tty
    i=1
    for l in "${ALL_LANGS[@]}"; do
      if lang_on "$l"; then
        printf '  %s[x]%s %d) %s\n' "$GREEN" "$RESET" "$i" "${LANG_DESC[$l]}" >/dev/tty
      else
        printf '  [ ] %d) %s\n' "$i" "${LANG_DESC[$l]}" >/dev/tty
      fi
      i=$((i + 1))
    done
    printf '\n  %sNumbers%s toggle (e.g. "2 5 7"), %sa%s = all, %sn%s = none, %sEnter%s = continue\n' "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET" >/dev/tty
    input="$(ask '  > ')"
    case "$input" in
      "")
        break
        ;;
      a | A | all)
        for l in "${ALL_LANGS[@]}"; do SELECTED[$l]=1; done
        ;;
      n | N | none)
        SELECTED=()
        ;;
      *)
        for n in ${input//,/ }; do
          if [[ "$n" =~ ^[0-9]+$ ]] && ((n >= 1 && n <= ${#ALL_LANGS[@]})); then
            l="${ALL_LANGS[$((n - 1))]}"
            if lang_on "$l"; then unset "SELECTED[$l]"; else SELECTED[$l]=1; fi
          else
            warn "Ignoring '$n'"
          fi
        done
        ;;
    esac
  done
}

choose_langs() {
  if [[ -n "$LANGS_ARG" ]]; then
    parse_langs "$LANGS_ARG"
  elif [[ $ASSUME_YES -eq 1 ]] || ! has_tty; then
    parse_langs "$(IFS=,; printf '%s' "${DEFAULT_LANGS[*]}")"
  else
    menu_langs
  fi
  ok "Languages: $(selected_list)"
}

SUDO=""
if [[ $EUID -ne 0 ]] && have sudo; then
  SUDO="sudo"
fi

detect_pm() {
  if have pacman; then echo pacman
  elif have apt-get; then echo apt
  elif have dnf; then echo dnf
  elif have zypper; then echo zypper
  elif have brew; then echo brew
  else echo none
  fi
}

packages_for() {
  local pm="$1" pkgs=()
  case "$pm" in
    pacman) pkgs=(git curl unzip tar gzip gcc make ripgrep fd lazygit nodejs npm python) ;;
    apt) pkgs=(git curl unzip tar gzip build-essential ripgrep fd-find nodejs npm python3 python3-venv) ;;
    dnf) pkgs=(git curl unzip tar gzip gcc gcc-c++ make ripgrep fd-find nodejs npm python3) ;;
    zypper) pkgs=(git curl unzip tar gzip gcc gcc-c++ make ripgrep fd lazygit nodejs npm python3) ;;
    brew) pkgs=(git curl unzip ripgrep fd lazygit node python) ;;
  esac

  if any_lang c asm; then
    case "$pm" in
      brew) pkgs+=(cmake bear) ;;
      *) pkgs+=(cmake gdb bear) ;;
    esac
  fi
  if lang_on rust; then
    case "$pm" in
      pacman | brew | zypper) pkgs+=(rustup) ;;
    esac
  fi
  if lang_on go; then
    case "$pm" in
      pacman | zypper | brew) pkgs+=(go) ;;
      apt) pkgs+=(golang-go) ;;
      dnf) pkgs+=(golang) ;;
    esac
  fi
  if lang_on systemverilog; then
    case "$pm" in
      brew) pkgs+=(verilator icarus-verilog) ;;
      *) pkgs+=(verilator iverilog) ;;
    esac
  fi
  printf '%s\n' "${pkgs[@]}"
}

install_deps() {
  local pm
  pm="$(detect_pm)"
  if [[ "$pm" == "none" ]]; then
    warn "No supported package manager found, install dependencies manually (see README)."
    return 0
  fi

  local pkgs=()
  mapfile -t pkgs < <(packages_for "$pm")

  info "System packages for ${BOLD}${pm}${RESET}: ${pkgs[*]}"
  confirm "Install them now?" || { warn "Skipping system packages."; return 0; }

  case "$pm" in
    pacman) $SUDO pacman -S --needed --noconfirm "${pkgs[@]}" ;;
    apt) $SUDO apt-get update && $SUDO apt-get install -y "${pkgs[@]}" ;;
    dnf) $SUDO dnf install -y "${pkgs[@]}" ;;
    zypper) $SUDO zypper --non-interactive install "${pkgs[@]}" ;;
    brew) brew install "${pkgs[@]}" ;;
  esac || warn "Some packages failed to install, continuing anyway."
  ok "System packages done"
}

setup_rust() {
  lang_on rust || return 0
  if ! have rustup; then
    if have cargo; then
      warn "Rust found without rustup, make sure rust-analyzer and clippy are installed."
    else
      warn "rustup not found, install Rust from https://rustup.rs then run: rustup component add rust-analyzer clippy"
    fi
    return 0
  fi
  if ! rustup show active-toolchain >/dev/null 2>&1; then
    info "Installing the stable Rust toolchain"
    rustup default stable
  fi
  rustup component add rust-analyzer clippy rustfmt >/dev/null && ok "rust-analyzer, clippy and rustfmt ready"
}

version_ge() {
  [[ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" == "$2" ]]
}

check_nvim() {
  have nvim || die "Neovim is not installed. Install Neovim >= ${MIN_NVIM} first: https://github.com/neovim/neovim/blob/master/INSTALL.md"
  local v
  v="$(nvim --version | head -n1 | sed -E 's/^NVIM v([0-9]+\.[0-9]+\.[0-9]+).*/\1/')"
  version_ge "$v" "$MIN_NVIM" || die "Neovim ${v} is too old, need >= ${MIN_NVIM}."
  ok "Neovim ${v}"
}

xdg_dir() {
  local base="$1" fallback="$2"
  echo "${!base:-$HOME/$fallback}/$APPNAME"
}

CONFIG_DIR="$(xdg_dir XDG_CONFIG_HOME .config)"
DATA_DIR="$(xdg_dir XDG_DATA_HOME .local/share)"
STATE_DIR="$(xdg_dir XDG_STATE_HOME .local/state)"
CACHE_DIR="$(xdg_dir XDG_CACHE_HOME .cache)"

SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
fi

is_local_checkout() {
  [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/init.lua" && -d "$SCRIPT_DIR/lua/config" ]]
}

backup_existing() {
  local stamp dir found=0
  stamp="$(date +%Y%m%d-%H%M%S)"
  for dir in "$CONFIG_DIR" "$DATA_DIR"; do
    [[ -e "$dir" || -L "$dir" ]] && found=1
  done
  [[ $found -eq 0 ]] && return 0

  warn "An existing Neovim setup was found for '${APPNAME}'."
  confirm "Move it to *.bak-${stamp} and continue?" || die "Aborted, nothing was changed."
  for dir in "$CONFIG_DIR" "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
    if [[ -e "$dir" || -L "$dir" ]]; then
      mv "$dir" "${dir}.bak-${stamp}"
      ok "Backed up ${dir} → ${dir}.bak-${stamp}"
    fi
  done
}

install_config() {
  mkdir -p "$(dirname "$CONFIG_DIR")"
  if is_local_checkout; then
    if [[ "$SCRIPT_DIR" == "$(cd "$CONFIG_DIR" 2>/dev/null && pwd -P)" ]]; then
      ok "Config already lives in ${CONFIG_DIR}"
      return 0
    fi
    backup_existing
    ln -s "$SCRIPT_DIR" "$CONFIG_DIR"
    ok "Linked ${CONFIG_DIR} → ${SCRIPT_DIR}"
  else
    have git || die "git is required."
    backup_existing
    info "Cloning ${REPO} (${BRANCH})"
    git clone --depth 1 --branch "$BRANCH" "$REPO" "$CONFIG_DIR"
    ok "Cloned into ${CONFIG_DIR}"
  fi
}

write_langs() {
  local file="$CONFIG_DIR/lua/custom/languages.lua" l
  mkdir -p "$(dirname "$file")"
  {
    printf 'return {\n'
    for l in "${ALL_LANGS[@]}"; do
      lang_on "$l" && printf '  "%s",\n' "$l"
    done
    printf '}\n'
  } >"$file"
  ok "Wrote ${file}"
}

sync_plugins() {
  info "Installing plugins (lazy.nvim)…"
  NVIM_APPNAME="$APPNAME" nvim --headless "+Lazy! restore" +qa || warn "Plugin sync reported errors, run :Lazy inside Neovim."
  ok "Plugins installed"

  info "Installing language servers, formatters and debuggers (Mason)… this can take a few minutes"
  NVIM_APPNAME="$APPNAME" nvim --headless "+MasonToolsInstallSync" +qa || warn "Some Mason tools failed, run :Mason inside Neovim."
  ok "Mason tools installed"
}

main() {
  printf '\n%sbaremetal.nvim%s — Neovim IDE for C / C++ / ASM / Rust / SystemVerilog / VHDL\n' "$BOLD" "$RESET"

  choose_langs
  check_nvim
  [[ $INSTALL_DEPS -eq 1 ]] && install_deps
  setup_rust
  install_config
  write_langs
  [[ $SYNC -eq 1 ]] && sync_plugins

  local cmd="nvim"
  [[ "$APPNAME" != "nvim" ]] && cmd="NVIM_APPNAME=${APPNAME} nvim"
  printf '\n%sDone!%s Start it with: %s%s%s\n' "$GREEN$BOLD" "$RESET" "$BOLD" "$cmd" "$RESET"
  printf 'Treesitter parsers compile on the first start.\n'
  printf 'New here? Run %s:Tutor baremetal%s (or press %sT%s on the start screen).\n' "$BOLD" "$RESET" "$BOLD" "$RESET"
  printf 'Icons need a Nerd Font: https://www.nerdfonts.com\n\n'
}

main
