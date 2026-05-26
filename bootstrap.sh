#!/usr/bin/env bash
#
# Bootstrap a fresh Arch Linux machine.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/sebastianst/dotfiles/master/bootstrap.sh | bash
#
# Steps: install packages -> generate SSH key -> clone repos -> rcup -> nvim plugins -> chsh

set -euo pipefail

DOTFILES_REPO="git@github.com:sebastianst/dotfiles.git"
KICKSTART_REPO="git@github.com:sebastianst/kickstart.nvim.git"
DOTFILES_DIR="${HOME}/.dotfiles"
NVIM_DIR="${HOME}/.config/nvim"
SSH_KEY="${HOME}/.ssh/id_ed25519"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m!!\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || err "Do not run as root; sudo is invoked per-step."
command -v pacman >/dev/null || err "This script currently supports Arch Linux only."

# Reattach stdin to the controlling terminal so prompts (sudo, read, chsh) work
# even when the script is piped from curl.
[[ -e /dev/tty ]] && exec </dev/tty

PACMAN_PKGS=(
  base-devel
  git
  zsh
  neovim
  tmux
  rcm
  ripgrep
  fzf
  bat
  fd
  github-cli
  jujutsu
  starship
  glow
  htop
  tree
  wget
  unzip
  less
)

log "Installing pacman packages..."
sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

if ! command -v yay >/dev/null; then
  log "Installing yay from AUR..."
  tmp=$(mktemp -d)
  git clone --depth 1 https://aur.archlinux.org/yay-bin.git "${tmp}/yay-bin"
  (cd "${tmp}/yay-bin" && makepkg -si --noconfirm)
  rm -rf "${tmp}"
else
  log "yay already installed."
fi

read -rp "Set up this as a development account (docker, mise, lazygit, ...)? [y/N] " dev_answer
if [[ ${dev_answer,,} =~ ^y(es)?$ ]]; then
  log "Installing development packages..."
  sudo pacman -S --needed --noconfirm lazygit just jq go-yq docker docker-compose
  yay -S --needed --noconfirm tuicr-bin mise-bin

  log "Enabling docker service and adding ${USER} to the docker group..."
  sudo systemctl enable --now docker
  sudo usermod -aG docker "$USER"
  log "(docker group membership takes effect after a fresh login.)"
fi

if [[ ! -f $SSH_KEY ]]; then
  log "Generating ed25519 SSH key..."
  mkdir -p "${HOME}/.ssh"
  chmod 700 "${HOME}/.ssh"
  ssh-keygen -t ed25519 -N "" -C "$(whoami)@$(hostname)" -f "$SSH_KEY"
  echo
  echo "================ SSH public key ================"
  cat "${SSH_KEY}.pub"
  echo "================================================"
  echo "Add this key to GitHub: https://github.com/settings/ssh/new"
  echo
  read -rp "Press <Enter> once you've added the key..." _
else
  log "SSH key already exists at ${SSH_KEY}."
fi

if ! grep -q '^github.com ssh-ed25519 ' "${HOME}/.ssh/known_hosts" 2>/dev/null; then
  # Hardcoded from https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
  log "Pinning github.com ed25519 host key in known_hosts..."
  mkdir -p "${HOME}/.ssh"
  echo 'github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl' \
    >> "${HOME}/.ssh/known_hosts"
fi

if [[ ! -d $DOTFILES_DIR ]]; then
  log "Cloning dotfiles to ${DOTFILES_DIR}..."
  git clone --recurse-submodules "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  log "Dotfiles already cloned at ${DOTFILES_DIR}."
fi

if [[ ! -d $NVIM_DIR ]]; then
  log "Cloning kickstart.nvim to ${NVIM_DIR}..."
  mkdir -p "${HOME}/.config"
  git clone "$KICKSTART_REPO" "$NVIM_DIR"
else
  log "kickstart.nvim already cloned at ${NVIM_DIR}."
fi

log "Running rcup..."
rcup -v

log "Installing neovim plugins..."
nvim --headless "+Lazy! sync" +qa </dev/null

zsh_bin=$(command -v zsh)
if [[ ${SHELL:-} != "$zsh_bin" ]]; then
  log "Changing default shell to zsh..."
  chsh -s "$zsh_bin"
fi

log "Bootstrap complete. Open a new shell to start using the environment."
