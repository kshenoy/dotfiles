# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
EMACS ?= emacs
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
MKLINK := ln -svTf

# docs := README.org
# orgs := $(filter-out $(docs), $(shell find . -name '*.org' | cut -c3-))
orgs := bash/bashrc.org emacs/emacs.org git/git.org tmux/tmux.org

.PHONY: bash emacs git tmux


test:
	@echo XDG_CONFIG_HOME=$(XDG_CONFIG_HOME) XDG_DATA_HOME=$(XDG_DATA_HOME)
ifeq ($(EUID),0)
	@echo EUID=$(EUID): Running root-specific stuff
else
	@echo EUID=$(EUID): Running non-root-specific stuff
endif


bash: bash/bashrc.org
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/bash/bashrc           ~/.bashrc


emacs: emacs/emacs.org
	mkdir -p ~/.emacs.d
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/emacs/custom.el       ~/.emacs.d/custom.el
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/emacs/init.el         ~/.emacs.d/init.el
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/emacs/snippets        ~/.emacs.d/snippets
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles-priv/emacs/work.el    ~/.emacs.d/work.el


git: git/git.org
	mkdir -p $(XDG_CONFIG_HOME)/git
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/git/config            $(XDG_CONFIG_HOME)/git/config
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/git/ignore            $(XDG_CONFIG_HOME)/git/ignore


tmux: tmux/tmux.org
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/tmux/tmux.conf      ~/.tmux.conf


# https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
# Using a double-colon rule with no prerequisite will always execute its recipe. Since the recipe is always executed, I don't have to declare it as PHONY
$(orgs)::
	@echo \\n[$(notdir $(basename $@))]
	$(EMACS) --batch --no-init-file --load emacs/tangle.el --funcall literate-dotfiles-tangle $@


# I have two things per target that I want to do
# - the tangling which I can do as a pattern and,
# - other recipes that are specific to the target
all: $(orgs) bash emacs git tmux
	@echo \\n[misc]
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles-priv/ssh/config       ~/.ssh/config
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/Xresources            ~/.Xresources
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/ctags                 ~/.ctags
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/fzf/fzf.bash          ~/.fzf.bash
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/scripts/emacs_daemon  ~/bin/emacs_daemon
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/scripts/rgf           ~/bin/rgf
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/scripts/vile          ~/bin/vile
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/scripts/vim_merge     ~/bin/vim_merge
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/unison/dotfiles.prf   ~/.unison/dotfiles.prf
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/vim                   ~/.config/nvim
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/vim                   ~/.vim
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/xinitrc               ~/.xinitrc
