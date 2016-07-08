;;; general.el --- Settings and configurations for Emacs itself
;;

;; default directory
;(setq default-directory *projects-directory*)

;; Backup
(defvar --backup-directory (concat user-emacs-directory "/tmp/backups"))
(if (not (file-exists-p --backup-directory))
    (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files         t)  ; backup of a file the first time it is saved.
(setq backup-by-copying         t)  ; don't clobber symlinks
(setq version-control           t)  ; version numbers for backup files
(setq delete-old-versions       t)  ; delete excess backup files silently
(setq delete-by-moving-to-trash t)
(setq kept-old-versions         6)  ; oldest versions to keep when a new numbered backup is made (default: 2)
(setq kept-new-versions         9)  ; newest versions to keep when a new numbered backup is made (default: 2)

;; Auto-save
(defvar --autosave-directory (concat user-emacs-directory "/tmp/autosaves"))
(if (not (file-exists-p --autosave-directory))
    (make-directory --autosave-directory t))
(setq auto-save-file-name-transforms `(("." ,--autosave-directory t)))
(setq auto-save-default t)  ; auto-save every buffer that visits a file

;(setq display-buffer-reuse-frames t)   ; If a frame is alredy open, use it!
;(delete-selection-mode 1)              ; Replace marked text when typing
;(subword-mode 1)                       ; move cursor by camelCase
(fset 'yes-or-no-p 'y-or-n-p)           ; enable y/n answers

;; make indentation commands use space only
;(setq-default indent-tabs-mode nil)

;; dired configurations
;(put 'dired-find-file-other-buffer 'disabled t)
;(setq dired-listing-switches "-alh")

;; whitespace display
(setq-default indent-tabs-mode nil)    ; use only spaces and no tabs
(setq default-tab-width 2)
;(global-whitespace-mode)
;(setq whitespace-global-modes
;      '(not magit-mode git-commit-mode))
;(setq whitespace-style '(face trailing tabs))


;; Custom file for UI configurations
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)



(provide 'general)
;;; general.el ends here
