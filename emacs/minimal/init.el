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
;; (use-package solarized-theme)
