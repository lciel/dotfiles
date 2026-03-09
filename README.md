# dotfiles

[chezmoi](https://www.chezmoi.io/)-managed dotfiles for macOS and Linux.

## Setup

### New machine

```bash
# Install chezmoi and apply dotfiles in one step:
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lciel/dotfiles
```

You'll be prompted for:
- **Full name** — used in `.gitconfig`
- **Git email** — used in `.gitconfig`
- **GPG signing key** — leave empty to disable commit signing

### Existing clone

```bash
./install.sh
# or manually:
chezmoi init --source ~/path/to/this/repo
chezmoi apply
```

### macOS packages

```bash
brew bundle install --file=osx/Brewfile
```

### Linux packages (Ubuntu/Debian)

Handled automatically by `run_once_install-packages-linux.sh.tmpl` on first `chezmoi apply`.

## Daily workflow

```bash
chezmoi edit ~/.zshrc      # Edit a managed file (opens source)
chezmoi apply              # Apply source changes to home
chezmoi add ~/.zshrc       # Pull home edits back into source
chezmoi diff               # Preview pending changes
chezmoi update             # git pull + apply
```

## What's managed

| Category | Key files |
|---|---|
| Shell | `dot_zshrc.tmpl`, `dot_config/sheldon/plugins.toml` |
| Git | `dot_gitconfig.tmpl`, `dot_gitignore_global` |
| Neovim | `dot_config/nvim/init.lua`, `lua/` |
| Tmux | `dot_tmux.conf.tmpl` (prefix: `Ctrl+T`) |
| Runtime | `dot_config/mise/config.toml` (Node, Python, Go via mise) |
| Claude Code | `dot_claude/settings.json`, `dot_claude/skills/` |

### Templated files (`.tmpl`)

Files ending in `.tmpl` are rendered by chezmoi at apply time. OS-specific logic (macOS vs Linux) and user-specific values (email, GPG key) are handled here.

## Tools

- **Shell plugins**: [sheldon](https://github.com/rossmacarthur/sheldon) (TOML config)
- **Runtime manager**: [mise](https://mise.jdx.dev/) (replaces rbenv/pyenv/nodenv)
- **Directory jump**: [zoxide](https://github.com/ajeetdsouza/zoxide)
- **Fuzzy finder**: [fzf](https://github.com/junegunn/fzf)
- **Neovim plugins**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Tmux plugins**: [TPM](https://github.com/tmux-plugins/tpm)
