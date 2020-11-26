# Based on https://gitlab.com/to1ne/literate-dotfiles/blob/master/Makefile
# gnu make functions: https://www.gnu.org/software/make/manual/html_node/Functions.html
TANGLE := emacs --batch --no-init-file --load emacs/tangle.el --funcall literate-dotfiles-tangle
XDG_CONFIG_HOME ?= ${HOME}/.config
XDG_DATA_HOME ?= ${HOME}/.local/share
MKLINK := ln -svTf


all: dotfiles-priv base16-fzf base16-shell bash emacs git tmux misc


#== dotfiles-priv ======================================================================================================
dotfiles-priv: ${XDG_CONFIG_HOME}/dotfiles-priv
${XDG_CONFIG_HOME}/dotfiles-priv:
	git clone git@github.com:kshenoy/dotfiles-priv ${XDG_CONFIG_HOME}/dotfiles-priv


#== bash ===============================================================================================================
bash: bash/bashrc bash/dircolors ripgreprc ${HOME}/.bashrc ${XDG_DATA_HOME}/bash_history
# Using grouped targets here to run tangle bash/bashrc.org only once. Supported only for make versions >= 4.3
bash/bashrc bash/dircolors ripgreprc &: bash/bashrc.org
	${TANGLE} $<
# FIXME: Temporary workaround as bashrc is tangled to /tmp at the moment
	@touch $@
${HOME}/.bashrc:
	@${MKLINK} ${PWD}/bash/bashrc $@
${XDG_DATA_HOME}/bash_history:
	mkdir -p ${XDG_DATA_HOME}/bash_history
	@command rm -i ${HOME}/.bash_history 2> /dev/null


#== base16-fzf =========================================================================================================
base16-fzf: ${XDG_CONFIG_HOME}/base16-fzf
${XDG_CONFIG_HOME}/base16-fzf:
	git clone https://github.com/fnune/base16-fzf ${XDG_CONFIG_HOME}/base16-fzf


#== base16-shell =======================================================================================================
base16-shell: ${XDG_CONFIG_HOME}/base16-shell
${XDG_CONFIG_HOME}/base16-shell:
	git clone https://github.com/chriskempson/base16-shell.git ${XDG_CONFIG_HOME}/base16-shell


#== emacs ==============================================================================================================
emacs: chemacs emacs-vanilla emacs-doom ${HOME}/bin/emacs_daemon

chemacs: ${HOME}/.emacs ${HOME}/.emacs-profiles.el
${HOME}/.emacs:
	wget -O ${HOME}/.emacs https://raw.githubusercontent.com/plexus/chemacs/master/.emacs
${HOME}/.emacs-profiles.el:
	@${MKLINK} ${PWD}/emacs/emacs-profiles.el $@

emacs-vanilla: emacs/vanilla/init.el emacs/vanilla/bookmarks emacs/vanilla/snippets
emacs/vanilla/init.el: emacs/vanilla/config.org
	emacs --batch --load emacs/tangle.el --funcall literate-dotfiles-tangle $<
emacs/vanilla/bookmarks:
	@${MKLINK} ${PWD}/emacs/bookmarks $@
emacs/vanilla/snippets:
	@${MKLINK} ${PWD}/emacs/snippets $@

emacs-doom: ${XDG_CONFIG_HOME}/doom-emacs ${XDG_CONFIG_HOME}/doom emacs/doom/config.el emacs/doom/bookmarks
${XDG_CONFIG_HOME}/doom-emacs ${XDG_CONFIG_HOME}/doom-emacs/bin/doom:
	git clone https://github.com/hlissner/doom-emacs $(dir $@)
${XDG_CONFIG_HOME}/doom:
	@${MKLINK} ${PWD}/emacs/doom $@
emacs/doom/config.el: emacs/doom/config.org
	${XDG_CONFIG_HOME}/doom-emacs/bin/doom sync
emacs/doom/bookmarks:
	@${MKLINK} ${PWD}/emacs/bookmarks $@

${HOME}/bin/emacs_daemon:
	@${MKLINK} ${PWD}/scripts/emacs_daemon $@


#== git ================================================================================================================
git: git/config ${XDG_CONFIG_HOME}/git ${XDG_CONFIG_HOME}/git/config ${XDG_CONFIG_HOME}/git/ignore
git/config: git/git.org
	${TANGLE} $@
${XDG_CONFIG_HOME}/git:
	mkdir -p $@
${XDG_CONFIG_HOME}/git/config:
	@${MKLINK} ${PWD}/git/config $@
${XDG_CONFIG_HOME}/git/ignore:
	@${MKLINK} ${PWD}/git/ignore $@


#== tmux ===============================================================================================================
tmux: tmux/tmux.conf ${XDG_CONFIG_HOME}/tmux ${XDG_CONFIG_HOME}/tmux/.tmux.conf
tmux/tmux.conf: tmux/tmux.org
	${TANGLE} $@
${XDG_CONFIG_HOME}/tmux:
	mkdir -p $@
${XDG_CONFIG_HOME}/tmux/.tmux.conf:
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


#== misc ===============================================================================================================
misc: ${HOME}/.ssh/config ${HOME}/.Xresources ${HOME}/.ctags ${HOME}/.fzf.bash ${HOME}/bin/rgf ${HOME}/.unison/dotfiles.prf ${HOME}/.xinitrc ${HOME}/pipe 
${HOME}/.ssh/config:
	mkdir -p $(dir $@)
	@${MKLINK} ${XDG_CONFIG_HOME}/dotfiles-priv/ssh/config $@
${HOME}/.Xresources:
	@${MKLINK} ${PWD}/Xresources $@
${HOME}/.ctags:
	@${MKLINK} ${PWD}/ctags $@
${HOME}/.fzf.bash:
	@${MKLINK} ${PWD}/fzf/fzf.bash $@
${HOME}/bin/rgf:
	@${MKLINK} ${PWD}/scripts/rgf $@
${HOME}/.unison/dotfiles.prf:
	mkdir -p $(dir $@)
	@${MKLINK} ${PWD}/unison/dotfiles.prf $@
${HOME}/.xinitrc:
	@${MKLINK} ${PWD}/xinitrc $@
${HOME}/pipe:
	mkfifo $@


#=======================================================================================================================
clean:
	rm bash/dircolors ripgreprc emacs/vanilla/config.el git/config tmux/tmux.conf


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
