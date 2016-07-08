;;; conf-org.el --- Org-mode configuration
;;

(require 'org)

(setq org-startup-indented t)
(setq org-hide-leading-stars t)
(setq org-odd-level-only nil)
(setq org-M-RET-may-split-line '((item) (default . t)))
(setq org-log-done 'time)	; 'time/'note
;(setq org-special-ctrl-a/e t)
;(setq org-return-follows-link nil)
(setq org-use-speed-commands nil)
(setq org-startup-align-all-tables nil)
;(setq org-log-into-drawer nil)
(setq org-tags-column 1)
(setq org-ellipsis " \u25bc" )      ; Use fancy arrow to indicate a fold rather than '...'
(setq org-hide-emphasis-markers t)  ; Hide markers for bold/italics etc.
;(setq org-speed-commands-user nil)
;(setq org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))
;(setq org-completion-use-ido t)
(setq org-indent-mode t)
;(setq org-startup-truncated nil)
(setq org-src-fontify-natively t)
(setq org-link-search-must-match-exact-headline nil)

(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCEL(c)")))

;; Variable pitch for non-code text
;(defun set-buffer-variable-pitch ()
;  (interactive)
;  (variable-pitch-mode t)
;  (setq line-spacing 3)
;  (set-face-attribute 'org-table            nil :inherit 'fixed-pitch)
;  (set-face-attribute 'org-code             nil :inherit 'fixed-pitch)
;  (set-face-attribute 'org-block            nil :inherit 'fixed-pitch)
;  (set-face-attribute 'org-block-background nil :inherit 'fixed-pitch)
;)
;
;(add-hook 'org-mode-hook 'set-buffer-variable-pitch)
;(add-hook 'eww-mode-hook 'set-buffer-variable-pitch)
;(add-hook 'markdown-mode-hook 'set-buffer-variable-pitch)
;(add-hook 'Info-mode-hook 'set-buffer-variable-pitch)


;;; Keybindings



(provide 'conf-org)
;;; conf-org.el ends here
