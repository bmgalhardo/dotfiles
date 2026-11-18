#!/usr/bin/env bash
#
# Symlink dotfiles into place. Safe to re-run (idempotent).
# Existing real files are backed up to <file>.bak-YYYYMMDDHHMMSS before linking.
#
# Usage:
#   ./install.sh            # link everything
#   DRY_RUN=1 ./install.sh  # show what would happen, change nothing
#   GITCONFIG=1 ./install.sh  # also link ~/.gitconfig (skipped by default)

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"
GITCONFIG="${GITCONFIG:-0}"

log()  { printf '  %s\n' "$*"; }
run()  { if [ "$DRY_RUN" = "1" ]; then log "DRY: $*"; else eval "$*"; fi; }

# link <source-in-repo> <target-path>
link() {
  local src="$DOTFILES/$1" dest="$2"

  if [ ! -e "$src" ]; then
    log "skip (missing in repo): $1"
    return
  fi

  # Already the correct symlink? nothing to do.
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    log "ok:   $dest"
    return
  fi

  run "mkdir -p '$(dirname "$dest")'"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    run "mv '$dest' '${dest}.bak-${STAMP}'"
    log "backup: $dest -> ${dest}.bak-${STAMP}"
  fi

  run "ln -s '$src' '$dest'"
  log "link: $dest -> $src"
}

# add_session_hook <hooks-json-file>: add the ctx L0 SessionStart hook once,
# leaving every other hook in the file alone.
add_session_hook() {
  local f="$1" cmd='$HOME/.local/bin/ctx l0 --json'
  if [ -f "$f" ] && jq -e --arg c "$cmd" '[.hooks.SessionStart[]?.hooks[]?.command] | index($c)' "$f" >/dev/null; then
    log "ok:   $f (ctx hook)"
    return
  fi
  run "mkdir -p '$(dirname "$f")'; [ -f '$f' ] || echo '{}' > '$f'"
  run "jq --arg c '$cmd' '.hooks.SessionStart += [{hooks:[{type:\"command\",command:\$c}]}]' '$f' > '$f.tmp' && mv '$f.tmp' '$f'"
  log "hook: $f (ctx l0)"
}

echo "dotfiles: $DOTFILES"
echo "config:   $CONFIG_HOME"
[ "$DRY_RUN" = "1" ] && echo "(dry run)"
echo

echo "shell / git"
link "config/fish/config.fish"   "$CONFIG_HOME/fish/config.fish"
if [ "$GITCONFIG" = "1" ]; then
  link "git/.gitconfig" "$HOME/.gitconfig"
else
  log "skip: $HOME/.gitconfig (set GITCONFIG=1 to link it)"
fi

echo "kitty"
link "config/kitty" "$CONFIG_HOME/kitty"

echo "nvim"
link "config/nvim" "$CONFIG_HOME/nvim"

echo "starship"
link "config/starship.toml" "$CONFIG_HOME/starship.toml"

echo "yazi"
link "config/yazi" "$CONFIG_HOME/yazi"

echo "herdr"
link "config/herdr/config.toml" "$CONFIG_HOME/herdr/config.toml"

echo "agents (Claude Code, Codex)"
link "bin/ctx"              "$HOME/.local/bin/ctx"
link "config/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "config/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
add_session_hook "$HOME/.claude/settings.json"
add_session_hook "$HOME/.codex/hooks.json"
if [ "$DRY_RUN" != "1" ] && [ "$("$DOTFILES/bin/ctx" use)" = "off" ]; then
  log "ctx is off here (the default): the hook prints nothing. To use a context store:"
  log "  ctx use personal && ctx setup"
fi

echo
echo "Done. Open a new shell to pick up zsh changes."
echo "Prerequisites (install separately if missing):"
echo "  - fish        https://fishshell.com"
echo "  - starship    https://starship.rs"
echo "  - kitty, yazi, a Nerd Font (Symbols Nerd Font Mono)"
echo "  - curl, jq; for ctx: ~/.config/context/env (CONTEXT_API) and ~/.config/context/token"
