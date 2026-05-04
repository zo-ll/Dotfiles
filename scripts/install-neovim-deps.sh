#!/usr/bin/env bash
set -euo pipefail

# Install common deps for minimal Neovim setup (treesitter/telescope/lsp/mason)
# Supports: Ubuntu/Debian, Fedora, Arch, macOS(Homebrew)

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

sudo_if_needed() {
  if [[ "${EUID}" -ne 0 ]]; then
    sudo "$@"
  else
    "$@"
  fi
}

install_ubuntu() {
  sudo_if_needed apt update
  sudo_if_needed apt install -y \
    git curl unzip ripgrep fd-find nodejs npm \
    build-essential cmake pkg-config clangd

  # fd binary on Ubuntu is often fdfind
  if need_cmd fdfind && ! need_cmd fd; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    echo "linked fdfind -> ~/.local/bin/fd"
  fi
}

install_fedora() {
  sudo_if_needed dnf install -y \
    git curl unzip ripgrep fd-find nodejs npm \
    gcc gcc-c++ make cmake pkgconf-pkg-config clang-tools-extra
}

install_arch() {
  sudo_if_needed pacman -Sy --noconfirm \
    git curl unzip ripgrep fd nodejs npm \
    base-devel cmake pkgconf clang
}

install_macos() {
  if ! need_cmd brew; then
    echo "homebrew not found: install from https://brew.sh"
    exit 1
  fi
  brew update
  brew install git curl unzip ripgrep fd node npm cmake pkg-config llvm
  if [[ -d "/opt/homebrew/opt/llvm/bin" ]]; then
    echo "clangd path: /opt/homebrew/opt/llvm/bin/clangd"
    echo "if needed: export PATH=/opt/homebrew/opt/llvm/bin:$PATH"
  fi
}

main() {
  local os
  os="$(uname -s)"

  case "$os" in
    Darwin)
      install_macos
      ;;
    Linux)
      if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        case "${ID:-}" in
          ubuntu|debian|linuxmint|pop)
            install_ubuntu
            ;;
          fedora)
            install_fedora
            ;;
          arch|manjaro|endeavouros)
            install_arch
            ;;
          *)
            # Try ID_LIKE fallback
            case "${ID_LIKE:-}" in
              *debian*) install_ubuntu ;;
              *fedora*) install_fedora ;;
              *arch*) install_arch ;;
              *)
                echo "unsupported distro: ID=${ID:-unknown} ID_LIKE=${ID_LIKE:-unknown}"
                exit 1
                ;;
            esac
            ;;
        esac
      else
        echo "/etc/os-release missing; cannot detect distro"
        exit 1
      fi
      ;;
    *)
      echo "unsupported OS: $os"
      exit 1
      ;;
  esac

  echo "done. open nvim, then run: :Lazy sync and :Mason"
}

main "$@"
