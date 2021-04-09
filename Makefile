# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
TANGLE := emacs --batch --no-init-file --load emacs/tangle.el --funcall literate-dotfiles-tangle
XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_DATA_HOME ?= ${HOME}/.local/share
MKLINK := ln -svTf


all: dotfiles-priv base16-fzf base16-shell bash emacs git tmux vim links
# Rules not included in all: xmonad


#== dotfiles-priv ======================================================================================================
dotfiles-priv: ${XDG_CONFIG_HOME}/dotfiles-priv
${XDG_CONFIG_HOME}/dotfiles-priv:
	if [ ! -d $@ ]; then git clone git@github.com:kshenoy/dotfiles-priv $@; fi


#== bash ===============================================================================================================
# My usual approach is to save the tangled file in the repo and create links to it from elsewhere.
# I prefer this to tangling directly and not linking, as in case I have to setup on a machine that doesn't have emacs,
# I can use the tangled version of the file saved in the repo
# However, this approach doesn't work on files which have machine-specific configuration as everytime I tangle it,
# the saved version of the file gets updated, thereby affecting the link
# Hence, a workaround at the moment is to tangle to the location and copy it over to the repo
bash: ${HOME}/.bashrc bash/dircolors ripgreprc
# Using grouped targets here to run tangle bash/bashrc.org only once. Supported only for make versions >= 4.3
${HOME}/.bashrc bash/dircolors ripgreprc &: bash/bashrc.org
	${TANGLE} $<
	@mkdir -p ${XDG_DATA_HOME}/bash_history
	@if [ -f ${HOME}/.bash_history ]; then rm ${HOME}/.bash_history; fi
	@cp ${HOME}/.bashrc bash/bashrc_literate


#== base16-fzf =========================================================================================================
base16-fzf: ${XDG_CONFIG_HOME}/base16-fzf
${XDG_CONFIG_HOME}/base16-fzf:
	if [ ! -d $@ ]; then git clone https://github.com/fnune/base16-fzf $@; fi


#== base16-shell =======================================================================================================
base16-shell: ${XDG_CONFIG_HOME}/base16-shell
${XDG_CONFIG_HOME}/base16-shell:
	if [ ! -d $@ ]; then git clone https://github.com/chriskempson/base16-shell.git $@; fi


#== emacs ==============================================================================================================
emacs: chemacs emacs-doom emacs-vanilla ${HOME}/bin/emacs_daemon

chemacs: ${XDG_CONFIG_HOME}/emacs ${XDG_CONFIG_HOME}/chemacs/profiles.el
${XDG_CONFIG_HOME}/emacs:
	if [ ! -d $@ ]; then git clone https://github.com/plexus/chemacs2 $@; fi
${XDG_CONFIG_HOME}/chemacs/profiles.el:
	@mkdir -p $(dir $@)
	@${MKLINK} ${PWD}/emacs/chemacs-profiles.el $@

emacs-doom: ${XDG_CONFIG_HOME}/doom-emacs ${XDG_CONFIG_HOME}/doom emacs/doom/config.el emacs/doom/init.el emacs/doom/packages.el emacs/doom/bookmarks
${XDG_CONFIG_HOME}/doom-emacs:
	if [ ! -d $@ ]; then git clone https://github.com/hlissner/doom-emacs $@; fi
${XDG_CONFIG_HOME}/doom:
	@${MKLINK} ${PWD}/emacs/doom $@
emacs/doom/config.el: emacs/doom/config.org
	${XDG_CONFIG_HOME}/doom-emacs/bin/doom sync
emacs/doom/init.el emacs/doom/packages.el:
	${XDG_CONFIG_HOME}/doom-emacs/bin/doom sync
emacs/doom/bookmarks:
	@${MKLINK} ${PWD}/emacs/bookmarks $@

emacs-vanilla: emacs/vanilla/init.el emacs/vanilla/bookmarks emacs/vanilla/snippets
emacs/vanilla/init.el: emacs/vanilla/config.org
	emacs --batch --load emacs/tangle.el --funcall literate-dotfiles-tangle $<
emacs/vanilla/bookmarks:
	@${MKLINK} ${PWD}/emacs/bookmarks $@
emacs/vanilla/snippets:
	@${MKLINK} ${PWD}/emacs/snippets $@

${HOME}/bin/emacs_daemon:
	@${MKLINK} ${PWD}/scripts/emacs_daemon $@


#== git ================================================================================================================
git: git/config ${XDG_CONFIG_HOME}/git/config ${XDG_CONFIG_HOME}/git/ignore
git/config: git/git.org
	${TANGLE} $<
${XDG_CONFIG_HOME}/git/config:
	@mkdir -p $(dir $@)
	@${MKLINK} ${PWD}/git/config $@
${XDG_CONFIG_HOME}/git/ignore:
	@${MKLINK} ${PWD}/git/ignore $@


#== tmux ===============================================================================================================
tmux: tmux/tmux.conf ${XDG_CONFIG_HOME}/tmux/tmux.conf
tmux/tmux.conf: tmux/tmux.org
	${TANGLE} $<
${XDG_CONFIG_HOME}/tmux/tmux.conf:
	@mkdir -p $(dir $@)
	@${MKLINK} ${PWD}/tmux/tmux.conf $@


#== vim ================================================================================================================
vim: ${HOME}/.vim ${HOME}/.config/nvim ${HOME}/bin/vile ${HOME}/bin/vim_merge vim/pack/rc_local
${HOME}/.vim:
	@${MKLINK} ${PWD}/vim $@
${HOME}/.config/nvim:
	@${MKLINK} ${PWD}/vim $@
${HOME}/bin/vile:
	@${MKLINK} ${PWD}/scripts/vile $@
${HOME}/bin/vim_merge:
	@${MKLINK} ${PWD}/scripts/vim_merge $@
vim/pack/rc_local:
	@${MKLINK} ${XDG_CONFIG_HOME}/dotfiles-priv/$@ $@


#== links ===============================================================================================================
links: ${XDG_CONFIG_HOME}/bat/config ${HOME}/.ssh/config ${HOME}/.Xresources ${HOME}/.ctags ${HOME}/bin/rgf ${HOME}/.unison/dotfiles.prf ${HOME}/pipe
${XDG_CONFIG_HOME}/bat/config:
	@mkdir -p $(dir $@)
	@${MKLINK} ${PWD}/bat.cfg $@
${HOME}/.ssh/config:
	@mkdir -p $(dir $@)
	@${MKLINK} ${XDG_CONFIG_HOME}/dotfiles-priv/ssh/config $@
${HOME}/.Xresources:
	@${MKLINK} ${PWD}/Xresources $@
${HOME}/.ctags:
	@${MKLINK} ${PWD}/ctags $@
${HOME}/bin/rgf:
	@${MKLINK} ${PWD}/scripts/rgf $@
${HOME}/.unison/dotfiles.prf:
	@mkdir -p $(dir $@)
	@${MKLINK} ${PWD}/unison/dotfiles.prf $@
${HOME}/pipe:
	if [ ! -p $@ ]; then mkfifo $@; fi


#== xmonad et al. ======================================================================================================
xmonad: ${XDG_CONFIG_HOME}/xmonad xmobar
${XDG_CONFIG_HOME}/xmonad:
	@${MKLINK} ${PWD}/xmonad $@

xmobar: ${XDG_CONFIG_HOME}/xmobar
${XDG_CONFIG_HOME}/xmobar:
	@${MKLINK} ${PWD}/xmobar $@


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
