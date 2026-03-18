#!/usr/bin/env zsh

set -euo pipefail

echo "STARTING Orange's fantastic setup..."

if command -v apt >/dev/null; then
  PKG_MANAGER="apt"
elif command -v brew >/dev/null; then
  PKG_MANAGER="brew"
else
  echo "[-] No supported package manager found"
  exit 1
fi

echo "[+] Using package manager: $PKG_MANAGER"

update_system() {
  if [[ "$PKG_MANAGER" == "apt" ]]; then
    apt update
  elif [[ "$PKG_MANAGER" == "brew" ]]; then
    brew update
  fi
}

install_if_missing() {
  local cmd="$1"
  local pkg="$2"

  if command -v "$cmd" >/dev/null; then
    echo "[=] $cmd already installed"
  else
    echo "[+] Installing $pkg..."
    if [[ "$PKG_MANAGER" == "apt" ]]; then
      apt install -y "$pkg"
    elif [[ "$PKG_MANAGER" == "brew" ]]; then
      brew install "$pkg"
    fi
  fi
}

echo "[+] Installing core tools..."

update_system

install_if_missing git git
install_if_missing curl curl
install_if_missing nvim neovim
install_if_missing tmux tmux
install_if_missing zsh zsh

if command -v zsh >/dev/null; then
  echo "[+] Configuring zsh..."

  if [[ "$PKG_MANAGER" == "apt" ]]; then
    chsh -s "$(which zsh)" || true
  fi

  touch ~/.zshrc

  grep -q 'export EDITOR=nvim' ~/.zshrc || echo 'export EDITOR=nvim' >> ~/.zshrc
  grep -q 'alias ll=' ~/.zshrc || echo 'alias ll="ls -la"' >> ~/.zshrc
  grep -q 'alias gs=' ~/.zshrc || echo 'alias gs="git status"' >> ~/.zshrc
fi

echo "[+] Orange's Epic Setup completed."
