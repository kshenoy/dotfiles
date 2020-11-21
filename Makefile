# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
EMACS ?= emacs
TANGLE = $(EMACS) --batch --no-init-file --load emacs/tangle.el --funcall literate-dotfiles-tangle
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
MKLINK := ln -svTf


# I have two things per target that I want to do
# - the tangling which I can do as a pattern and,
# - other recipes that are specific to the target
all: bash emacs enhancd git tmux links


clean:
	rm bash/dircolors ripgreprc emacs/vanilla/config.el git/config tmux/tmux.conf


bash: bash/bashrc bash/dircolors ripgreprc bash_links
bash/bashrc bash/dircolors ripgreprc: bash/bashrc.org
	$(TANGLE) $<
bash_links: force
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/bash/bashrc  ~/.bashrc


emacs: emacs/vanilla/config.el emacs_links
emacs/vanilla/config.el: emacs/vanilla/config.org
	$(TANGLE) $<
emacs_links: force
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/emacs/emacs-profiles.el  ~/.emacs-profiles.el
	mkdir -p ~/.emacs-vanilla.d
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/emacs/vanilla/custom.el  ~/.emacs-vanilla.d/custom.el
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/emacs/vanilla/config.el  ~/.emacs-vanilla.d/init.el
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/emacs/bookmarks          ~/.emacs-vanilla.d/bookmarks
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/emacs/snippets           ~/.emacs-vanilla.d/snippets
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles-priv/emacs/work.el       ~/.emacs-vanilla.d/work.el


git: git/config git_links
git/config: git/git.org
	$(TANGLE) $<
git_links: force
	mkdir -p $(XDG_CONFIG_HOME)/git
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/git/config  $(XDG_CONFIG_HOME)/git/config
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/git/ignore  $(XDG_CONFIG_HOME)/git/ignore


tmux: tmux/tmux.conf tmux_links
tmux/tmux.conf: tmux/tmux.org
	$(TANGLE) $<
tmux_links: force
	mkdir -p $(XDG_CONFIG_HOME)/tmux
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/tmux/tmux.conf  $(XDG_CONFIG_HOME)/tmux/.tmux.conf

links: force
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles-priv/ssh/config       ~/.ssh/config
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/Xresources            ~/.Xresources
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/ctags                 ~/.ctags
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/fzf/fzf.bash          ~/.fzf.bash
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/scripts/emacs_daemon  ~/bin/emacs_daemon
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/scripts/rgf           ~/bin/rgf
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/scripts/vile          ~/bin/vile
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/scripts/vim_merge     ~/bin/vim_merge
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/unison/dotfiles.prf   ~/.unison/dotfiles.prf
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/vim                   ~/.config/nvim
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/vim                   ~/.vim
	@$(MKLINK)  $(XDG_CONFIG_HOME)/dotfiles/xinitrc               ~/.xinitrc


test:
	$(info XDG_CONFIG_HOME=$(XDG_CONFIG_HOME) XDG_DATA_HOME=$(XDG_DATA_HOME) EUID=$(EUID))
ifeq ($(EUID),0)
	@echo EUID=$(EUID): Running root-specific stuff
else
	@echo EUID=$(EUID): Running non-root-specific stuff
endif


.PHONY: force clean bash emacs git tmux
