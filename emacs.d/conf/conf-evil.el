;;; conf-evil.el --- Evil configuration
;;

; (setq evil-leader/in-all-states t)
; (global-evil-leader-mode)
(evil-mode t)
; (global-evil-jumper-mode)
(evil-commentary-mode t)
(global-evil-search-highlight-persist t)
(global-evil-surround-mode t)
(global-evil-visualstar-mode t)

; (evil-leader/set-leader ",")



;;; UI
;; Color the cursor to indicate the Evil mode. White to indicate that we've switched back to Emacs
(setq evil-normal-state-cursor   '("green"  box))
(setq evil-visual-state-cursor   '("orange" box))
(setq evil-insert-state-cursor   '("red"    bar))
(setq evil-replace-state-cursor  '("red"    bar))
(setq evil-operator-state-cursor '("red"    hollow))
(setq evil-emacs-state-cursor    '("white"  box))



;;; Keybindings
;; Make escape quit everything, whenever possible.
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(bind-key [escape] 'keyboard-quit            evil-normal-state-map          )
(bind-key [escape] 'keyboard-quit            evil-visual-state-map          )
(bind-key [escape] 'minibuffer-keyboard-quit minibuffer-local-map           )
(bind-key [escape] 'minibuffer-keyboard-quit minibuffer-local-ns-map        )
(bind-key [escape] 'minibuffer-keyboard-quit minibuffer-local-completion-map)
(bind-key [escape] 'minibuffer-keyboard-quit minibuffer-local-must-match-map)
(bind-key [escape] 'minibuffer-keyboard-quit minibuffer-local-isearch-map   )

;; evil-exchange: Exchange text more easily within Evil
;(setq evil-exchange-key (kbd "cx"))
; (evil-exchange-install)



(provide 'conf-evil)
;;; conf-evil.el ends here
