# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
EMACS ?= emacs
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
MKLINK := ln -svTf

#docs := README.org bash/bashrc.org
#orgs := $(filter-out $(docs), $(shell find . -name '*.org'))
orgs := emacs/emacs.org git/git.org tmux/tmux.org

.PHONY: emacs git tmux


# I have two things per target that I want to do
# - the tangling which I can do as a pattern and,
# - other recipes that are specific to the target
all: $(orgs) emacs git tmux


emacs: emacs/emacs.org
	mkdir -p ~/.emacs.d
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/emacs/custom.el     ~/.emacs.d/custom.el
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/emacs/init.el       ~/.emacs.d/init.el
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/emacs/snippets      ~/.emacs.d/snippets
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles-priv/emacs/work.el  ~/.emacs.d/work.el


git: git/git.org
	mkdir -p $(XDG_CONFIG_HOME)/git
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/git/config $(XDG_CONFIG_HOME)/git/config
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/git/ignore $(XDG_CONFIG_HOME)/git/ignore


tmux: tmux/tmux.org
	@$(MKLINK) $(XDG_CONFIG_HOME)/dotfiles/tmux/tmux.conf ~/.tmux.conf


# https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
# Using a double-colon rule with no prerequisite will always execute its recipe. Since the recipe is always executed, I don't have to declare it as PHONY
$(orgs)::
	$(EMACS) --batch --no-init-file --load emacs/tangle.el --funcall literate-dotfiles-tangle $@
