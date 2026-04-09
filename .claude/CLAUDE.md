# Claude Instructions for dotfiles

## Gotchas

- `git/config` is symlinked as `~/.config/git/config.base` (not `config`)
- Git `[difftool]`/`[mergetool]` `cmd` values run under `sh` — bash aliases unavailable
- `bash/inputrc`: `set editing-mode emacs` must come before any keymap-specific bindings
- fzf bindings use `C-f` prefix (not fzf defaults `C-t`/`M-c`); git bindings via `C-g` (fzf-git.sh)

## Remembered Behaviors

Store new remembered behaviors here so they sync across devices via git.
