# dotfiles

Personal dotfiles — public half of a two-repo split:

| Repo | Contents |
|------|----------|
| `dotfiles/` (this repo) | bash, fish, tmux, vim, fzf, starship, bat, alacritty, ghostty, git, vscode, emacs/doom |
| `dotfiles-priv/` | Work-specific overrides, AMD/TI scripts, SSH config |

## Structure

```
bash/         bashrc, aliases, completions, readline (inputrc), key-bindings
fish/         config.fish, conf.d/, functions/
fzf/          fzf.bash (setup), fzf_functions.bash, key-bindings.bash, themes/
git/          config, ignore
tmux/         tmux.conf, tmuxw.bash (wrapper), tmux_completion.bash
vim/          vimrc, gvimrc, plugin packs
doom/         Doom Emacs config
alacritty/    Terminal config
ghostty/      Terminal config
starship/     Prompt config
bat/          Syntax highlighting config
vscode/       settings.json, keybindings.json
```

## How it loads

The main entry point is `bash/bashrc`, which sources modular files in order:

```
bashrc
├── bashrc_init         (dotfiles-priv: work env, module loads, FZF_HOME/FZF_GIT_HOME)
├── aliases.sh
├── completions.sh
├── key-bindings.sh
├── utils/alert.sh
├── utils/man.sh
├── utils/navigation.sh
├── utils/path.sh
├── fzf/fzf.bash        (sources fzf_functions.bash, key-bindings.bash)
└── bashrc_override     (dotfiles-priv: work-specific overrides, sources priv aliases)
```

## Key conventions

**fzf bindings** use a `C-f` prefix instead of fzf's defaults (`C-t`/`M-c`).
Git bindings use `C-g` via fzf-git.sh. See `fzf/key-bindings.bash` and `fish/conf.d/fzf.fish`.

**tmuxw.bash** is _sourced_ by `aliases.sh` to define the `tmuxw` shell function. For tmux
`run-shell` bindings, call it explicitly:
```
run-shell 'source .../tmuxw.bash && tmuxw <cmd>'
```
`run-shell` invokes bash as `sh` (POSIX mode); `set +o posix` at the top of `tmuxw.bash` re-enables hyphenated function names.

**Function naming** uses `-` as namespace separator (`tmux-exe`, `fzf-git-status`, etc.) matching
fzf-git.sh conventions. Bare `::` is invalid in POSIX/sh mode.

**FZF_HOME** points to the fzf install (`~/.local/install/fzf`); **FZF_GIT_HOME** independently
points to the fzf-git.sh install (`~/.local/install/fzf-git.sh`). Both silently no-op if unset.
