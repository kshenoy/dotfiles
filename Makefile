# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
EMACS ?= @echo
MKLINK := command ln -svTf

docs := README.org
orgs := $(filter-out $(docs), $(wildcard *.org))

all: $(basename $(orgs))

# https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
# Using a double-colon rule with no prerequisite will always execute its recipe. Since the recipe is always executed, I don't have to declare it as PHONY
# Also, I have two things per target that I want to do
# - the tangling which I can do as a pattern and,
# - other recipes that are specific to the target
$(basename $(orgs))::
	$(EMACS) --batch --no-init-file --load emacs.d/tangle.el --funcall literate-dotfiles-tangle $@.org

emacs::
	command mkdir -p ~/.emacs.d
	@$(MKLINK) emacs.d/private_work.el ~/.emacs.d/private_work.el
	@$(MKLINK) emacs.d/snippets        ~/.emacs.d/snippets

git::
	command mkdir -p ~/.config/git
	@$(MKLINK) gitignore ~/.config/git/ignore
