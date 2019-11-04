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
 '(package-selected-packages
   (quote
    (use-package-hydra eyebrowse pos-tip popup s magit-popup git-commit with-editor async pkg-info epl string-inflection goto-chg org-protocol-capture-html quelpa-use-package quelpa company-tng try magit company-box delight yasnippet which-key rainbow-mode rainbow-delimiters popup-kill-ring pcre2el org-bullets noflet modern-cpp-font-lock ivy-rich counsel swiper ivy-hydra ivy hydra flycheck evil-visualstar evil-surround evil-string-inflection evil-numbers evil-matchit evil-exchange evil-commentary evil-args evil company-irony company beacon avy aggressive-indent org-plus-contrib use-package)))
 '(safe-local-variable-values
   (quote
    ((eval ispell-hunspell-add-multi-dic "en_US,es_MX")
     (eval ispell-set-spellchecker-params)
     (org-src-preserve-indentation . t)
     (org-enforce-todo-dependencies)
     (org-enforce-todo-checkbox-dependencies)
     (eval add-hook
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
 '(erc-my-nick-prefix-face ((t (:inherit erc-current-nick-face :weight bold))))
 '(rcirc-bright-nick ((t (:inherit rcirc-other-nick :underline t))))
 '(rcirc-dim-nick ((t (:foreground "#93a1a1"))))
 '(rcirc-my-nick ((t (:foreground "#cb4b16"))))
 '(rcirc-nick-in-message ((t (:inherit rcirc-my-nick))))
 '(rcirc-nick-in-message-full-line ((t (:slant italic))))
 '(rcirc-other-nick ((t (:foreground "#859900"))))
 '(rcirc-prompt ((t (:inherit rcirc-server))))
 '(rcirc-server ((t (:foreground "#268bd2"))))
 '(rcirc-server-prefix ((t (:inherit rcirc-server))))
 '(rcirc-url ((t (:foreground "royal blue")))))
