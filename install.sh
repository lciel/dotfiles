#!/bin/bash
# Bootstrap script for dotfiles setup using chezmoi.
# On a new machine, run:
#   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <github-username>/dotfiles
#
# Or if chezmoi is already installed:
#   chezmoi init --apply <github-username>/dotfiles
#
# On this development machine (repo already cloned):
#   chezmoi init --source ~/path/to/this/repo
#   chezmoi apply

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install chezmoi if not present
if ! command -v chezmoi &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

# Initialize submodules
git -C "$DOTFILES_DIR" submodule sync
git -C "$DOTFILES_DIR" submodule update --init

# Use existing repo as chezmoi source
chezmoi init --source "$DOTFILES_DIR"
chezmoi apply

echo "Done. Edit ~/.config/chezmoi/chezmoi.toml to add sourceDir if needed."

if [ "$(uname -s)" = "Darwin" ]; then
  if [ ! -e ~/.screen ]; then
    mkdir -p ~/.screen
  fi
  echo ""
  echo "macOS: Install Homebrew packages with:"
  echo "  brew bundle install --file=$DOTFILES_DIR/osx/Brewfile"
fi
