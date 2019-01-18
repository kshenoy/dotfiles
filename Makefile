# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html

docs := README.org
orgs := $(filter-out $(docs), $(wildcard *.org))

all: $(basename $(orgs))

%: %.org
	emacs --batch --no-init-file --load emacs.d/tangle.el --funcall literate-dotfiles-tangle $<
