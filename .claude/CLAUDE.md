# Claude Instructions for dotfiles

## Remembered Behaviors

- Store new remembered behaviors here (not in local memory files) so they sync across devices via git.

## Gotchas

- `git/config` is symlinked as `~/.config/git/config.personal` (not `config`) and gets inlined into `~/.config/git/config.personal`
  This is done to allow using personal config as the base and extending/overriding on other machines eg. at work
- Git `[difftool]`/`[mergetool]` `cmd` values run under `sh` — bash aliases unavailable
- `bash/inputrc`: `set editing-mode emacs` must come before any keymap-specific bindings
- fzf bindings use `C-f` prefix (not fzf defaults `C-t`/`M-c`); git bindings via `C-g` (fzf-git.sh)
