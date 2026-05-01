---
# Why does fzf's bin dir need to be added to PATH?

`fzf/fzf.bash` explicitly adds `$FZF_HOME/bin` to PATH:
```bash
export PATH="$FZF_HOME/bin${PATH:+:${PATH}}"
```

## Questions to answer
- Is this because `$FZF_HOME` is outside the normal PATH (e.g. `~/.local/install/fzf`)?
- Or does fzf itself need its bin dir on PATH for internal use (e.g. `fzf-tmux`)?
- Could this be handled upstream (e.g. in `bashrc_init` via `module add` or `PATH` setup)?
- Is the same needed for fish, and is it handled there?
