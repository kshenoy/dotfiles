(require 'package)

;; Activate all the packages (in particular autoloads)
(package-initialize)

;; Add Melpa as the default Emacs Package repository
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defvar use-package-verbose t)
(setq use-package-always-ensure t)

;; Install all packages
(use-package solarized-theme
  :config (load-theme 'solarized-light t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (solarized-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
