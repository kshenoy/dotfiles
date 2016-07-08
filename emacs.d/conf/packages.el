;;; packages.el --- Load all packages
;;

;;; Bootstrap
(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("org"   . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("gnu"   . "http://elpa.gnu.org/packages/"))

;; Install and load use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(require 'bind-key)

;; Use-package related settings
(setq use-package-always-ensure t)


;;; Packages
(use-package evil
  ;:disabled
  :config
    (use-package evil-commentary)
    (use-package evil-exchange)
    (use-package evil-indent-textobject)
    (use-package evil-leader)
    (use-package evil-matchit)
    (use-package evil-numbers)
    (use-package evil-org)
    (use-package evil-search-highlight-persist)
    (use-package evil-surround)
    (use-package evil-visualstar)
    (require 'conf-evil))

(use-package helm
  ;:disabled
  :config
    (require 'conf-helm))

(use-package projectile
  ;:disabled
  :config
    (require 'conf-projectile))

(use-package spaceline
  ;:disabled
  :config
    (setq powerline-default-separator 'wave))

(use-package monokai-theme
  ;:disabled
  :no-require t
  :config
  (setq monokai-use-variable-pitch nil
        monokai-height-plus-1      1.0
        monokai-height-plus-2      1.0
        monokai-height-plus-3      1.0
        monokai-height-plus-4      1.0
        monokai-height-minus-1     1.0))

;'helm-projectile
;'yasnippet
;'magit

;; (use-package org-wunderlist
;;   ;:disabled
;;   :config
;;     (require 'org-wunderlist)
;;     (setq org-wunderlist-client-id "087775c9aa61b33a45ab"
;;           org-wunderlist-token "9ca164feeaa29bbdfdaa3fe833fe3712c889c0253981ac8016661482592d"
;;           org-wunderlist-file  "~/org-wunderlist/Wunderlist.org"
;;           org-wunderlist-dir "~/org-wunderlist/"))

(require 'conf-org)



(provide 'packages)
;;; packages ends here
