;; Detangling
;; [[https://www.youtube.com/watch?v=BLomb52wjvE][Yisrael Dov - Emacs is Great ep. 11]]


;; [[file:emacs.org::*Detangling][Detangling:1]]
;; This is a tangled file. Do not make any changes here. All changes should preferably be made in the original Org file.
;; Use =org-babel-tangle-jump-back-to-org= to jump back to it from any code block.
;; If any changes are made here, use =org-babel-detangle= to add it back to the original Org mode file.
;; Detangling:1 ends here

;; Bootstrap package.el
;; Initialize the packaging system and add the Melpa and Org respositories to get latest versions of packages

;; [[file:emacs.org::*Bootstrap package.el][Bootstrap package.el:1]]
(require 'package)
(setq-default load-prefer-newer t
              package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)
;; Bootstrap package.el:1 ends here



;; Install packages automatically

;; [[file:emacs.org::*Bootstrap package.el][Bootstrap package.el:2]]
(setq-default use-package-always-ensure t)
;; Bootstrap package.el:2 ends here

;; Bootstrap straight.el

;; [[file:emacs.org::*Bootstrap straight.el][Bootstrap straight.el:1]]
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "http://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; Bootstrap straight.el:1 ends here



;; and install use-package as well

;; [[file:emacs.org::*Bootstrap straight.el][Bootstrap straight.el:2]]
(straight-use-package 'use-package)
;; Bootstrap straight.el:2 ends here

;; custom file

;; [[file:emacs.org::*custom file][custom file:1]]
(setq-default custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)
;; custom file:1 ends here

;; Keybindings

;; [[file:emacs.org::*Keybindings][Keybindings:1]]
(bind-keys* :prefix-map my-fuzzy-jumper-command-map
            :prefix-docstring "This map is used to put all keybindings that I use to jump around eg. open files, buffers etc."
            :prefix "C-c f")

(bind-keys* :prefix-map my-auto-completion-map
            :prefix-docstring "This map is used to put all auto-completion related keybindings"
            :prefix "C-c c")

(bind-keys* :prefix-map my-goto-map
            :prefix-docstring "This map is used to put all movement related keybindings"
            :prefix "C-c g")

(bind-keys* :prefix-map my-s-bindings-map
            :prefix-docstring "This map is used to group together all s-mnemonic bindings such as substitution, sizing etc."
            :prefix "C-c s")
;; Keybindings:1 ends here



;; I think the following would be handy
;;   =[= - Enable setting
;;   =t= - Toggle setting
;;   =]= - Disable setting
;; Original use of =C-c [= and =C-c ]= is to manipulate =org-agenda-files=. Since I don't use either of these, might as well put them to better use.


;; [[file:emacs.org::*Keybindings][Keybindings:2]]
(bind-keys* :prefix-map my-settings-enable-map
            :prefix-docstring "This map is used to enable settings ala vim-unimpaired"
            :prefix "C-c [")

(bind-keys* :prefix-map my-settings-disable-map
            :prefix-docstring "This map is used to disable settings ala vim-unimpaired"
            :prefix "C-c ]")

(bind-keys* :prefix-map my-settings-toggle-map
            :prefix-docstring "This map is used to toggle settings"
            :prefix "C-c t")
;; Keybindings:2 ends here



;; To delete existing bindings, use =(unbind-key ...)=


;; [[file:emacs.org::*Keybindings][Keybindings:3]]
(bind-key* "C-h B" 'describe-personal-keybindings)
;; Keybindings:3 ends here



;; By default =C-h c= is bound to =describe-key-briefly= which seems wasted with =describe-key= doing a better job.

;; [[file:emacs.org::*Keybindings][Keybindings:4]]
(bind-key* "C-h c" 'describe-char)
;; Keybindings:4 ends here



;; By default C-x = is bound to =what-cursor-position=. With evil binding =g a= and =g 8= to the same function, it is wasted. Might as well bind it to calc

;; [[file:emacs.org::*Keybindings][Keybindings:5]]
(bind-key* "C-x =" 'calc)
;; Keybindings:5 ends here

;; revert-buffer

;; [[file:emacs.org::*revert-buffer][revert-buffer:1]]
(defun my-revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))

(bind-key* "<f5>" 'my-revert-buffer-no-confirm)
;; revert-buffer:1 ends here

;; describe-keymap
;; [[https://stackoverflow.com/a/36994486/734153][From StackOverflow]]

;; [[file:emacs.org::*describe-keymap][describe-keymap:1]]
(defun my-describe-keymap (keymap)
  "Describe a keymap using `substitute-command-keys'."
  (interactive
   (list (completing-read
          "Keymap: " (let (maps)
                       (mapatoms (lambda (sym)
                                   (and (boundp sym)
                                        (keymapp (symbol-value sym))
                                        (push sym maps))))
                       maps)
          nil t)))
  (with-output-to-temp-buffer (format "*keymap: %s*" keymap)
    (princ (format "%s\n\n" keymap))
    (princ (substitute-command-keys (format "\\{%s}" keymap)))
    (with-current-buffer standard-output ;; temp buffer
      (setq help-xref-stack-item (list #'my-describe-keymap keymap)))))

(bind-key "K" 'my-describe-keymap help-map)
;; describe-keymap:1 ends here

;; Autosave, Backup and History
;; Change default location of backups to avoid littering PWD

;; [[file:emacs.org::*Autosave, Backup and History][Autosave, Backup and History:1]]
(defvar backup-directory (concat user-emacs-directory "tmp/backups"))
(unless (file-exists-p backup-directory)
  (make-directory backup-directory t))
;; Autosave, Backup and History:1 ends here

;; [[file:emacs.org::*Autosave, Backup and History][Autosave, Backup and History:2]]
(setq backup-directory-alist `(("." . ,backup-directory)))
(setq make-backup-files         t)  ; backup of a file the first time it is saved.
(setq backup-by-copying         t)  ; don't clobber symlinks
(setq version-control           t)  ; version numbers for backup files
(setq delete-old-versions       t)  ; delete excess backup files silently
(setq delete-by-moving-to-trash t)
(setq kept-old-versions         6)  ; oldest versions to keep when a new numbered backup is made (default: 2)
(setq kept-new-versions         9)  ; newest versions to keep when a new numbered backup is made (default: 2)
;; Autosave, Backup and History:2 ends here



;; Change default location of autosaves to avoid littering PWD

;; [[file:emacs.org::*Autosave, Backup and History][Autosave, Backup and History:3]]
(defvar autosave-directory (concat user-emacs-directory "tmp/autosaves/"))
(if (not (file-exists-p autosave-directory)) (make-directory autosave-directory t))
;; Autosave, Backup and History:3 ends here

;; [[file:emacs.org::*Autosave, Backup and History][Autosave, Backup and History:4]]
;; (setq auto-save-file-name-transforms `(("." ,autosave-directory t)))
(setq auto-save-default t)  ; auto-save every buffer that visits a file
;; Autosave, Backup and History:4 ends here



;; Delete identical history entries

;; [[file:emacs.org::*Autosave, Backup and History][Autosave, Backup and History:5]]
(setq history-delete-duplicates t)
;; Autosave, Backup and History:5 ends here



;; Save mini-buffer history

;; [[file:emacs.org::*Autosave, Backup and History][Autosave, Backup and History:6]]
(use-package savehist
  :init
  (setq savehist-file (concat user-emacs-directory "tmp/history.el")
        history-length 100)
  :config
  (savehist-mode t))
;; Autosave, Backup and History:6 ends here

;; Remove visual clutter

;; [[file:emacs.org::*Remove visual clutter][Remove visual clutter:1]]
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
;; Remove visual clutter:1 ends here

;; Better defaults

;; [[file:emacs.org::*Better defaults][Better defaults:1]]
(setq-default mouse-wheel-follow-mouse t          ; Mouse-wheel acts on the hovered window instead of where the cursor is
              echo-keystrokes 0.1                 ; Let emacs react faster to keystrokes
              confirm-kill-emacs 'y-or-n-p        ; Confirm before quitting
              ring-bell-function 'ignore          ; Disable anoying beep
              redisplay-dont-pause t              ; Improve rendering performance
              indicate-empty-lines t              ; Display a glyph in the fringe of each empty line at the end of the buffer
              help-window-select t                ; Jump to the help window when it's opened.
              right-margin-width 1
              uniquify-buffer-name-style 'forward ; Better unique buffer names
              window-combination-resize t         ; Resize windows proportionally
              x-stretch-cursor t)                 ; Stretch cursor to the glyph width

(column-number-mode t)               ; Show column no. in mode-line
(global-visual-line-mode t)          ; Enable editing by visual lines
(fset 'yes-or-no-p 'y-or-n-p)        ; Simpler y/n answers
;; Better defaults:1 ends here

;; Winner mode - Undo/redo window layouts
;; Undo and Redo changes in window configuration. Use =C-c right=, =C-c left= (default bindings) to switch between different layouts.
;; This is useful when I close a window by mistake to undo it and restore the window layout.

;; [[file:emacs.org::*Winner mode - Undo/redo window layouts][Winner mode - Undo/redo window layouts:1]]
(winner-mode 1)
;; Winner mode - Undo/redo window layouts:1 ends here

;; Diff
;; From [[http://pragmaticemacs.com/emacs/visualise-and-copy-differences-between-files/][Pragmatic Emacs]]

;; [[file:emacs.org::*Diff][Diff:1]]
(use-package ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain  ; Don't start another frame
        ediff-split-window-function 'split-window-horizontally) ; Put windows side by side
  (add-hook 'ediff-after-quit-hook-internal 'winner-undo)) ; Revert windows on exit (needs winner mode)
;; Diff:1 ends here


;; A complete list of all running servers can be found under /tmp/emacs$UID but it's [[http://emacshorrors.com/posts/determining-if-the-server-is-started-or-the-wonders-of-server-running-p.html][a little more complicated]] than that.

;; So, let's just start a server if one isn't running. A downside of this is that it won't persist once emacs is killed

;; [[file:emacs.org::*Emacs server][Emacs server:5]]
(use-package server
  :ensure nil
  :defer 5
  :config
  (unless (server-running-p server-name)
    (server-start)))
;; Emacs server:5 ends here

;; Fonts
;; Font madness in Emacs: https://idiocy.org/emacs-fonts-and-fontsets.html
;; [[https://app.programmingfonts.org/][Test Drive Programming Fonts]]; I settled on Iosevka

;; Scale font size using =C-x C-+= and =C-x C--=. =C-x C-0= resets it.
;; =text-scale-mode-step= controls the scaling factor. For obvious reasons, don't set it to 1 else it won't change at all

;; [[file:emacs.org::*Fonts][Fonts:1]]
(setq-default text-scale-mode-step 1.1
              line-spacing 1)
;; Fonts:1 ends here

;; [[file:emacs.org::*Fonts][Fonts:3]]
(defun my-set-font-if-exists (type font)
  "Check if FONT exists and set TYPE if it does."
  (when (and (display-graphic-p)(x-list-fonts font))
    (set-face-attribute type nil :font font)
    t))  ; This is required so that we can use this function in a cond block below

(defun my-set-fonts()
  (cond
   ;; ((and (eq system-type 'windows-nt) (my-set-font-if-exists 'default "Consolas-9")) t)
   (t (my-set-font-if-exists 'default "Iosevka-10")))

  (cond
   ;; ((and (eq system-type 'gnu/linux) (my-set-font-if-exists 'fixed-pitch "DejaVu Sans Mono-10")) t)
   (t (set-face-attribute 'fixed-pitch nil :family 'unspecified :inherit 'default)))

  (cond
   ;; ((and (eq system-type 'gnu/linux) (my-set-font-if-exists 'variable-pitch "DejaVu Sans-10")) t)
   (t (set-face-attribute 'variable-pitch nil :family 'unspecified :inherit 'default)))
  )

(my-set-fonts)
;; Fonts:3 ends here



;; Use UTF-8 wherever possible

;; [[file:emacs.org::*Fonts][Fonts:4]]
(setq locale-coding-system   'utf-8)
(set-terminal-coding-system  'utf-8)
(set-keyboard-coding-system  'utf-8)
(set-selection-coding-system 'utf-8)
(set-language-environment    "UTF-8")
(prefer-coding-system        'utf-8)
;; Fonts:4 ends here

;; Intelligent narrowing and widening
;; From [[http://endlessparentheses.com/emacs-narrow-or-widen-dwim.html][endless parentheses]]


;; [[file:emacs.org::*Intelligent narrowing and widening][Intelligent narrowing and widening:1]]
(defun my-narrow-or-widen-dwim (p)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree, or defun, whichever applies first.
Narrowing to org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer is already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing command.
         ;; Remove this first conditional if you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))

;; This line actually replaces Emacs' entire narrowing keymap.
(bind-key "n" 'my-narrow-or-widen-dwim ctl-x-map)
;; Intelligent narrowing and widening:1 ends here

;; Highlight current line

;; [[file:emacs.org::*Highlight current line][Highlight current line:1]]
(bind-key "c" 'global-hl-line-mode my-settings-toggle-map)
;; Highlight current line:1 ends here

;; Insert and show matching delimiters

;; [[file:emacs.org::*Insert and show matching delimiters][Insert and show matching delimiters:1]]
(electric-pair-mode t)
(show-paren-mode 1)
(setq show-paren-delay 0)
;; (setq show-paren-style 'expression)
;; Insert and show matching delimiters:1 ends here

;; Pretty symbols
;; Replaces the text /lambda/ with λ. Full list of prettified symbols can be found in =prettify-symbols-alist=
;; The =inhibit-compacting-font-caches= stops garbage collect from trying to handle font caches making things a lot faster

;; [[file:emacs.org::*Pretty symbols][Pretty symbols:1]]
(global-prettify-symbols-mode t)
(setq inhibit-compacting-font-caches t)
(setq prettify-symbols-unprettify-at-point 'right-edge)
;; Pretty symbols:1 ends here



;; Default symbols that must be applied to all modes.
;; NOTE: Some symbols occupy less space and may affect indendation. In order to avoid this: (From [[http://endlessparentheses.com/using-prettify-symbols-in-clojure-and-elisp-without-breaking-indentation.html][endlessparentheses]])

;; [[file:emacs.org::*Pretty symbols][Pretty symbols:2]]
(defun my-pretty-symbols-default()
  (mapc (lambda(pair) (push pair prettify-symbols-alist))
        '(("!=" . (?\s (Br . Bl) ?\s (Bc . Bc) ?≠))
          ("<=" . (?\s (Br . Bl) ?\s (Bc . Bc) ?≤))
          (">=" . (?\s (Br . Bl) ?\s (Bc . Bc) ?≥)))))

(add-hook 'prog-mode-hook (lambda() (my-pretty-symbols-default)))
;; Pretty symbols:2 ends here



;; C/C++ specific symbols

;; [[file:emacs.org::*Pretty symbols][Pretty symbols:3]]
(add-hook 'c++-mode-hook
          (lambda() (mapc (lambda(pair) (push pair prettify-symbols-alist))
                     '(("->" . (?- (Br . Bc) ?- (Br . Bc) ?>))))))
;; Pretty symbols:3 ends here

;; Tabs, Indentation and Spacing
;; :PROPERTIES:
;; :ID:       8d72d9c2-5b52-454f-892a-107b009563fa
;; :END:
;; Use only spaces and no tabs

;; [[id:8d72d9c2-5b52-454f-892a-107b009563fa][Tabs, Indentation and Spacing:1]]
(setq-default indent-tabs-mode nil
              show-trailing-whitespace nil
              sh-basic-offset 2)

(setq sentence-end-double-space nil) ; Count 1 space after a period as the end of a sentence, instead of 2

;; (bind-key "RET" 'newline-and-indent)
;; Tabs, Indentation and Spacing:1 ends here

;; Highlight trailing whitespace

;; [[file:emacs.org::*Highlight trailing whitespace][Highlight trailing whitespace:1]]
(defun my-toggle-trailing-whitespace ()
  "Toggle trailing whitespace"
  (interactive)  ; Allows to be called as a command via M-x
  (setq-default show-trailing-whitespace (not show-trailing-whitespace)))

(bind-key "SPC" 'my-toggle-trailing-whitespace my-settings-toggle-map)
;; Highlight trailing whitespace:1 ends here



;; Enable it only in some modes

;; [[file:emacs.org::*Highlight trailing whitespace][Highlight trailing whitespace:2]]
(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook (lambda() (setq show-trailing-whitespace t))))
;; Highlight trailing whitespace:2 ends here

;; Delete trailing whitespace
;; Automatically while saving (from [[https://www.emacswiki.org/emacs/DeletingWhitespace#toc3][emacswiki]])

;; [[file:emacs.org::*Delete trailing whitespace][Delete trailing whitespace:1]]
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; Delete trailing whitespace:1 ends here



;; Use =C-c s SPC= to delete trailing whitespace manually

;; [[file:emacs.org::*Delete trailing whitespace][Delete trailing whitespace:2]]
(bind-key "SPC" 'delete-trailing-whitespace my-s-bindings-map)
;; Delete trailing whitespace:2 ends here

;; Toggle wrap

;; [[file:emacs.org::*Toggle wrap][Toggle wrap:1]]
(bind-key "w" 'toggle-truncate-lines my-settings-toggle-map)
;; Toggle wrap:1 ends here

;; Terminal
;; Specify the shell to use to avoid prompt. From [[https://youtu.be/L9vA7FHoQnk?list=PLX2044Ew-UVVv31a0-Qn3dA6Sd_-NyA1n&t=192][Uncle Dave's video]]

;; [[file:emacs.org::*Terminal][Terminal:1]]
(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)
;; Terminal:1 ends here



;; Launch

;; [[file:emacs.org::*Terminal][Terminal:2]]
(bind-key* "<s-return>" 'ansi-term)
;; Terminal:2 ends here

;; TODO Unload all loaded themes before loading new theme
;; :PROPERTIES:
;; :CREATED:  [2019-01-24 Thu 22:22]
;; :END:
;; :LOGBOOK:
;; - State "TODO"       from              [2019-01-24 Thu 22:22]
;; :END:
;; http://www.greghendershott.com/2017/02/emacs-themes.html
;; By default emacs layers the new theme on top of all previously applied themes.

;; [[file:emacs.org::*Unload all loaded themes before loading new theme][Unload all loaded themes before loading new theme:1]]
(defun my-disable-all-themes ()
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))
;; Unload all loaded themes before loading new theme:1 ends here

;; load-theme hook
;; Emacs doesn't have a native hook that is called after a theme has loaded. So we've to create one. (from [[https://www.reddit.com/r/emacs/comments/4v7tcj/does_emacs_have_a_hook_for_when_the_theme_changes/d5wyu1r/][reddit]])

;; [[file:emacs.org::*load-theme hook][load-theme hook:1]]
(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")
(defadvice load-theme (after run-after-load-theme-hook activate)
  "Run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))
;; load-theme hook:1 ends here

;; [[https://github.com/bbatsov/solarized-emacs][solarized]]

;; [[file:emacs.org::*\[\[https:/github.com/bbatsov/solarized-emacs\]\[solarized\]\]][[[https://github.com/bbatsov/solarized-emacs][solarized]]:1]]
(use-package solarized-theme
  :init
  (setq solarized-distinct-fringe-background t
        solarized-use-variable-pitch t)
  :custom
  (evil-normal-state-cursor   '("#859900" box))
  (evil-visual-state-cursor   '("#b58900" box))
  (evil-insert-state-cursor   '("#268bd2" bar))
  (evil-replace-state-cursor  '("#dc322f" bar))
  (evil-operator-state-cursor '("#dc322f" hollow))
  (evil-emacs-state-cursor    '("#839496" bar))
  :config
  (load-theme 'solarized-light t))
;; [[https://github.com/bbatsov/solarized-emacs][solarized]]:1 ends here

;; IRC using [[https://www.gnu.org/software/emacs/manual/html_mono/rcirc.html][rcirc]]
;; :PROPERTIES:
;; :ID:       81b84d7b-1c28-4f0a-9039-e80af8063881
;; :CREATED:  [2019-01-30 Wed 20:12]
;; :END:
;; I'm using to rcirc access #emacs and #vim IRC channels on freenode

;; [[id:81b84d7b-1c28-4f0a-9039-e80af8063881][IRC using [[https://www.gnu.org/software/emacs/manual/html_mono/rcirc.html][rcirc]]:1]]
(use-package rcirc
  :commands rcirc

  :custom
  (rcirc-time-format "[%H:%M] ")
  (rcirc-fill-column 'window-text-width)
  (rcirc-default-nick "kshenoy")
  (rcirc-server-alist '(("irc.freenode.net" :channels ("#emacs" "#vim"))))
  (rcirc-prompt "%t> ")
;; IRC using [[https://www.gnu.org/software/emacs/manual/html_mono/rcirc.html][rcirc]]:1 ends here

;; Use better colors
;; I should probably make this a part of the theme but I'm going to keep it here for now

;; [[file:emacs.org::*Use better colors][Use better colors:1]]
:custom-face
(rcirc-other-nick ((t (:foreground "#268bd2"))))
(rcirc-bright-nick ((t (:foreground "#d33682"))))
(rcirc-dim-nick ((t (:foreground "#93a1a1"))))
(rcirc-my-nick ((t (:foreground "#cb4b16"))))
(rcirc-nick-in-message ((t (:inherit rcirc-my-nick))))
(rcirc-nick-in-message-full-line ((t (:slant italic))))
(rcirc-server ((t (:foreground "#859900"))))
(rcirc-server-prefix ((t (:inherit rcirc-server))))
(rcirc-prompt ((t (:inherit rcirc-my-nick))))
(rcirc-url ((t (:inherit org-link))))
;; Use better colors:1 ends here

;; Open rcirc in a new window-layout using eyebrowse
;; :PROPERTIES:
;; :ID:       b9c529de-8be7-4c3f-96bb-e4143b5d1d2c
;; :CREATED:  [2019-02-02 Sat 23:08]
;; :END:

;; [[id:b9c529de-8be7-4c3f-96bb-e4143b5d1d2c][Open rcirc in a new window-layout using eyebrowse:1]]
:config
(defun irc ()
  "Simple wrapper which opens rcirc in a predefined window layout using eyebrowse"
  (interactive)
  (eyebrowse-switch-to-window-config 9)
  (eyebrowse-rename-window-config 9 "IRC")
  (delete-other-windows)
  (rcirc nil))
;; Open rcirc in a new window-layout using eyebrowse:1 ends here

;; [[https://www.emacswiki.org/emacs/rcircNoNamesOnJoin][Don't display names when joining a channel]]
;; :PROPERTIES:
;; :ID:       ce06325b-1e07-476a-8659-6b5dd6d1b4ee
;; :CREATED:  [2019-01-31 Thu 08:02]
;; :END:

;; [[id:ce06325b-1e07-476a-8659-6b5dd6d1b4ee][[[https://www.emacswiki.org/emacs/rcircNoNamesOnJoin][Don't display names when joining a channel]]:1]]
(defvar rcirc-hide-names-on-join t
  "Non-nil if nick names list should be hidden when joining a channel.")

(defadvice rcirc-handler-353 (around my-aad-rcirc-handler-353 activate)
  "Do not render NICK list on join when `rcirc-hide-names-on-join' is non-nil.
 RPL_NAMREPLY."
  (when (not rcirc-hide-names-on-join)
    ad-do-it))

(defadvice rcirc-handler-366 (around my-aad-rcirc-handler-366 activate)
  "Do not render NICK list on join when `rcirc-hide-names-on-join' is non-nil.
 RPL_ENDOFNAMES."
  (when (not rcirc-hide-names-on-join)
    ad-do-it))

(defadvice rcirc-handler-JOIN (around my-before-ad-rcirc-handler-join-no-names activate)
  "Set `rcirc-hide-names-on-join' to `t'."
  ad-do-it
  (setq rcirc-hide-names-on-join t))

(defadvice rcirc-cmd-names (before my-ad-rcirc-cmd-names-no-list activate)
  "Reset rcirc-hide-names-on-join to nil after the JOIN step."
  (setq rcirc-hide-names-on-join nil)))
;; [[https://www.emacswiki.org/emacs/rcircNoNamesOnJoin][Don't display names when joining a channel]]:1 ends here

;; aggressive-indent

;; [[file:emacs.org::*aggressive-indent][aggressive-indent:1]]
(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))
;; aggressive-indent:1 ends here

;; all-the-icons
;; :PROPERTIES:
;; :ID:       c753c712-6fcc-4acf-a5c8-f867e2407e76
;; :CREATED:  [2019-02-12 Tue 22:07]
;; :END:

;; [[id:c753c712-6fcc-4acf-a5c8-f867e2407e76][all-the-icons:1]]
(use-package all-the-icons
  :straight
  (:host github :repo "domtronn/all-the-icons.el"))
;; all-the-icons:1 ends here

;; [[id:c753c712-6fcc-4acf-a5c8-f867e2407e76][all-the-icons:3]]
(use-package all-the-icons-ivy
  :after (all-the-icons ivy)
  :config
  (all-the-icons-ivy-setup))
;; all-the-icons:3 ends here

;; [[id:c753c712-6fcc-4acf-a5c8-f867e2407e76][all-the-icons:4]]
(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))
;; all-the-icons:4 ends here

;; avy
;; :PROPERTIES:
;; :ID:       d5dbbf1c-588b-44ec-be35-5e19dcd6201c
;; :END:
;; I'm using =C-'= instead of creating a binding in =my-goto-map= as that's the default binding used in an ivy-minibuffer
;; Also, I'm rebinding =M-g g= from =goto-line= as using a number with =avy-goto-line= makes it behave like =goto-line= anyway.
;; Besides, =M-g M-g= is still bound to =goto-line= by default as well as the =<N>G= binding from evil.


;; [[id:d5dbbf1c-588b-44ec-be35-5e19dcd6201c][avy:1]]
(use-package avy
  :after evil
  :bind* (("C-'" . avy-goto-char-timer)
          ("M-g g" . avy-goto-line))
  :bind (:map my-goto-map ("o" . avy-org-goto-heading-timer)))
;; avy:1 ends here

;; company
;; Provides auto-completion.
;; References:
;; - [[https://youtu.be/XeWZfruRu6k][Uncle Dave's video]] for an introduction.
;; - [[https://www.reddit.com/r/emacs/comments/8z4jcs/tip_how_to_integrate_company_as_completion][reddit:How to use company as a completion framework]]


;; [[file:emacs.org::*company][company:1]]
(use-package company
  :disabled
  :custom
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)           ; Show numbers in the drop-down menu to simplify selection
  (company-selection-wrap-around t)

  :config
  (global-company-mode)
;; company:1 ends here

;; Keybindings
;; Explicitly trigger yasnippet

;; [[file:emacs.org::*Keybindings][Keybindings:1]]
(bind-key "&" 'company-yasnippet my-auto-completion-map)
;; Keybindings:1 ends here



;; Replace Meta bindings with Ctrl

;; [[file:emacs.org::*Keybindings][Keybindings:2]]
(unbind-key "M-n" company-active-map)
(unbind-key "M-p" company-active-map)

(bind-keys :map company-active-map
           ("C-n" . company-select-next)
           ("C-p" . company-select-previous))
;; Keybindings:2 ends here

;; Don't get in the way of mah typing!
;; The intent of this section is to make company as unobtrusive as possible; I want company to show me completions as I type but I want complete control over if I want to accept it or not. By default, when the completion menu pops-up, the =company-active-map= is activated and it stays open while any key in it is pressed. However, what I find annoying is that it hijacks some bindings making them unavailable for regular use till I've either accepted a completion or explicitly rejected it using =C-g.=

;; To fix this, I'm going to start by unsetting =company-require-match= which shows the menu but doesn't select an entry which allows me to keep typing.

;; [[file:emacs.org::*Don't get in the way of mah typing!][Don't get in the way of mah typing!:1]]
(setq company-require-match nil)
;; Don't get in the way of mah typing!:1 ends here



;; Next, I'm going to use [[https://github.com/company-mode/company-mode/blob/master/company-tng.el][company-tng]] (/tab-n-go/) as the frontend which allows showing the menu with no entry selected.

;; [[file:emacs.org::*Don't get in the way of mah typing!][Don't get in the way of mah typing!:2]]
(require 'company-tng)
(setq company-frontends '(company-tng-frontend
                          company-pseudo-tooltip-frontend
                          company-echo-metadata-frontend))
;; Don't get in the way of mah typing!:2 ends here



;; I'm going to call this state as /not-explicitly-interacted-with-company/ and while in this state, I want to reduce the
;; number of keys bound in =company-active-map= to minimize my chances of needing to kill it to just be able to continue typing.
;; Unbinding keys from company-active-map allows me to use them for emacs' actions rather than for company's.

;; [[file:emacs.org::*Don't get in the way of mah typing!][Don't get in the way of mah typing!:3]]
(unbind-key "C-h"      company-active-map)
(unbind-key "C-s"      company-active-map)
(unbind-key "C-M-s"    company-active-map)
(unbind-key "C-w"      company-active-map)
(unbind-key "RET"      company-active-map)
(unbind-key "TAB"      company-active-map)
(unbind-key "<f1>"     company-active-map)
(unbind-key "<up>"     company-active-map)
(unbind-key "<down>"   company-active-map)
(unbind-key "<return>" company-active-map)
(unbind-key "<tab>"    company-active-map)
;; Don't get in the way of mah typing!:3 ends here

;; Enable yasnippet for all backends
;; (from [[https://emacs.stackexchange.com/a/10520/9690][emacs.stackexchange]])
;; Keeping this at the end to be run after we've added all backends

;; [[file:emacs.org::*Enable yasnippet for all backends][Enable yasnippet for all backends:1]]
(defun company-mode/backend-with-yas (backend)
  (if (and (listp backend) (member 'company-yasnippet backend))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends)))
;; Enable yasnippet for all backends:1 ends here

;; evil
;; Getting started guide: https://github.com/noctuid/evil-guide
;; evil can be toggled using =C-z=

;; [[file:emacs.org::*evil][evil:1]]
(use-package evil
  :init
  (setq evil-want-C-w-in-emacs-state t
        evil-want-Y-yank-to-eol t)
;; evil:1 ends here

;; :config

;; [[file:emacs.org::*:config][:config:1]]
:config
(evil-mode t)
;; :config:1 ends here



;; Mode specific states

;; [[file:emacs.org::*:config][:config:2]]
(dolist (mode '(git-rebase-mode dired-mode org-toc-mode))
  (evil-set-initial-state mode 'emacs))
(evil-set-initial-state 'term-mode 'insert)
;; :config:2 ends here



;; =evil-set-initial-state= works only for major modes. Thus for minor modes I have to use an explicit hook. Refer this [[https://github.com/emacs-evil/evil/issues/1115][github issue]] for details

;; [[file:emacs.org::*:config][:config:3]]
(dolist (hook '(org-capture-mode-hook))
  (add-hook hook 'evil-insert-state))

(dolist (hook '(edebug-mode-hook))
  (add-hook hook 'evil-emacs-state))
;; :config:3 ends here

;; Keybindings
;; :PROPERTIES:
;; :ID:       f42c3dc8-c2f6-4f22-9f47-0c578479ef67
;; :END:

;; [[id:f42c3dc8-c2f6-4f22-9f47-0c578479ef67][Keybindings:1]]
(defun my-unimpaired-insert-line-before ()
  "Insert blank line line before the current one"
  (interactive)
  (beginning-of-line)(open-line 1))

(defun my-unimpaired-insert-line-after ()
  "Insert blank line line after the current one"
  (interactive)
  (end-of-line)(newline))

(bind-keys :map evil-normal-state-map
           ("] SPC" . my-unimpaired-insert-line-after)
           ("[ SPC" . my-unimpaired-insert-line-before)
           ("] b"   . next-buffer)
           ("[ b"   . previous-buffer)
           ("] q"   . next-error)
           ("[ q"   . previous-error)
           ("[ Q"   . first-error))
;; Keybindings:1 ends here

;; [[id:f42c3dc8-c2f6-4f22-9f47-0c578479ef67][Keybindings:2]]
(add-hook 'org-mode-hook (lambda() (bind-key "z v" 'org-reveal evil-normal-state-map)))
;; Keybindings:2 ends here



;; <<Make Escape quit everything>>

;; [[id:f42c3dc8-c2f6-4f22-9f47-0c578479ef67][Keybindings:3]]
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))
;; Keybindings:3 ends here

;; Follow newly created splits

;; [[file:emacs.org::*Follow newly created splits][Follow newly created splits:1]]
(bind-keys :map evil-window-map
           ("s" . (lambda() (interactive) (evil-window-split)(other-window 1)))
           ("v" . (lambda() (interactive) (evil-window-vsplit)(other-window 1))))
;; Follow newly created splits:1 ends here

;; Move by visual lines
;; Note this is not a complete solution since it doesn't work when combined with operators (eg. =dj=)

;; [[file:emacs.org::*Move by visual lines][Move by visual lines:1]]
(bind-keys :map evil-motion-state-map
           ("j"  . evil-next-visual-line)
           ("gj" . evil-next-line)
           ("k"  . evil-previous-visual-line)
           ("gk" . evil-previous-line)
           ("$"  . evil-end-of-line)
           ("g$" . evil-end-of-visual-line))
;; Move by visual lines:1 ends here

;; Sensible rebindings

;; [[file:emacs.org::*Sensible rebindings][Sensible rebindings:1]]
(define-key key-translation-map (kbd "C-w C-h") (kbd "C-w h"))
(define-key key-translation-map (kbd "C-w C-j") (kbd "C-w j"))
(define-key key-translation-map (kbd "C-w C-k") (kbd "C-w k"))
(define-key key-translation-map (kbd "C-w C-l") (kbd "C-w l"))
(define-key key-translation-map (kbd "C-w C-s") (kbd "C-w s"))
(define-key key-translation-map (kbd "C-w C-v") (kbd "C-w v"))

(bind-key "U" 'redo evil-normal-state-map)
;; Sensible rebindings:1 ends here



;; More intuitive keybindings for winner-mode

;; [[file:emacs.org::*Sensible rebindings][Sensible rebindings:2]]
(bind-keys :map evil-window-map
           ("u" . winner-undo)
           ("U" . winner-redo)))
;; Sensible rebindings:2 ends here

;; evil-args

;; [[file:emacs.org::*evil-args][evil-args:1]]
(use-package evil-args
  :after evil
  :bind (:map evil-inner-text-objects-map
              ("," . evil-inner-arg)
         :map evil-outer-text-objects-map
              ("," . evil-outer-arg)
         :map evil-normal-state-map
              ("] ," . evil-forward-arg)
              ("[ ," . evil-backward-arg)
         :map evil-motion-state-map
              ("] ," . evil-forward-arg)
              ("[ ," . evil-backward-arg)))
;; evil-args:1 ends here

;; evil-commentary

;; [[file:emacs.org::*evil-commentary][evil-commentary:1]]
(use-package evil-commentary
  :after evil
  :bind (:map evil-normal-state-map
              ("g c" . evil-commentary)
         :map evil-visual-state-map
              ("g c" . evil-commentary)))
;; evil-commentary:1 ends here

;; evil-exchange

;; [[file:emacs.org::*evil-exchange][evil-exchange:1]]
(use-package evil-exchange
  :after evil
  :config (evil-exchange-cx-install))
;; evil-exchange:1 ends here

;; evil-matchit

;; [[file:emacs.org::*evil-matchit][evil-matchit:1]]
(use-package evil-matchit
  :after evil
  :config
  (global-evil-matchit-mode 1))
;; evil-matchit:1 ends here

;; evil-numbers

;; [[file:emacs.org::*evil-numbers][evil-numbers:1]]
(use-package evil-numbers
  :after evil
  :bind (:map evil-normal-state-map
             ("C-c +" . evil-numbers/inc-at-pt)
             ("C-c -" . evil-numbers/dec-at-pt)
         :map evil-visual-state-map
             ("C-c +" . evil-numbers/inc-at-pt)
             ("C-c -" . evil-numbers/dec-at-pt)))
;; evil-numbers:1 ends here

;; evil-string-inflection
;; Provides =g~= operator to cycle between snake_case → SCREAMING_SNAKE_CASE → TitleCase → CamelCase → kebab-case

;; [[file:emacs.org::*evil-string-inflection][evil-string-inflection:1]]
(use-package evil-string-inflection
  :after evil
  :bind (:map evil-normal-state-map
              ("g ~" . evil-operator-string-inflection)
         :map evil-visual-state-map
              ("g ~" . evil-operator-string-inflection)))
;; evil-string-inflection:1 ends here

;; evil-surround

;; [[file:emacs.org::*evil-surround][evil-surround:1]]
(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode))
;; evil-surround:1 ends here

;; evil-visualstar

;; [[file:emacs.org::*evil-visualstar][evil-visualstar:1]]
(use-package evil-visualstar
  :after evil
  :config (global-evil-visualstar-mode))
;; evil-visualstar:1 ends here

;; [[https://github.com/wasamasa/eyebrowse][eyebrowse]]
;; :PROPERTIES:
;; :ID:       49bd1e79-38fe-4046-86b2-5372e76496a1
;; :CREATED:  [2019-01-30 Wed 20:25]
;; :END:
;; Makes it easy to save and restore windows layout (kinda like tabs). eg. I have one window for rcirc, another for org-agenda and another for regular buffers etc.
;; I thought about using =gt= and =gT= but there are some buffers which are better used in emacs-state and, these won't work there so I'm going to stick with =C-c w= for the moment.

;; [[id:49bd1e79-38fe-4046-86b2-5372e76496a1][[[https://github.com/wasamasa/eyebrowse][eyebrowse]]:1]]
(use-package eyebrowse
  :init
  (setq eyebrowse-keymap-prefix (kbd "C-c w"))
  :custom
  (eyebrowse-wrap-around t)
  :config
  (eyebrowse-mode t)
  (bind-keys :map eyebrowse-mode-map
             ("C-c w w" . eyebrowse-last-window-config)
             ("C-c w C" . eyebrowse-close-window-config)
             ("C-c w N" . eyebrowse-create-window-config)))
;; [[https://github.com/wasamasa/eyebrowse][eyebrowse]]:1 ends here

;; hydra

;; [[file:emacs.org::*hydra][hydra:1]]
(use-package hydra)
;; hydra:1 ends here

;; ivy et al.

;; [[file:emacs.org::*ivy et al.][ivy et al.:1]]
(use-package ivy
  :custom
  (ivy-virtual-abbreviate 'abbreviate "Show abbreviated path in addition to the filename")
  :config
  (ivy-mode 1)
  (setq ivy-count-format "%d/%d "
        ivy-height 12
        ivy-extra-directories nil)
;; ivy et al.:1 ends here



;; Do not add a =^= (beginning of line anchor) while completing. Refer [[https://github.com/abo-abo/swiper/issues/140][this]] and [[https://github.com/abo-abo/swiper/issues/1126][this]].

;; [[file:emacs.org::*ivy et al.][ivy et al.:2]]
(setq ivy-initial-inputs-alist nil)
;; ivy et al.:2 ends here

;; Keybindings

;; [[file:emacs.org::*Keybindings][Keybindings:1]]
(bind-key* "C-c C-r" 'ivy-resume)
;; Keybindings:1 ends here

;; Show mix of buffers, recent files and bookmarks
;; There is a variable =ivy-use-virtual-buffers= that does this. However, it is static and when set, dumps everything in =ivy-switch-buffer=.
;; As a result, by default I have to choose one or the other; I can't have both. This fixes that.
;; =C-c f j= will show buffers, recent files and bookmarks while =C-c f b= will only show buffers

;; [[file:emacs.org::*Show mix of buffers, recent files and bookmarks][Show mix of buffers, recent files and bookmarks:1]]
(defun my-ivy-switch-virtual-buffer ()
  "Show recent files and bookmarks in the buffer list"
  (interactive)
  (let* ((ivy-use-virtual-buffers t))
    (ivy-switch-buffer)))

(defun my-counsel-p4 (&optional initial-input)
  "Find file in the current Perforce repository.
INITIAL-INPUT can be given as the initial minibuffer input."
  (interactive)
  (counsel-require-program counsel-p4-cmd)
  (let* ((default-directory (expand-file-name (counsel-locate-p4-root)))
         (cands (split-string
                 (shell-command-to-string counsel-p4-cmd)
                 "\n"
                 t)))
    (ivy-read "Find file: " cands
              :initial-input initial-input
              :action #'counsel-git-action
              :caller 'my-counsel-p4)))

(defun my-file-finder ()
  "Context based file finding"
  (interactive)
  (cond ((locate-dominating-file default-directory ".git") (counsel-git))
        ((locate-dominating-file default-directory "P4CONFIG") (my-counsel-p4))
        (t (counsel-fzf))))

(bind-keys :map my-fuzzy-jumper-command-map
           ("b" . ivy-switch-buffer)
           ("f" . my-file-finder)
           ("j" . my-ivy-switch-virtual-buffer)))
;; Show mix of buffers, recent files and bookmarks:1 ends here

;; ivy-hydra

;; [[file:emacs.org::*ivy-hydra][ivy-hydra:1]]
(use-package ivy-hydra
  :after (ivy hydra)
  :config
;; ivy-hydra:1 ends here

;; Customize the default ivy-hydra
;; Provides some vim-ish movements and calling methods. From [[https://github.com/abo-abo/hydra/wiki/hydra-ivy-replacement][here]]
;; eg. To kill multiple buffers
;; - =C-x b= to open the buffer list
;; - =C-o= to open the hydra menu
;; - Select the 'kill' action by pressing =o k= or select it by cycling through the actions using =w= and =s=
;; - Once the 'kill' action has been selected, select the buffer to kill using the movement keys and press =f= to execute the action
;; - Pressing =f= keeps the hydra menu open to allow selecting other buffers to execute the selected action


;; [[file:emacs.org::*Customize the default ivy-hydra][Customize the default ivy-hydra:1]]
(bind-key "C-o"
          (defhydra hydra-ivy (:hint nil :color pink)
            "
  Move         ^^^^^^^^^^|  Call           ^^|  Cancel  ^^|  Options  ^^|  Action _w_/_s_ _a_: %s(ivy-action-name)
---------------^^^^^^^^^^+-----------------^^+----------^^+-----------^^+-------------------------------
  _g_  ^ ^ _k_ ^ ^  _u_  |  e_x_ecute        |  _i_nsert  |  _c_alling: %-7s(if ivy-calling \"on\" \"off\")  _C_ase-fold: %-10`ivy-case-fold-search
  ^ ^  _h_ ^+^ _l_  ^ ^  |  _RET_: done      |  _q_uit    |  _m_atcher: %-7s(ivy--matcher-desc)^^^^^^^^^^^^  _t_runcate: %-11`truncate-lines
  _G_  ^ ^ _j_ ^ ^  _d_  |  _TAB_: alt-done  |          ^^|  _<_/_>_: shrink/grow
               ^^^^^^^^^^|  _o_ccur          |          ^^|
"
            ;; arrows
            ("j" ivy-next-line)
            ("k" ivy-previous-line)
            ("l" ivy-alt-done)
            ("h" ivy-backward-delete-char)
            ("g" ivy-beginning-of-buffer)
            ("G" ivy-end-of-buffer)
            ("d" ivy-scroll-up-command)
            ("u" ivy-scroll-down-command)
            ("e" ivy-scroll-down-command)
            ;; actions
            ("q" keyboard-escape-quit :exit t)
            ("C-g" keyboard-escape-quit :exit t)
            ("<escape>" keyboard-escape-quit :exit t)
            ("C-o" nil)
            ("i" nil)
            ("TAB" ivy-alt-done :exit nil)
            ("C-j" ivy-alt-done :exit nil)
            ;; ("d" ivy-done :exit t)
            ("RET" ivy-done :exit t)
            ("C-m" ivy-done :exit t)
            ("x" ivy-call)
            ("c" ivy-toggle-calling)
            ("m" ivy-toggle-fuzzy)
            (">" ivy-minibuffer-grow)
            ("<" ivy-minibuffer-shrink)
            ("w" ivy-prev-action)
            ("s" ivy-next-action)
            ("a" ivy-read-action)
            ("t" (setq truncate-lines (not truncate-lines)))
            ("C" ivy-toggle-case-fold)
            ("o" ivy-occur :exit t))
          ivy-minibuffer-map))
;; Customize the default ivy-hydra:1 ends here

;; swiper

;; [[file:emacs.org::*swiper][swiper:1]]
(use-package swiper
  :after ivy
  :bind* (("C-s" . swiper-isearch)
          ("C-M-s" . swiper-all))
  :config
  (when (executable-find "rg")
    (setq counsel-grep-base-command
          "rg --smart-case --max-columns 240 --no-heading --line-number --color never '%s' %s")))
;; swiper:1 ends here

;; counsel
;; NOTE: I'm deferring loading using =:commands= for those commands for which I cannot use =:bind= here
;; =counsel-org-tag= binding is defined only after org is loaded so I'm defining it there instead.
;; =counsel-org-goto= is set conditionally only if we're in org-mode

;; Also, I'm explicitly binding each command to its counsel variant to get it to work with ivy-rich.
;; eg. the default flavor of =M-x= will still have all fuzzy searching goodness that ivy brings. However,
;; using =counsel-M-x= causes ivy-rich to put a docstring in there which it doesn't do with the default flavor of =M-x=

;; NOTE: I'm deferring loading by using the =commands= keyword for =counsel-org-tag= because the binding for it,
;; =C-c C-q= is found in =org-mode-map= which hasn't been defined yet.

;; [[file:emacs.org::*counsel][counsel:1]]
(use-package counsel
  :after ivy
  :commands (counsel-org-tag counsel-org-goto counsel-semantic-or-imenu)

  :init
  (defun my-counsel-imenu ()
    "Use mode-specific commands if available else fallback to counsel-semantic-or-imenu"
    (interactive)
    (if (string= major-mode "org-mode")
        (counsel-org-goto)
      (counsel-semantic-or-imenu)))

  :bind* ("M-x" . counsel-M-x)
  :bind  (:map help-map
               ("a" . counsel-apropos)
               ("f" . counsel-describe-function)
               ("v" . counsel-describe-variable)
               :map my-fuzzy-jumper-command-map
               ("/" . counsel-rg)
               ("k" . counsel-bookmark)
               ("o" . my-counsel-imenu)
               :map my-s-bindings-map
               ("v" . counsel-set-variable)))
;; counsel:1 ends here

;; modern-c++-font-lock

;; [[file:emacs.org::*modern-c++-font-lock][modern-c++-font-lock:1]]
(use-package modern-cpp-font-lock
  :hook (c++-mode . modern-c++-font-lock-mode))
;; modern-c++-font-lock:1 ends here

;; org
;; :PROPERTIES:
;; :ID:       dc10f8d2-0831-4bb6-8775-0f5da3dd8243
;; :END:
;; I specifically grab [[https://orgmode.org/worg/org-contrib/index.html][org-plus-contrib]] from the org repository instead of the bundled version to be able to
;; - get the latest version of org
;; - use contributed packages such as [[https://code.orgmode.org/bzg/org-mode/raw/master/contrib/lisp/org-expiry.el][org-expiry]], [[https://orgmode.org/worg/org-contrib/org-drill.html][org-drill]] and org-id
;; I do this by leveraging [[:ensure]] and [[:pin]]

;; Resources: [[http://doc.norang.ca/org-mode.html][Organize Your Life in Plain Text]], [[http://orgmode.org/worg/org-configs/org-customization-guide.html][Customization guide]], [[https://www.reddit.com/r/emacs/comments/8nvnlu/extending_orgmode/dzz1el9][Extensions]]

;; #+name: org-config

;; [[id:dc10f8d2-0831-4bb6-8775-0f5da3dd8243][org-config]]
(use-package org
  :ensure org-plus-contrib
  :pin org
;; org-config ends here

;; :init

;; [[file:emacs.org::*:init][:init:1]]
:init
(setq org-directory "~/Documents/Notes/")
(setq org-default-notes-file (expand-file-name "Inbox.org" org-directory))

(setq org-use-speed-commands nil)
(setq org-startup-align-all-tables t)
(setq org-tags-column 'auto)
(setq org-hide-emphasis-markers t)  ; Hide markers for bold/italics etc.
(setq org-link-search-must-match-exact-headline nil)
(setq org-startup-with-inline-images t)
(setq org-imenu-depth 8)
;; :init:1 ends here

;; org-babel source blocks
;; Enable syntax highlighting within the source blocks and keep the editing popup window within the same window.
;; Also, strip leading and trailing empty lines if any.
;; /org-src-preserve-indentation/ will not add an extra level of indentation to the source code

;; [[file:emacs.org::*org-babel source blocks][org-babel source blocks:1]]
(setq org-src-fontify-natively                       t
      org-src-window-setup                           'current-window
      org-src-tab-acts-natively                      t)
;; org-babel source blocks:1 ends here



;; Languages which can be evaluated in Org-mode buffers.

;; [[file:emacs.org::*org-babel source blocks][org-babel source blocks:2]]
(org-babel-do-load-languages 'org-babel-load-languages
                             (append org-babel-load-languages
                                     '((python     . t)
                                       (ruby       . t)
                                       (perl       . t)
                                       (dot        . t)
                                       (C          . t))))
;; org-babel source blocks:2 ends here

;; Clean View

;; [[file:emacs.org::*Clean View][Clean View:1]]
(setq org-startup-indented t)
(setq org-startup-folded t)
(setq org-hide-leading-stars t)
(setq org-odd-level-only nil)

;; others: ▼, ↴, ⬎, ⤷, …, ⋱
(setq org-ellipsis " ▼")
;; Clean View:1 ends here

;; ToDo States
;; Custom keywords

;; [[file:emacs.org::*ToDo States][ToDo States:1]]
(setq org-todo-keywords '((sequence "TODO(t!)" "WAITING(w@/!)" "|" "DONE(d@/!)" "DEFER(f@/!)" "CANCEL(c@)")))
;; (setq org-todo-keyword-faces
;;       (quote (("TODO" :foreground "red" :weight bold)
;;               ("WAITING" :foreground "orange" :weight bold)
;;               ("DONE" :foreground "forest green" bold)
;;               ("CANCEL" :foreground "forest green" bold))))
;; ToDo States:1 ends here


;; =@=   - Log timestamp and note
;; =!=   - Log timestamp only
;; =x/y= - =x= takes affect when entering the state and
;;       =y= takes affect when exiting if the state being entered doesn't have any logging
;; Refer [[http://orgmode.org/manual/Tracking-TODO-state-changes.html][Tracking-TODO-state-changes]] for details

;; Add logging when task state changes

;; [[file:emacs.org::*ToDo States][ToDo States:2]]
(setq org-log-done nil  ; Not required as state changes are logged in the LOGBOOK
      org-log-redeadline 'note
      org-log-into-drawer t  ; Save state changes into LOGBOOK drawer instead of in the body
      org-treat-insert-todo-heading-as-state-change t
      org-enforce-todo-dependencies t)  ; Prevent parent task from being marked complete till all child TODOS are marked as complete
;; ToDo States:2 ends here



;; Change from any todo state to any other state using =C-c C-t KEY=

;; [[file:emacs.org::*ToDo States][ToDo States:3]]
(setq org-use-fast-todo-selection t)
;; ToDo States:3 ends here



;; This frees up S-left and S-right which I can then use to cycles through the todo states but skip setting timestamps and entering notes which is very convenient when all I want to do is change the status of an entry without changing its timestamps

;; [[file:emacs.org::*ToDo States][ToDo States:4]]
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
;; ToDo States:4 ends here

;; :config

;; [[file:emacs.org::*:config][:config:1]]
:config
(setq org-clock-idle-time nil)
;; (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
;; :config:1 ends here



;; For org-version >= 9.2, we have to use this. =C-c C-,= was also added in 9.2 and provides a menu to select an easy-template

;; [[id:851ad87b-250e-4c1e-83b1-6b4e1fa6b20d][[[info:org#Structure%20Templates][Easy Templates]]:2]]
(add-to-list 'org-structure-template-alist '("sc" . "src c++"))
(add-to-list 'org-structure-template-alist '("sl" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sp" . "src python"))
(add-to-list 'org-structure-template-alist '("ss" . "src bash"))
;; [[info:org#Structure%20Templates][Easy Templates]]:2 ends here

;; Combine setting and aligning of tags
;; :PROPERTIES:
;; :ID:       dec6b49c-e37f-40df-9870-769ed0e68d3b
;; :CREATED:  [2019-01-29 Tue 22:56]
;; :END:

;; [[id:dec6b49c-e37f-40df-9870-769ed0e68d3b][Combine setting and aligning of tags:1]]
(defun my-org-modify-tags (p)
  "Set tags by calling counsel-org-tags and align tags as well.
  If called with a prefix, only align tags"
  (interactive "P")
  (unless p (org-set-tags-command))
  (org-align-all-tags))
;; Combine setting and aligning of tags:1 ends here

;; Use ! to toggle timestamp type
;; :PROPERTIES:
;; :ID:       d4634d95-be37-4bdf-987e-22da5778e958
;; :CREATED:  [2019-02-08 Fri 11:00]
;; :END:
;; [[https://orgmode.org/manual/Creating-timestamps.html][By default]], org-mode uses =C-c .= and =C-c != to create active and inactive timestamps respectively.
;; However, I also have flycheck installed which conflicts with the =C-c != binding.

;; This allows me to use =C-c .= to insert a timestamp and when prompted to enter the date+time in the minibuffer, use =!= to toggle between active and inactive timestamps.
;; From [[http://emacs.stackexchange.com/questions/38062/configure-key-to-toggle-between-active-and-inactive-timestamps#38065][Emacs StackExchange]]. Also see [[Custom timestamp keymap]].


;; [[id:d4634d95-be37-4bdf-987e-22da5778e958][Use ! to toggle timestamp type:1]]
(defun org-toggle-time-stamp-activity ()
  "Toggle activity of time stamp or range at point."
  (interactive)
  (let ((pt (point)))
    (when (org-at-timestamp-p t)
      (goto-char (match-beginning 0))
      (when-let ((el (org-element-timestamp-parser))
                 (type (org-element-property :type el))
                 (type-str (symbol-name type))
                 (begin (org-element-property :begin el))
                 (end (org-element-property :end el)))
        (setq type-str
              (if (string-match "inactive" type-str)
                  (replace-regexp-in-string "inactive" "active" type-str)
                (replace-regexp-in-string "active" "inactive" type-str)))
        (org-element-put-property el :type (intern type-str))
        (goto-char end)
        (skip-syntax-backward "-")
        (delete-region begin (point))
        (insert (org-element-timestamp-interpreter el nil))
        (goto-char pt)))))

(defvar-local calendar-previous-buffer nil
  "Buffer been active when `calendar' was called.")

(defun calendar-save-previous-buffer (oldfun &rest args)
  "Save buffer been active at `calendar' in `calendar-previous-buffer'."
  (let ((buf (current-buffer)))
    (apply oldfun args)
    (setq calendar-previous-buffer buf)))

(advice-add #'calendar :around #'calendar-save-previous-buffer)

(defvar-local my-org-time-stamp-toggle nil
  "Make time inserted time stamp inactive after inserting with `my-org-time-stamp'.")

(defun org-time-stamp-toggle ()
  "Make time stamp active at the end of `my-org-time-stamp'."
  (interactive)
  (when-let ((win (minibuffer-selected-window))
             (buf (window-buffer win)))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (when (buffer-live-p calendar-previous-buffer)
          (set-buffer calendar-previous-buffer))
        (setq my-org-time-stamp-toggle (null my-org-time-stamp-toggle))
        (setq org-read-date-inactive my-org-time-stamp-toggle)))))

(define-key org-read-date-minibuffer-local-map "!" #'org-time-stamp-toggle)

(defun my-org-time-stamp (arg)
  "Like `org-time-stamp' with ARG but toggle activity with character !."
  (interactive "P")
  (setq my-org-time-stamp-toggle nil)
  (org-time-stamp arg)
  (when my-org-time-stamp-toggle
    (backward-char)
    (org-toggle-time-stamp-activity)
    (forward-char)))

(bind-key "C-c ." 'my-org-time-stamp org-mode-map)
;; Use ! to toggle timestamp type:1 ends here

;; Custom priorities
;; :PROPERTIES:
;; :ID:       30e03c98-7190-48ad-99fb-49e28afa50e9
;; :CREATED:  [2020-04-20 Mon 22:12]
;; :END:

;; Increase the no. of priority levels from 3 to 5 and change default priority to 'C'

;; [[id:30e03c98-7190-48ad-99fb-49e28afa50e9][Custom priorities:1]]
(setq org-default-priority 67
      org-highest-priority 65
      org-lowest-priority 69)
;; Custom priorities:1 ends here

;; org-refile
;; Resources:
;; - [[https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html][Aaron Bieber - Organizing Notes with Refile]]

;; By [[https://www.reddit.com/r/emacs/comments/4366f9/how_do_orgrefiletargets_work/czg008y/][/u/awalker4 on reddit]].
;; Show upto 9 levels of headings from the current file and 5 levels of headings from all agenda files

;; [[file:emacs.org::*org-refile][org-refile:1]]
(setq org-refile-targets
      '((nil . (:maxlevel . 9))
        (org-agenda-files . (:maxlevel . 5))))
;; org-refile:1 ends here


;; Each element of the list generates a set of possible targets.
;; /nil/ indicates that all the headings in the current buffer will be considered.

;; Following are from Aaron Bieber's post [[https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html][Organizing Notes with Refile]]

;; Creating new parents - To create new heading, add =/HeadingName= to the end when using refile (=C-c C-w=)

;; [[file:emacs.org::*org-refile][org-refile:2]]
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
;; org-refile:2 ends here



;; Store the timestamp when an entry is refiled

;; [[file:emacs.org::*org-refile][org-refile:3]]
(setq org-log-refile 'time)
;; org-refile:3 ends here

;; org-babel
;; Some org-babel [[https://github.com/dfeich/org-babel-examples][recipes]]


;; [[file:emacs.org::*org-babel][org-babel:1]]
(setq org-babel-default-header-args
      '((:results . "verbatim replace")))

(cond ((executable-find "clang++") (setq org-babel-C++-compiler "clang++"))
      ((executable-find "g++") (setq org-babel-C++-compiler "g++")))

(setq org-babel-default-header-args:C++
      '((:flags . "-std=c++14 -Wall -Wextra -Werror ${BOOST_HOME:+-L ${BOOST_HOME}/lib -I ${BOOST_HOME}/include} -L${HOME}/.local/lib -I${HOME}/.local/include -Wl,${BOOST_HOME:+-rpath ${BOOST_HOME}/lib}")))

(setq org-babel-default-header-args:perl
      '((:results . "output")))

(setq org-babel-python-command "python3")
;; org-babel:1 ends here

;; Refresh inline images after evaluating org-babel code
;; From https://emacs.stackexchange.com/a/9813/9690


;; [[file:emacs.org::*Refresh inline images after evaluating org-babel code][Refresh inline images after evaluating org-babel code:1]]
(defun my-fix-inline-images ()
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))

(add-hook 'org-babel-after-execute-hook 'my-fix-inline-images)
;; Refresh inline images after evaluating org-babel code:1 ends here

;; Jump to head/tail of any block, not just src blocks
;; :PROPERTIES:
;; :ID:       964101eb-3077-411d-b9e5-9011c055c4ff
;; :CREATED:  [2019-01-14 Mon 21:36]
;; :END:
;; =org-babel-goto-src-block-head= jumps to the beginning of a source block. This is super useful! Why restrict it only to source blocks?

;; [[id:964101eb-3077-411d-b9e5-9011c055c4ff][Jump to head/tail of any block, not just src blocks:1]]
(defun my-org-babel-goto-block-corner (p)
  "Go to the beginning of the current block.
  If called with a prefix, go to the end of the block"
  (interactive "P")
  (let* ((element (org-element-at-point)))
    (when (or (eq (org-element-type element) 'example-block)
              (eq (org-element-type element) 'src-block) )
      (let ((begin (org-element-property :begin element))
            (end (org-element-property :end element)))
        ;; Ensure point is not on a blank line after the block.
        (beginning-of-line)
        (skip-chars-forward " \r\t\n" end)
        (when (< (point) end)
          (goto-char (if p end begin))
          (when p
            (skip-chars-backward " \r\t\n")
            (beginning-of-line)))))))
;; Jump to head/tail of any block, not just src blocks:1 ends here

;; Capture templates
;; :PROPERTIES:
;; :CREATED:  [2018-12-28 Fri 23:04]
;; :END:

;; [[file:emacs.org::*Capture templates][Capture templates:1]]
(setq org-capture-templates
      '(("t" "TODO" entry
         (file org-default-notes-file)
         "* TODO %?\n:LOGBOOK:\n- State \"TODO\"       from              %U\n:END:"
         :jump-to-captured t :empty-lines 1)

        ("r" "Recommendation" item (file "Personal/Recommendations.org") "" :jump-to-captured t)

        ("x" "Misc etc." entry
         (file org-default-notes-file)
         "* %?"
         :jump-to-captured t :empty-lines 1)

        ("s" "Snippets")

        ("se" "Emacs snippets" entry
         (file "Software/emacs.org")
         "* %?"
         :jump-to-captured t :empty-lines 1)

        ("ss" "Shell snippets" entry
         (file "Software/shell.org")
         "* %?"
         :jump-to-captured t :empty-lines 1)

        ("sv" "Vim snippets" entry
         (file "Software/vim.org")
         "* %?"
         :jump-to-captured t :empty-lines 1)))
;; Capture templates:1 ends here

;; Create frames for easy org-capture directly from the OS

;; (credit: [[http://cestlaz.github.io/posts/using-emacs-24-capture-2/][here]])

;; [[file:emacs.org::*Create frames for easy org-capture directly from the OS][Create frames for easy org-capture directly from the OS:1]]
(use-package noflet
  :config
  (defun my-make-capture-frame ()
    "Create a new frame and run org-capture."
    (interactive)
    (select-frame-by-name "capture")
    (delete-other-windows)
    (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
      (counsel-org-capture))))

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))

(defadvice org-capture-destroy
    (after delete-capture-frame activate)
  "Advise capture-destroy to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))
;; Create frames for easy org-capture directly from the OS:1 ends here

;; Keybindings
;; :PROPERTIES:
;; :ID:       ebbf9970-d072-4b59-bcaa-5f4b3d71a7d7
;; :END:
;; Custom keymap for org-mode bindings.

;; [[id:ebbf9970-d072-4b59-bcaa-5f4b3d71a7d7][Keybindings:1]]
(bind-keys :prefix-map my-org-bindings-map
           :prefix-docstring "This map is used to group together all org-mode settings"
           :prefix "C-c o"
           ("a" . org-agenda)
           ("c" . counsel-org-capture))
;; :bind (("c" . calendar))
;; Keybindings:1 ends here



;; <<Custom timestamp keymap>>. Also see [[id:d4634d95-be37-4bdf-987e-22da5778e958][Using ! to toggle timestamp type]]


;; [[id:ebbf9970-d072-4b59-bcaa-5f4b3d71a7d7][Keybindings:2]]
(bind-key "C-c C-q" 'my-org-modify-tags org-mode-map)
;; Keybindings:2 ends here



;; Delete the result block using =C-c C-v C-k= where =C-c C-v= is the /org-babel-key-prefix/

;; [[id:ebbf9970-d072-4b59-bcaa-5f4b3d71a7d7][Keybindings:3]]
(define-key key-translation-map (kbd "C-c C-v C-k") (kbd "C-c C-v k"))
;; Keybindings:3 ends here



;; Repurpose =C-c C-v u= to jump to beginning/end of any block. =C-c C-v C-u= is left untouched to only jump to top of src blocks

;; [[id:ebbf9970-d072-4b59-bcaa-5f4b3d71a7d7][Keybindings:4]]
(bind-key "u" 'my-org-babel-goto-block-corner org-babel-map))
;; Keybindings:4 ends here

;; org-agenda

;; [[file:emacs.org::*org-agenda][org-agenda:1]]
(use-package org-agenda
  :after org
  :ensure nil
  :init
;; org-agenda:1 ends here



;; Filter out any unwanted files from the notes that I don't want to add to the agenda

;; [[file:emacs.org::*org-agenda][org-agenda:2]]
(setq org-agenda-files (seq-filter (lambda (x) (and 'file-exists-p
                                               (not (string-match-p "Spanish.org" x))))
                                   (directory-files-recursively org-directory "\\.org$")))
;; org-agenda:2 ends here

;; :config

;; [[file:emacs.org::*:config][:config:1]]
:config
;; :config:1 ends here



;; Force agenda to start on a Monday. By default, the agenda only shows the next 7 days. I want to see the previous week as well just in case I missed something. Hence, these combined will show entries starting from the previous Monday. [[https://old.reddit.com/r/orgmode/comments/8r70oh/make_orgagenda_show_this_month_and_also_previous/][Source]]

;; [[file:emacs.org::*:config][:config:2]]
(setq org-agenda-start-day "-6d"
      org-agenda-start-on-weekday 1
      org-agenda-span 'month)
;; :config:2 ends here



;; I don't want to see completed or already scheduled items

;; [[file:emacs.org::*:config][:config:3]]
(setq org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-scheduled-if-deadline-is-shown t
      org-agenda-skip-timestamp-if-done t
      org-agenda-skip-timestamp-if-deadline-is-shown t
      org-agenda-skip-additional-timestamps-same-entry t)
;; :config:3 ends here



;; This sets up how I want my org-agenda to be displayed - I want it to be the only thing visible.
;; I'm using eyebrowse to switch window layouts. One of the layouts is just org-agenda so I don't care about restoring the windows after quitting.

;; [[file:emacs.org::*:config][:config:4]]
(setq org-agenda-window-setup 'only-window
      org-agenda-show-all-dates nil)
;; :config:4 ends here

;; org-agenda custom commands
;; These are some helper functions Based on [[https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html][Aaron Bieber: An agenda for life with org-mode]]

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:1]]
(defun my-org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))

(defun my-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))
;; org-agenda custom commands:1 ends here

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:2]]
(setq org-agenda-custom-commands
      '(("d"                       ; key
         "Daily agenda and TODOs"  ; desc
         (                         ; cmds
;; org-agenda custom commands:2 ends here



;; All the high-priority tasks that are still pending

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:3]]
(tags "PRIORITY=\"A\""
      ((org-agenda-overriding-header "High-priority unfinished tasks:")
       (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))))
;; org-agenda custom commands:3 ends here



;; An agenda showing the previous week and the next couple of weeks

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:4]]
(agenda "")
;; org-agenda custom commands:4 ends here



;; All the remaining todos minus the high-priority ones

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:5]]
(alltodo ""
         ((org-agenda-overriding-header "ALL normal priority tasks:")
          (org-agenda-skip-function '(or (my-org-skip-subtree-if-habit)
                                         (my-org-skip-subtree-if-priority ?A)
                                         (org-agenda-skip-if nil '(scheduled deadline))))))
;; org-agenda custom commands:5 ends here

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:6]]
)  ; END of cmds
(  ; settings
;; org-agenda custom commands:6 ends here



;; Restrict agenda to non-work files and filter out any other unwanted files

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:7]]
(org-agenda-files (seq-filter (lambda (x) (and 'file-exists-p
                                          (not (string-match-p "Work/" x))))
                              org-agenda-files))
;; org-agenda custom commands:7 ends here

;; [[file:emacs.org::*org-agenda custom commands][org-agenda custom commands:8]]
))))
;; org-agenda custom commands:8 ends here

;; Keybindings
;; [[id:ebbf9970-d072-4b59-bcaa-5f4b3d71a7d7][General org keybindings]]
;; Open the custom "Daily agenda and all TODOs" directly. Based on [[http://emacs.stackexchange.com/a/868/9690][Emacs StackExchange]].

;; [[file:emacs.org::*Keybindings][Keybindings:1]]
(bind-key* "<f12>" '(lambda (&optional arg) (interactive "P")(org-agenda arg "w"))))
;; Keybindings:1 ends here

;; org-bullets
;; Other bullets to consider:
;; Default: "◉ ○ ✸ ✿"
;; Large: ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
;; Small: ► • ★ ▸


;; [[file:emacs.org::*org-bullets][org-bullets:1]]
(use-package org-bullets
  :after org
  :hook (org-mode . (lambda() (org-bullets-mode 1)))
  :custom (org-bullets-bullet-list '("✿")))
;; org-bullets:1 ends here

;; org-expiry
;; [[https://code.orgmode.org/bzg/org-mode/raw/master/contrib/lisp/org-expiry.el][org-expiry]] is provided by the [[https://orgmode.org/worg/org-contrib/index.html][org-plus-contrib]] from the org repo. Hence I use [[:ensure]] and [[:pin]] to grab it from there.
;; This allows me to add a =CREATED= property everytime I create a new org-heading. From [[https://stackoverflow.com/a/13285957/734153][here]].

;; [[file:emacs.org::*org-expiry][org-expiry:1]]
(use-package org-expiry
  :after org
  :ensure org-plus-contrib
  :pin org
  :init
  (setq org-expiry-inactive-timestamps t)  ; Don't put everything in the agenda view
  :config
  (org-expiry-insinuate)
;; org-expiry:1 ends here



;; Add CREATED property to captured items
;; :PROPERTIES:
;; :CREATED:  [2018-12-28 Fri 23:04]
;; :ID:       f9b19f45-ee3a-4f40-b8af-0e5966e4df35
;; :END:
;; From https://stackoverflow.com/a/16247032/734153

;; [[file:emacs.org::*org-expiry][org-expiry:2]]
(add-hook 'org-capture-prepare-finalize-hook 'org-expiry-insert-created))
;; org-expiry:2 ends here

;; org-id
;; I want to grab org-id from the [[https://orgmode.org/worg/org-contrib/index.html][org-plus-contrib]] package from org repo which I do by by specifying [[:ensure]] and [[:pin]]

;; [[file:emacs.org::*org-id][org-id:1]]
(use-package org-id
  :after org
  :ensure org-plus-contrib
  :pin org
  :init
  ; Setting this to true will create an ID for every entry which could become expensive when org-id-track-globally is enabled
  (setq org-id-link-to-org-use-id 'create-if-interactive)
  :config
;; org-id:1 ends here



;; To use completion, insert link using =C-c C-l= and select =id:= as type and completion should trigger.
;; =org-id-get-with-outline-path-completion= returns the ID of the selected heading and creates it if it doesn't have one already.
;; Details at [[http://emacs.stackexchange.com/a/12434/9690][Emacs StackExchange]]

;; [[file:emacs.org::*org-id][org-id:2]]
(defun org-id-complete-link (&optional arg)
  "Create an id: link using completion"
  (concat "id:" (org-id-get-with-outline-path-completion org-refile-targets)))

(org-link-set-parameters "id" :complete 'org-id-complete-link))
;; org-id:2 ends here

;; pcre2el
;; From [[https://www.reddit.com/r/emacs/comments/60nb8b/favorite_builtin_emacs_commands/df8h8hm/][/u/Irkry on reddit]]

;; [[file:emacs.org::*pcre2el][pcre2el:1]]
(use-package pcre2el
  :config (pcre-mode t))
;; pcre2el:1 ends here

;; popup-kill-ring
;; Use =M-y= to show a list of all killed/yanked text to paste at the cursor location

;; [[file:emacs.org::*popup-kill-ring][popup-kill-ring:1]]
(use-package popup-kill-ring
  :bind ("M-y" . popup-kill-ring))
;; popup-kill-ring:1 ends here

;; rainbow-delimiters
;; Use brighter colors

;; [[file:emacs.org::*rainbow-delimiters][rainbow-delimiters:1]]
(use-package rainbow-delimiters
  :bind (:map my-settings-toggle-map ("r" . rainbow-delimiters-mode))
  :config
  (set-face-attribute 'rainbow-delimiters-depth-1-face nil :foreground "dark orange")
  (set-face-attribute 'rainbow-delimiters-depth-2-face nil :foreground "deep pink")
  (set-face-attribute 'rainbow-delimiters-depth-3-face nil :foreground "chartreuse")
  (set-face-attribute 'rainbow-delimiters-depth-4-face nil :foreground "deep sky blue")
  (set-face-attribute 'rainbow-delimiters-depth-5-face nil :foreground "yellow")
  (set-face-attribute 'rainbow-delimiters-depth-6-face nil :foreground "orchid")
  (set-face-attribute 'rainbow-delimiters-depth-7-face nil :foreground "spring green")
  (set-face-attribute 'rainbow-delimiters-depth-8-face nil :foreground "sienna1"))
;; rainbow-delimiters:1 ends here

;; undo-tree
;; This lets us visually walk through the changes we've made, undo back to a certain point (or redo), and go down different branches.
;; Default binding is =C-x u=

;; [[file:emacs.org::*undo-tree][undo-tree:1]]
(use-package undo-tree
  :bind (:map my-settings-enable-map
              ("U" . undo-tree-visualize)
         :map my-settings-disable-map
              ("U" . undo-tree-visualizer-quit))
  :custom
  (undo-tree-visualizer-timestamps t)
  (undo-tree-visualizer-diff t))
;; undo-tree:1 ends here

;; which-key
;; Shows which keys can be pressed next.
;; eg. if you press =C-x= and wait a few seconds, a window pops up with all the key bindings following the currently entered incomplete command.

;; [[file:emacs.org::*which-key][which-key:1]]
(use-package which-key
  :config (which-key-mode))
;; which-key:1 ends here

;; yasnippet
;; Use =C-d= to clear the field without accepting the default field name


;; [[file:emacs.org::*yasnippet][yasnippet:1]]
(use-package yasnippet
  :commands (yas-reload-all yas-minor-mode)
  :init
  (add-hook 'c++-mode-hook (lambda() (yas-reload-all)(yas-minor-mode)))
  (setq-default yas-snippet-dirs (list (concat user-emacs-directory "snippets")))
  (setq yas-wrap-around-region t)  ; Automatically insert selected text at $0, if any
  :config
  (bind-keys :map yas-minor-mode-map
             ("C-c & n" . yas-new-snippet)
             ("C-c & s" . yas-insert-snippet)
             ("C-c & v" . yas-visit-snippet-file)
             ("C-c & r" . yas-reload-all)
             ("C-c & &" . yas-describe-tables)))
;; yasnippet:1 ends here

;; delight
;; Placing at end to be called after all packages are loaded

;; [[file:emacs.org::*delight][delight:1]]
(use-package delight
  :config
  (delight '((abbrev-mode nil t)
             (aggressive-indent-mode nil aggressive-indent)
             (company-mode nil company)
             (ivy-mode nil ivy)
             (org-indent-mode nil org-indent)
             (pcre-mode nil pcre2el)
             (undo-tree-mode nil undo-tree)
             (yas-minor-mode nil yasnippet)
             (which-key-mode nil which-key))))
;; delight:1 ends here

;; Private config

;; [[file:emacs.org::*Private config][Private config:1]]
(when (or (and (eq system-type 'gnu/linux) (string-match-p "atl" (system-name)))
          (and (eq system-type 'windows-nt) (string-match-p "MHDC" (system-name))))
  (load (expand-file-name "work.el" user-emacs-directory) t))
;; Private config:1 ends here
