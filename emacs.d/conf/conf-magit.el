;;; conf-magit.el --- Magit configurations
;;

;; Magit, dont fuck with me!
(setq magit-push-always-verify nil)

(defadvice magit-status (around magit-fullscreen activate)
  "Run magit in fullscreen mode."
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restore the previous window configuration and kill the magit buffer."
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))



;;; Keybindings
;(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)
;(global-set-key (kbd "C-c g") 'magit-status)
;(global-set-key (kbd "M-g c") 'magit-checkout)



(provide 'conf-magit)
;;; conf-magit.el ends here
