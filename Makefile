# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
TANGLE := emacs --batch --no-init-file --load emacs/tangle.el --funcall literate-dotfiles-tangle
XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_DATA_HOME ?= ${HOME}/.local/share
MKLINK := ln -svTf
CWD := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))


all: dotfiles-priv base16-fzf base16-shell bash emacs fish git nvim tmux vim links


#== dotfiles-priv ======================================================================================================
dotfiles-priv: ${XDG_CONFIG_HOME}/dotfiles-priv
${XDG_CONFIG_HOME}/dotfiles-priv:
	if [ ! -d $@ ]; then git clone git@github.com:kshenoy/dotfiles-priv $@; fi


#== base16-fzf =========================================================================================================
base16-fzf: ${XDG_CONFIG_HOME}/base16-fzf
${XDG_CONFIG_HOME}/base16-fzf:
	if [ ! -d $@ ]; then git clone https://github.com/fnune/base16-fzf $@; fi


#== base16-shell =======================================================================================================
base16-shell: ${XDG_CONFIG_HOME}/base16-shell
${XDG_CONFIG_HOME}/base16-shell:
	if [ ! -d $@ ]; then git clone https://github.com/chriskempson/base16-shell.git $@; fi


#== bash ===============================================================================================================
# My usual approach is to save the tangled file in the repo and create links to it from elsewhere.
# I prefer this to tangling directly and not linking, as in case I have to setup on a machine that doesn't have emacs,
# I can use the tangled version of the file saved in the repo
# However, this approach doesn't work on files which have machine-specific configuration as everytime I tangle it,
# the saved version of the file gets updated, thereby affecting the link
# Hence, a workaround at the moment is to tangle to the location and copy it over to the repo
bash: bash/bashrc bash/dircolors.rc ripgrep/config ${HOME}/.bashrc
# Using grouped targets here to run tangle only once. Supported only for make versions >= 4.3
bash/bashrc bash/dircolors.rc ripgrep/config &: bash/bashrc.org
	${TANGLE} $<
	@mkdir -p ${XDG_DATA_HOME}/bash_history
	@if [ -f ${HOME}/.bash_history ]; then rm ${HOME}/.bash_history; fi
${HOME}/.bashrc:
	@${MKLINK} ${CWD}/bash/bashrc $@


#== emacs ==============================================================================================================
emacs: chemacs doom

chemacs: ${XDG_CONFIG_HOME}/emacs ${XDG_CONFIG_HOME}/chemacs
${XDG_CONFIG_HOME}/emacs:
	if [ ! -d $@ ]; then git clone https://github.com/plexus/chemacs2 $@; fi
${XDG_CONFIG_HOME}/chemacs:
	@${MKLINK} ${CWD}/chemacs $@

emacs-doom: ${XDG_CONFIG_HOME}/emacs-doom ${XDG_CONFIG_HOME}/doom
${XDG_CONFIG_HOME}/emacs-doom:
	if [ ! -d $@ ]; then \
	  git clone https://github.com/hlissner/doom-emacs $@; \
	  $@/bin/doom install; \
	fi
${XDG_CONFIG_HOME}/doom:
	@${MKLINK} ${CWD}/doom $@


#== fish ===============================================================================================================
fish: fish/config.fish ${XDG_CONFIG_HOME}/fish
fish/config.fish: fish/fish.org
	${TANGLE} $<
${XDG_CONFIG_HOME}/fish:
	@${MKLINK} ${CWD}/fish $@


#== git ================================================================================================================
git: git/config git/ignore ${XDG_CONFIG_HOME}/git
# Using grouped targets here to run tangle only once. Supported only for make versions >= 4.3
git/config git/ignore &: git/git.org
	${TANGLE} $<
${XDG_CONFIG_HOME}/git &:
	@${MKLINK} ${CWD}/git $@


#== nvim =================================================================================================================
nvim: ${XDG_CONFIG_HOME}/nvim
${XDG_CONFIG_HOME}/nvim:
	@${MKLINK} ${CWD}/nvim $@


#== tmux ===============================================================================================================
tmux: tmux/tmux.conf ${XDG_CONFIG_HOME}/tmux
tmux/tmux.conf: tmux/tmux.org
	${TANGLE} $<
${XDG_CONFIG_HOME}/tmux:
	@${MKLINK} ${CWD}/tmux $@


#== vim ================================================================================================================
vim: ${HOME}/.vim ${HOME}/bin/vile ${HOME}/bin/vim_merge vim/pack/rc_local
${HOME}/.vim:
	@${MKLINK} ${CWD}/vim $@
${HOME}/bin/vile:
	@${MKLINK} ${CWD}/scripts/vile $@
${HOME}/bin/vim_merge:
	@${MKLINK} ${CWD}/scripts/vim_merge $@
vim/pack/rc_local:
	@${MKLINK} ${XDG_CONFIG_HOME}/dotfiles-priv/$@ $@


#== links ===============================================================================================================
links: ${XDG_CONFIG_HOME}/bat ${HOME}/.ssh/config ${HOME}/.Xresources ${HOME}/.ctags ${HOME}/bin/rgf ${HOME}/.unison ${HOME}/pipe
${XDG_CONFIG_HOME}/bat:
	@${MKLINK} ${CWD}/bat $@
${HOME}/.ssh/config:
	@mkdir -p $(dir $@)
	@${MKLINK} ${XDG_CONFIG_HOME}/dotfiles-priv/ssh/config $@
${HOME}/.Xresources:
	@${MKLINK} ${CWD}/Xresources $@
${HOME}/.ctags:
	@${MKLINK} ${CWD}/ctags/config.ctags $@
${HOME}/bin/rgf:
	@${MKLINK} ${CWD}/scripts/rgf $@
${HOME}/.unison:
	@${MKLINK} ${CWD}/unison $@
${HOME}/pipe:
	if [ ! -p $@ ]; then mkfifo $@; fi


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
