;;; ui.el --- All settings for UI
;;

; (require 'spaceline-config)
; (spaceline-spacemacs-theme)


;; Theme options
(add-to-list 'custom-theme-load-path (concat *emacsd-directory* "/themes"))
(add-to-list 'load-path (concat *emacsd-directory* "/themes"))
(load-theme 'monokai t)
; (load-theme 'adwaita t)

;; Set frame position and size size
(setq default-frame-alist
      '((top    . 0)
        (left   . 0)
        (width  . 271)
        (height . 70)))

(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))  ; Disable vertical scrolls bars

(setq inhibit-splash-screen   t      )  ; Cleaner startup
(setq inhibit-startup-message t      )
(setq column-number-mode      t      )  ; Show column number in bottom bar
(setq ring-bell-function      'ignore)  ; Disable anoying beep
(setq redisplay-dont-pause    t      )  ; Improve rendering performance

(tool-bar-mode   -1)
(show-paren-mode  1)
(scroll-bar-mode -1)
(set-face-attribute 'default nil :height 105)

;; Line numbers
(add-hook 'prog-mode-hook 'linum-mode)
(setq linum-format "%4d ")

;; Highlight current line
;(global-hl-line-mode 1)

;; Undo and Redo windows
;; (winner-mode 1)

;; Start maximized
;(switch-fullscreen)                                                              ; Open in fullscreen
;(custom-set-variables '(initial-frame-alist (quote ((fullscreen . maximized))))) ; Start maximized

;; Transparency
;(set-frame-parameter (selected-frame) 'alpha '(85 85))
;(add-to-list 'default-frame-alist '(alpha 85 85))



(provide 'ui)
;;; ui.el ends here
