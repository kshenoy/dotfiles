;;; conf-helm.el --- Helm configuration
;;

(require 'helm-config)

(setq helm-quick-update                 t  )
(setq helm-buffers-fuzzy-matching       t  )
(setq helm-recentf-fuzzy-match          t  )
(setq helm-split-window-in-side-p       t  )  ; open helm buffer inside current window, not occupy whole other window
(setq helm-move-to-line-cycle-in-source t  )  ; move to end or beginning of source when reaching top or bottom of source
(setq helm-M-x-fuzzy-match              t  )
(setq helm-display-header-line          nil)  ; Disable the header


;; Remove header line if only a single source; keep them for multiple sources
;(set-face-attribute 'helm-source-header nil :height 0.1)  ; Disable the source header
(defvar helm-source-header-default-background (face-attribute 'helm-source-header :background))
(defvar helm-source-header-default-foreground (face-attribute 'helm-source-header :foreground))
(defvar helm-source-header-default-box (face-attribute 'helm-source-header :box))

(defun helm-toggle-header-line ()
  (if (> (length helm-sources) 1)
      (set-face-attribute 'helm-source-header
                          nil
                          :foreground helm-source-header-default-foreground
                          :background helm-source-header-default-background
                          :box helm-source-header-default-box
                          :height 1.0)
      (set-face-attribute 'helm-source-header
                          nil
                          :foreground (face-attribute 'helm-selection :background)
                          :background (face-attribute 'helm-selection :background)
                          :box nil
                          :height 0.1)))



;;; Keybindings

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(unbind-key "C-x c")
(bind-key* (kbd "M-x") 'helm-M-x)

(bind-keys :prefix-map helm-command-prefix
           :prefix "C-c h"
             (""  . helm-command-prefix)
             ("b" . helm-buffers-list)
             ("f" . helm-find-files)
             ("m" . helm-mini))



(helm-mode            t)
(helm-autoresize-mode t)

(provide 'conf-helm)
;;; conf-helm.el ends here
