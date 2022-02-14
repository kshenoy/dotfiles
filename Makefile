# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_DATA_HOME ?= ${HOME}/.local/share
MKLINK := ln -svf
CWD := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))


all: dotfiles-priv base16-fzf base16-shell bash emacs fish git tmux vim links
# Rules not included in all: xmonad


#== fish ===============================================================================================================
fish: ${XDG_CONFIG_HOME}/fish/config.fish ${XDG_CONFIG_HOME}/fish/functions
${XDG_CONFIG_HOME}/fish/config.fish:
	@mkdir -p $(dir $@)
	@${MKLINK} ${CWD}/fish/config.fish $@
${XDG_CONFIG_HOME}/fish/functions:
	@mkdir -p $(dir $@)
	@${MKLINK} ${CWD}/fish/functions $@


#== git ================================================================================================================
git: ${XDG_CONFIG_HOME}/git/config ${XDG_CONFIG_HOME}/git/ignore
${XDG_CONFIG_HOME}/git/config:
	@mkdir -p $(dir $@)
	@${MKLINK} ${CWD}/git/config $@
${XDG_CONFIG_HOME}/git/ignore:
	@mkdir -p $(dir $@)
	@${MKLINK} ${CWD}/git/ignore $@


#=======================================================================================================================
info:
	$(info EUID=${EUID})
	$(info XDG_CONFIG_HOME=${XDG_CONFIG_HOME})
	$(info XDG_DATA_HOME=${XDG_DATA_HOME})


test:
ifeq (${EUID},0)
	@echo EUID=${EUID}: Running root-specific stuff
else
	@echo EUID=${EUID}: Running non-root-specific stuff
endif
