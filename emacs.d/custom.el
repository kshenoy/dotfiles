(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-emacs-state-cursor (quote ("#839496" bar)) t)
 '(evil-insert-state-cursor (quote ("#268bd2" bar)) t)
 '(evil-normal-state-cursor (quote ("#859900" box)) t)
 '(evil-operator-state-cursor (quote ("#dc322f" hollow)) t)
 '(evil-replace-state-cursor (quote ("#dc322f" bar)) t)
 '(evil-visual-state-cursor (quote ("#b58900" box)) t)
 '(package-selected-packages (quote (org-plus-contrib use-package)))
 '(safe-local-variable-values
   (quote
    ((eval add-hook
           (quote after-save-hook)
           (lambda nil
             (org-babel-tangle))
           nil t)
     (org-refile-targets
      (nil :maxlevel . 9))
     (org-confirm-babel-evaluate)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
