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

### Packages

Installed automatically on the first `chezmoi apply` by the `run_once_install-packages-*` scripts:

| OS | Script | What it does |
|---|---|---|
| macOS | `run_once_install-packages-darwin.sh.tmpl` | Installs Homebrew, then `brew bundle install --file=osx/Brewfile` |
| Ubuntu/Debian | `run_once_install-packages-linux.sh.tmpl` | apt packages, plus mise/sheldon/zoxide/fzf from their own installers |

To rerun the macOS package step by hand:

```bash
brew bundle install --file=osx/Brewfile
```

### Manual steps after a fresh install

- `gh auth login` — the git credential helper is already configured in `.gitconfig`
- Import your GPG key if you sign commits
- iTerm2: point it at the managed prefs, then restart it. chezmoi writes the
  file, but iTerm2 only reads it once told to:

  ```bash
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  ```

  Afterwards iTerm2 offers to save changes back to `~/.iterm2/` when it quits,
  so `chezmoi add ~/.iterm2/com.googlecode.iterm2.plist` picks up later tweaks.
- tmux: `Ctrl+T` then `I` to install TPM plugins. TPM itself arrives via
  `.chezmoiexternal.toml` rather than a submodule, so its scripts keep the
  executable bit chezmoi would otherwise strip.
- Claude Code will ask once to confirm auto / bypass permission modes. Those
  acceptance flags are deliberately not in this repo — see "Secrets" below.

## Secrets

**This repository is public.** Nothing secret is managed by chezmoi, which also
means nothing secret transfers to a new machine automatically. Move these by
hand (1Password, or another out-of-band channel — never through this repo):

| What | Where it lives | Contains |
|---|---|---|
| `~/.zshrc.local` | sourced at the end of `.zshrc` | API keys and tokens for work services |
| `~/.gitconfig.local` | `[include]`-ed from `.gitconfig` | per-machine git identity overrides |
| `~/.ssh/` | — | SSH keys and host config |
| `~/.gnupg/` | — | GPG keys for commit signing |
| `~/.aws/credentials` | — | AWS credentials |

Both `.gitignore` and `.chezmoiignore` list these paths explicitly, so an
accidental `chezmoi add` or `git add` of any of them is a no-op. Keep it that
way: put new secrets in `~/.zshrc.local`, never in `dot_zshrc.tmpl`.

`~/.claude/settings.json` is a special case: Claude Code rewrites it whenever you
change a setting in the UI, so keys can appear there that you did not put in the
source. Review `chezmoi diff` before running `chezmoi add ~/.claude/settings.json`
— the permission-dialog acceptance flags (`skipDangerousModePermissionPrompt`,
`skipAutoPermissionPrompt`) and `permissions.defaultMode` are intentionally kept
out of this repo so a new machine asks before enabling those modes.

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
| Runtime | `dot_config/mise/config.toml` (Node, Ruby via mise) |
| Claude Code | `dot_claude/settings.json`, `dot_claude/statusline.py`, `dot_claude/skills/` |
| VS Code | `private_Library/` (macOS), ignored on other platforms |

Repo-only files (`README.md`, `CLAUDE.md`, `install.sh`, `osx/`, `fonts/`) are excluded via `.chezmoiignore` so they never land in `$HOME`.

### Templated files (`.tmpl`)

Files ending in `.tmpl` are rendered by chezmoi at apply time. OS-specific logic (macOS vs Linux) and user-specific values (email, GPG key) are handled here.

## tmux windows as workspaces

Windows are named by hand and keep their names (`allow-rename off`), so a tab is
a workspace — Daily, Research, Incident, one per project — each holding its own
long-running Claude Code session. Rename with `Ctrl+T` then `,`.

Claude Code's hooks publish that session's state onto its own window, and the
status bar renders it:

| Marker | Meaning |
|--------|---------|
| `●` | working right now |
| `✓` | finished since you last looked at that tab |
| `⚠` | waiting for your input |
| none | that tab has never run Claude |

Selecting a window clears `✓` and `⚠` but leaves `●` alone — visiting a tab
means you have seen the result, not that the work is done. The hooks live in
`dot_claude/settings.json` and call `dot_claude/executable_tmux-claude-state.sh`,
which targets `$TMUX_PANE` so several sessions never overwrite each other.

## Tools

- **Prompt**: [starship](https://starship.rs/) (stock preset; needs a Nerd Font)
- **Shell plugins**: [sheldon](https://github.com/rossmacarthur/sheldon) (TOML config)
- **Runtime manager**: [mise](https://mise.jdx.dev/) (replaces rbenv/pyenv/nodenv)
- **Directory jump**: [zoxide](https://github.com/ajeetdsouza/zoxide)
- **Fuzzy finder**: [fzf](https://github.com/junegunn/fzf)
- **Neovim plugins**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Tmux plugins**: [TPM](https://github.com/tmux-plugins/tpm)
- **Tmux theme**: [catppuccin/tmux](https://github.com/catppuccin/tmux), repainted
  with the Tokyo Night palette via `@thm_*` so tmux, starship and VS Code match
- **Terminal font**: UDEV Gothic NF — Nerd Font glyphs plus a strict 1:2
  half/full width ratio, so CJK stays aligned
