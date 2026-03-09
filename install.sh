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

echo $DOTFILES_DIR

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

# Link existing repo as chezmoi source
CHEZMOI_SOURCE="${HOME}/.local/share/chezmoi"
if [ ! -e "$CHEZMOI_SOURCE" ]; then
  mkdir -p "$(dirname "$CHEZMOI_SOURCE")"
  ln -s "$DOTFILES_DIR" "$CHEZMOI_SOURCE"
fi

chezmoi init
chezmoi apply

echo "Done."

if [ "$(uname -s)" = "Darwin" ]; then
  if [ ! -e ~/.screen ]; then
    mkdir -p ~/.screen
  fi
  echo ""
  echo "macOS: Install Homebrew packages with:"
  echo "  brew bundle install --file=$DOTFILES_DIR/osx/Brewfile"
fi
