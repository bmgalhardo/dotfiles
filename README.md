# dotfiles

Personal config, portable across Linux and macOS. Managed with plain symlinks
via [`install.sh`](./install.sh) — no submodules, no framework.

## Install

```sh
git clone git@github.com:bmgalhardo/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh          # or: DRY_RUN=1 ./install.sh  to preview
GITCONFIG=1 ./install.sh  # also link ~/.gitconfig (off by default)
```

`install.sh` is idempotent. Any existing real file is moved to
`<file>.bak-<timestamp>` before the symlink is created.

## What's tracked

| Path in repo               | Links to                          | Tool |
|----------------------------|-----------------------------------|------|
| `config/fish/config.fish`  | `~/.config/fish/config.fish`      | fish shell |
| `git/.gitconfig`           | `~/.gitconfig` (only with `GITCONFIG=1`) | git |
| `config/kitty/`            | `~/.config/kitty/`                | kitty terminal |
| `config/starship.toml`     | `~/.config/starship.toml`         | starship prompt (Catppuccin Mocha) |
| `config/yazi/yazi.toml`    | `~/.config/yazi/yazi.toml`        | yazi file manager |
| `config/herdr/config.toml` | `~/.config/herdr/config.toml`     | herdr |
| `config/agents/AGENTS.md`  | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` | Claude Code, Codex (a stub) |
| `bin/ctx`                  | `~/.local/bin/ctx`                | agent context CLI |

Only declarative config is tracked. Runtime state (logs, sockets, sessions,
lock files, `kitty.conf.default`) is keft out on purpose.

## Agent context

The user-level notes for Claude Code and Codex are a stub. The real notes
live in a private context store: a Forgejo repo read and written over its API
with `ctx`, never cloned. `install.sh` adds a `SessionStart` hook to
`~/.claude/settings.json` and `~/.codex/hooks.json` that runs `ctx l0 --json`
and adds the store's `L0.md` to the session, from a cache in `~/.cache/context/`
when the store is unreachable.

ctx is **off** on a new machine: the hook prints nothing until a profile is
turned on.

```sh
ctx use personal && ctx setup   # turn on a profile, then give it the API URL, token, optional CA
ctx use work && ctx setup       # a second store, e.g. for work; `ctx use personal` switches back
ctx use off                     # back to no context store on this machine
CONTEXT_PROFILE=work claude     # one session against another profile
```

`ctx get -r OWNER/REPO PATH`, `ctx ls -r OWNER/REPO` and `ctx repos` read other
repos on the same Forgejo, and with `-r github:OWNER/REPO` public GitHub repos, so
an agent can read a project's `AGENTS.md` without cloning it. `ctx repos` lists the
GitHub user's public repos when the profile sets `CONTEXT_GITHUB` (`ctx setup` asks).

Each profile's config is `~/.config/context/<profile>/{env,token}` (mode 600,
never committed). The API URL is `https://<forgejo>/api/v1/repos/<owner>/<repo>`;
the token needs repo read/write. On a machine where ctx is off or not set up, the
hook adds nothing and the stub tells agents to work without it.

Codex runs a new hook only after you trust it; it asks the first time.

## Prerequisites

Install these separately, then run `install.sh`:

- [fish](https://fishshell.com)
- [starship](https://starship.rs)
- [kitty](https://sw.kovidgoyle.com/kitty/), [yazi](https://yazi-rs.github.io/)
- A Nerd Font — the kitty config expects **Symbols Nerd Font Mono**
- curl and jq, for `ctx`

## Notes

- **nvim**: referenced as `$EDITOR` in kitty and yazi, but there is no Neovim
  config on this machine yet. Add one under `config/nvim/` and a `link` line in
  `install.sh` when you start one.
- **macOS**: all paths use `~/.config`, which kitty, starship, yazi, and Zed
  all honor on macOS too. `XDG_CONFIG_HOME` is respected if set.
