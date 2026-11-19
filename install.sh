#!/bin/bash

set -e

# colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
nc='\033[0m'

info() { echo -e "${green}[*]${nc} $1"; }
warn() { echo -e "${yellow}[!]${nc} $1"; }
error() { echo -e "${red}[x]${nc} $1"; exit 1; }

# check neovim version
check_nvim() {
  if ! command -v nvim &> /dev/null; then
    error "neovim not found. install neovim 0.11+ first."
  fi

  version=$(nvim --version | head -n1 | grep -oP '\d+\.\d+')
  major=$(echo "$version" | cut -d. -f1)
  minor=$(echo "$version" | cut -d. -f2)

  if [ "$major" -lt 1 ] && [ "$minor" -lt 11 ]; then
    error "neovim 0.11+ required, found $version"
  fi

  info "neovim $version found"
}

# backup existing config
backup_config() {
  if [ -d ~/.config/nvim ]; then
    if [ -d ~/.config/nvim/.git ]; then
      warn "existing nvim config is a git repo, skipping backup"
      return 1
    fi
    backup_dir=~/.config/nvim.backup.$(date +%s)
    warn "backing up existing config to $backup_dir"
    mv ~/.config/nvim "$backup_dir"
  fi
  return 0
}

# clone config
clone_config() {
  info "cloning config..."
  git clone git@github.com:vmfunc/nvim.git ~/.config/nvim
}

# install dependencies (arch)
install_deps_arch() {
  info "installing dependencies (arch)..."
  sudo pacman -S --needed --noconfirm ripgrep fd lazygit
}

# install dependencies (debian/ubuntu)
install_deps_debian() {
  info "installing dependencies (debian/ubuntu)..."
  sudo apt update
  sudo apt install -y ripgrep fd-find

  # lazygit from github
  if ! command -v lazygit &> /dev/null; then
    warn "lazygit not in apt, install manually from https://github.com/jesseduffield/lazygit"
  fi
}

# install dependencies (macos)
install_deps_macos() {
  info "installing dependencies (macos)..."
  brew install ripgrep fd lazygit
}

# detect os and install deps
install_deps() {
  if [ -f /etc/arch-release ]; then
    install_deps_arch
  elif [ -f /etc/debian_version ]; then
    install_deps_debian
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_deps_macos
  else
    warn "unknown os, install ripgrep, fd, lazygit manually"
  fi
}

main() {
  echo ""
  echo "  nvim config installer"
  echo "  ====================="
  echo ""

  check_nvim

  if backup_config; then
    clone_config
  else
    info "using existing config directory"
  fi

  read -p "install dependencies? (ripgrep, fd, lazygit) [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_deps
  fi

  echo ""
  info "done! run 'nvim' to start. plugins will install automatically."
  echo ""
}

main
