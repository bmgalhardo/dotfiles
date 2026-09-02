# dotfiles

Personal config, portable across Linux and macOS. Managed with plain symlinks
via [`install.sh`](./install.sh) — no submodules, no framework.

## Install

```sh
git clone git@github.com:bmgalhardo/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh          # or: DRY_RUN=1 ./install.sh  to preview
```

`install.sh` is idempotent. Any existing real file is moved to
`<file>.bak-<timestamp>` before the symlink is created.

## What's tracked

| Path in repo               | Links to                          | Tool |
|----------------------------|-----------------------------------|------|
| `zsh/.zshrc`               | `~/.zshrc`                         | zsh + oh-my-zsh |
| `git/.gitconfig`           | `~/.gitconfig`                     | git |
| `config/kitty/`            | `~/.config/kitty/`                 | kitty terminal |
| `config/starship.toml`     | `~/.config/starship.toml`          | starship prompt (Catppuccin Mocha) |
| `config/yazi/yazi.toml`    | `~/.config/yazi/yazi.toml`         | yazi file manager |
| `config/zed/settings.json` | `~/.config/zed/settings.json`      | Zed editor |
| `config/herdr/config.toml` | `~/.config/herdr/config.toml`      | herdr |

Only declarative config is tracked. Runtime state (logs, sockets, sessions,
lock files, `kitty.conf.default`, oh-my-zsh itself) is left out on purpose.

## Prerequisites

Install these separately, then run `install.sh`:

- [oh-my-zsh](https://ohmyz.sh)
- [starship](https://starship.rs)
- [kitty](https://sw.kovidgoyle.com/kitty/), [yazi](https://yazi-rs.github.io/), [Zed](https://zed.dev)
- A Nerd Font — the kitty config expects **Symbols Nerd Font Mono**

## Notes

- **nvim**: referenced as `$EDITOR` in kitty and yazi, but there is no Neovim
  config on this machine yet. Add one under `config/nvim/` and a `link` line in
  `install.sh` when you start one.
- **macOS**: all paths use `~/.config`, which kitty, starship, yazi, and Zed
  all honor on macOS too. `XDG_CONFIG_HOME` is respected if set.
